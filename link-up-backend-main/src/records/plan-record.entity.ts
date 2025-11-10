import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('plan_record')
export class PlanRecord {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  sessionId: string;

  @Column('text')
  userMessage: string;

  @Column('text', { nullable: true })
  aiReply: string | null;

  @Column('jsonb', { nullable: true })
  plan: Record<string, any> | null;

  @CreateDateColumn()
  createdAt: Date;
}
