import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
  final _storage = const FlutterSecureStorage();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<bool> registerUser(String name, String email, String password) async {
    try {
      final response = await _dio.post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return response.statusCode == 201;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 201 && response.data['access_token'] != null) {
        final token = response.data['access_token'];
        await _storage.write(key: 'jwt_token', value: token);
        return token;
      }
    } catch (e) {
      print('Error logging in: $e');
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<List<dynamic>> getDebts() async {
    try {
      final response = await _dio.get('/debts');
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching debts: $e');
    }
    return [];
  }

  Future<bool> createDebt({
    required String debtName,
    required double totalAmount,
    required int numberOfInstallments,
  }) async {
    try {
      final response = await _dio.post('/debts', data: {
        'debt_name': debtName,
        'total_amount': totalAmount,
        'number_of_installments': numberOfInstallments,
        'interest_rate': 0,
        'start_date': DateTime.now().toIso8601String(),
      });
      return response.statusCode == 201;
    } catch (e) {
      print('Error creating debt: $e');
      return false;
    }
  }

  Future<bool> deleteDebt(int id) async {
    try {
      final response = await _dio.delete('/debts/$id');
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting debt: $e');
      return false;
    }
  }

  // --- متد جدید برای گرفتن جزئیات یک بدهی ---
  Future<Map<String, dynamic>?> getDebtDetails(int id) async {
    try {
      final response = await _dio.get('/debts/$id');
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching debt details: $e');
    }
    return null; // در صورت خطا، null برگردان
  }
}
