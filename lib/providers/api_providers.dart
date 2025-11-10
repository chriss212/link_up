import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_providers.g.dart';

// 1. Lee la URL base de tu archivo .env
final String kBaseUrl =
    dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:3000/api';

// 2. Provider para el almacenamiento seguro
@riverpod
// Usa 'Ref' para evitar depender del código generado durante la compilación
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

// 3. Provider para Dio (reemplaza tu ApiService.dart)
@riverpod
Dio dio(Ref ref) {
  final options = BaseOptions(
    baseUrl: kBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  );

  final dio = Dio(options);

  // *** INTERCEPTOR AUTOMÁTICO DE TOKEN ***
  // Esto añade el token JWT a *todas* las peticiones
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      // Usa "Queued" para bloquear peticiones mientras se lee el token
      onRequest: (options, handler) async {
        // Lee el storage de forma segura
        final storage = const FlutterSecureStorage();
        final token = await storage.read(key: 'auth_token');

        if (token != null) {
          // Añade el header de autorización
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); // Continúa con la petición
      },
    ),
  );

  return dio;
}
