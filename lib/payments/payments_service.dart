import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentsService {
  final Dio _dio = Dio();

  PaymentsService() {
    final baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000/api';
    _dio.options.baseUrl = baseUrl;
  }

  Future<bool> makePayment({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String cardNumber,
    required int amount,
  }) async {
    try {
      final response = await _dio.post(
        '/payments',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
          'cardNumber': cardNumber,
          'amount': amount,
        },
      );

      print('🔹 Payment response: ${response.data}');
      print('🔹 Status code: ${response.statusCode}');


      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        final data = response.data;
        return data is Map<String, dynamic>
            ? (data['success'] == true ||
                data['status'] == 'success' ||
                data['status'] == 'Success' ||
                data['message']?.toString().toLowerCase().contains('success') ==
                    true)
            : true;
      }

      return false;
    } catch (e) {
      print('❌ Payment error: $e');
      return false;
    }
  }
}
