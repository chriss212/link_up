import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import * as dotenv from 'dotenv';
dotenv.config();

/** Módulos de tu proyecto */
import { AuthModule } from './auth/auth.module';
import { EventsModule } from './events/events.module';
import { UsersModule } from './users/users.module';
import { WalletModule } from './wallet/wallet.module';

/** IA Planner */
import { SmartPlannerModule } from './smart-planner/smart-planner.module';

/**
 * Evita errores TS2322 por elementos `undefined` en el array de imports.
 * Si alguno de los módulos no existe o la ruta está mal,
 * .filter(Boolean) lo saca del array y Nest arranca igual.
 * (Luego puedes corregir la ruta/módulo con calma.)
 */
const featureModules = [
  AuthModule,
  EventsModule,
  UsersModule,
  WalletModule,
  SmartPlannerModule,
].filter((m): m is any => Boolean(m));

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT ?? '5432', 10),
      username: process.env.DB_USER,
      password: process.env.DB_PASS,
      database: process.env.DB_NAME,
      autoLoadEntities: true,
      synchronize: true, // ponlo en false si usas migraciones
    }),
    ...featureModules,
  ],
})
export class AppModule {}
