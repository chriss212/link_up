import { Controller, Post, Body } from '@nestjs/common';
import { SmartPlannerService } from './smart-planner.service';

@Controller('planner')  // <--- SIN 'api/' porque ya hay prefix global
export class SmartPlannerController {
  constructor(private readonly service: SmartPlannerService) {}

  @Post('chat')
  async chat(@Body() body: { sessionId: string; message: string }) {
    return this.service.handleChat(body.sessionId, body.message);
  }
}
