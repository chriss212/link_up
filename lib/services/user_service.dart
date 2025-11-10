import 'package:dio/dio.dart';
import 'dio_client.dart';

class UserService {
  final DioClient _dioClient = DioClient();

  Future<Response> getUser(String id) async {
    try {
      final response = await _dioClient.dio.get('/users/$id');
      return response;
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  Future<Response> updateUser(String id, String newName) async {
    try {
      final response = await _dioClient.dio.put(
        '/users/$id',
        data: {'username': newName},
      );
      return response;
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }
}
