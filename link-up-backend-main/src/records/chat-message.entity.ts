import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

export type ChatRole = 'user' | 'assistant' | 'system';

@Entity('chat_message')
export class ChatMessage {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Index()
  @Column()
  sessionId!: string;

  @Column({ type: 'varchar', length: 16 })
  role!: ChatRole; // 'user' | 'assistant' | 'system'

  @Column('text')
  content!: string;

  @CreateDateColumn()
  createdAt!: Date;
}
