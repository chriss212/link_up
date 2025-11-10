import 'package:dio/dio.dart';
import 'dio_client.dart';

class AuthService {
  final DioClient _dioClient = DioClient();

  Future<Response> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/register',
        data: {'email': email, 'password': password, 'username': username},
      );
      return response;
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  Future<Response> getMe() async {
    try {
      final response = await _dioClient.dio.get('/auth/me');
      return response;
    } catch (e) {
      throw Exception('Error al obtener usuario autenticado: $e');
    }
  }
}
