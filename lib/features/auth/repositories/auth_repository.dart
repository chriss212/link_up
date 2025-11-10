import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:link_up/providers/api_providers.dart'; // Asegúrate que la ruta sea correcta

part 'auth_repository.g.dart';

// --- Clases de Modelo (puedes moverlas a sus propios archivos) ---
class User {
  final String id;
  final String email;
  final String fullName;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
    );
  }
}

class AuthResponse {
  final String token;
  final User user;
  AuthResponse({required this.token, required this.user});
}
// --- Fin de Clases de Modelo ---

@riverpod
AuthRepository authRepository(Ref ref) {
  // ✅ Esto ahora funciona gracias al import
  return AuthRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(secureStorageProvider),
  );
}

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token'; // Clave para guardar el token

  AuthRepository({required Dio dio, required FlutterSecureStorage storage})
    : _dio = dio,
      _storage = storage;

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // --- LLAMADAS A LA API DE NESTJS ---

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login', // Endpoint de NestJS
        data: {'email': email, 'password': password},
      );

      final token = response.data['access_token'] as String;
      final user = User.fromJson(response.data['user']);

      await saveToken(token);

      return AuthResponse(token: token, user: user);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg =
            e.response?.data['message']?.toString() ?? 'Error de login';
        throw Exception(errorMsg);
      }
      throw Exception('Error de red. Intenta de nuevo.');
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post(
        '/auth/register', // Endpoint de NestJS
        data: {'fullName': fullName, 'email': email, 'password': password},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 409) {
          throw Exception('El correo ya está registrado');
        }
        final errorMsg =
            e.response?.data['message']?.toString() ?? 'Error de registro';
        throw Exception(errorMsg);
      }
      throw Exception('Error de red. Intenta de nuevo.');
    }
  }
}
