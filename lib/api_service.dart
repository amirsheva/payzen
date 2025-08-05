import 'package:dio/dio.dart';

class ApiService {
  // برای شبیه‌ساز iOS از localhost استفاده می‌کنیم
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<void> registerUser(String name, String email, String password) async {
    try {
      final response = await _dio.post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        print('SUCCESS: User created successfully on macOS: ${response.data}');
      }
    } on DioException catch (e) {
      print('ERROR creating user: ${e.response?.data}');
    }
  }
}