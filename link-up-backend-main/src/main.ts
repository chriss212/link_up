import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as dotenv from 'dotenv';

async function bootstrap() {
  // Cargar variables .env
  dotenv.config();

  const app = await NestFactory.create(AppModule);

  // Prefijo global para todos los endpoints REST
  app.setGlobalPrefix('api');

  // CORS para front local (ajusta si usas otros orígenes)
  app.enableCors({
    origin: ['http://localhost:5173', 'http://localhost:3000'],
    credentials: true,
    methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  });

  // Validación global
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true, // transforma payloads a los DTOs
      forbidNonWhitelisted: false,
    }),
  );

  // Swagger (UI en /docs) con server base /api para que "Try it out" ya incluya el prefijo
  const swaggerConfig = new DocumentBuilder()
    .setTitle('LinkUp API')
    .setDescription('Backend de LinkUp con NestJS y PostgreSQL')
    .setVersion('1.0')
    .addBearerAuth()
    .addServer('/api') // <- importante por el prefijo global
    .build();

  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('docs', app, document);

  const port = Number(process.env.PORT) || 3000;
  await app.listen(port);

  const base = `http://localhost:${port}`;
  console.log(`🚀 Servidor corriendo en ${base}`);
  console.log(`📘 Swagger: ${base}/docs`);
  console.log(`🔗 Base API: ${base}/api`);
}
bootstrap();
