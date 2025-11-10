import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AiService } from '../ai/ai.service';
import { PlanRecord } from '../records/plan-record.entity';
import { ChatMessage } from '../records/chat-message.entity';

@Injectable()
export class SmartPlannerService {
  constructor(
    private readonly ai: AiService,
    @InjectRepository(PlanRecord)
    private readonly planRepo: Repository<PlanRecord>,
    @InjectRepository(ChatMessage)
    private readonly msgRepo: Repository<ChatMessage>,
  ) {}

  async handleChat(sessionId: string, message: string) {
    // 1) guarda mensaje del usuario
    await this.msgRepo.save(
      this.msgRepo.create({
        sessionId,
        role: 'user',
        content: message,
      }),
    );

    // 2) arma historial (últimos 20 mensajes)
    const history = await this.msgRepo.find({
      where: { sessionId },
      order: { createdAt: 'ASC' },
      take: 40,
    });

    // mapear al formato del proveedor
    const groqHistory = history
      .filter((m) => m.role === 'user' || m.role === 'assistant')
      .map((m) => ({
        role: m.role as 'user' | 'assistant',
        content: m.content,
      }));

    // 3) llamar a la IA con contexto
    const result = await this.ai.chatWithContext(groqHistory, message);
    const { reply, plan } = result;

    // 4) guarda respuesta del asistente
    await this.msgRepo.save(
      this.msgRepo.create({
        sessionId,
        role: 'assistant',
        content: reply,
      }),
    );

    // 5) si hay plan, persiste resumen estructurado (auditoría / reporting)
    if (plan) {
      await this.planRepo.save(
        this.planRepo.create({
          sessionId,
          userMessage: message,
          aiReply: reply,
          plan,
        }),
      );
    }

    // 6) devuelve solo lo que el front necesita
    return { reply, plan: plan ?? null };
  }
}
