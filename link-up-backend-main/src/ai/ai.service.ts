import { Injectable } from '@nestjs/common';

type GroqMsg = { role: 'system' | 'user' | 'assistant'; content: string };

@Injectable()
export class AiService {
  private readonly apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  private readonly apiKey = process.env.GROQ_API_KEY ?? '';
  private readonly model = process.env.AI_MODEL || 'llama-3.1-8b-instant';
  private readonly temperature = Number.isNaN(parseFloat(process.env.AI_TEMPERATURE ?? ''))
    ? 0.4
    : parseFloat(process.env.AI_TEMPERATURE as string);

  // prompt de sistema: habla natural; si generas plan, devuélvelo en JSON aparte.
  private systemPrompt = `
Eres una asistente de viajes amable y práctica.
- Habla SIEMPRE en lenguaje natural (nada de corchetes, JSON, ni tablas) cuando respondas al usuario.
- Cuando el usuario pida un itinerario, tu salida INTERNA debe contener dos partes:
  1) "reply": Un resumen conversacional y claro (texto humano).
  2) "plan": Un objeto JSON VÁLIDO y compacto con destino, días, presupuesto y lista de actividades por día.
  Formato INTERNO (para el backend, NO lo muestres tal cual al usuario):
  {"reply": "...", "plan": { ... }}
- Para preguntas de seguimiento, usa el CONTEXTO del chat.
- Si faltan datos (personas, días, presupuesto), PREGUNTA de forma natural.
`.trim();

  async chatWithContext(
    history: GroqMsg[],
    userMessage: string,
  ): Promise<{ reply: string; plan?: any }> {
    if (!this.apiKey) {
      return { reply: 'Falta configurar la clave de la IA (GROQ_API_KEY).' };
    }

    const messages: GroqMsg[] = [
      { role: 'system', content: this.systemPrompt },
      ...history,
      { role: 'user', content: userMessage },
    ];

    const res = await fetch(this.apiUrl, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${this.apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: this.model,
        temperature: this.temperature,
        messages,
      }),
    });

    if (!res.ok) {
      const errText = await res.text().catch(() => '');
      return {
        reply: `No pude responder en este momento (HTTP ${res.status}). ${errText || ''}`.trim(),
      };
    }

    const data = await res.json().catch(() => ({}));
    const content: string = data?.choices?.[0]?.message?.content ?? '';

    // Intentar extraer un bloque JSON { reply, plan } si el modelo lo mezcló con texto
    let parsed: any = null;
    try {
      const match = content.match(/\{[\s\S]*\}$/m);
      parsed = JSON.parse(match ? match[0] : content);
    } catch {
      // Si no hay JSON válido, devolvemos texto natural
      return { reply: (content || 'No pude generar una respuesta.').trim() };
    }

    const reply =
      typeof parsed?.reply === 'string'
        ? parsed.reply.trim()
        : (content || 'Listo.').trim();

    const plan = typeof parsed?.plan === 'object' ? parsed.plan : undefined;

    return { reply, plan };
  }
}
