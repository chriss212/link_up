import 'package:dio/dio.dart';
import '../services/api_service.dart';

class FinancesService {
  final Dio _dio = ApiService.dio;

  Future<List<dynamic>> getRequests() async {
    final response = await _dio.get('/finances/requests');

    final data = response.data;


    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return List<Map<String, dynamic>>.from(data['data']);
    }


    if (data is List) return data;
    return [];
  }


  Future<Map<String, dynamic>> addRequest(
      String title, String from, int amount) async {
    final response = await _dio.post(
      '/finances/requests',
      data: {
        'title': title,
        'from': from,
        'amount': amount,
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return Map<String, dynamic>.from(data['data']);
    }
    return data;
  }


  Future<Map<String, dynamic>> markAsPaid(int id) async {
    final response = await _dio.patch('/finances/requests/$id/pay');

    print('markAsPaid response: ${response.statusCode} - ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return Map<String, dynamic>.from(data['data']);
      }
      return {"success": true, "message": "Request marked as paid"};
    } else {
      throw Exception('Failed to mark as paid');
    }
  }


  Future<List<dynamic>> getAccounts() async {
    final response = await _dio.get('/finances/accounts');

    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return List<Map<String, dynamic>>.from(data['data']);
    }

    if (data is List) return data;
    return [];
  }


  Future<Map<String, dynamic>> addAccount(
      String name, int members, int expected, int contributed) async {
    final response = await _dio.post(
      '/finances/accounts',
      data: {
        'name': name,
        'members': members,
        'expected': expected,
        'contributed': contributed,
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return Map<String, dynamic>.from(data['data']);
    }
    return data;
  }


Future<void> addContribution(int id, int amount) async {
  try {
    final response = await _dio.patch(
      '/finances/accounts/$id/contribute',
      data: {'amount': amount},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Unexpected status code: ${response.statusCode}');
    }
  } catch (e, st) {
    print('addContribution error: $e');
    print(st);
    rethrow;
  }
}

}