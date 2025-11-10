import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SmartPlannerController } from './smart-planner.controller';
import { SmartPlannerService } from './smart-planner.service';
import { AiService } from '../ai/ai.service';
import { PlanRecord } from '../records/plan-record.entity';
import { ChatMessage } from '../records/chat-message.entity';

@Module({
  imports: [TypeOrmModule.forFeature([PlanRecord, ChatMessage])],
  controllers: [SmartPlannerController],
  providers: [SmartPlannerService, AiService],
})
export class SmartPlannerModule {}
