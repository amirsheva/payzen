import 'package:dio/dio.dart';

class ApiService {
  // برای شبیه‌ساز iOS از localhost استفاده کنید.
  // برای شبیه‌ساز اندروید از 10.0.2.2 استفاده کنید.
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  /// متد برای ثبت‌نام کاربر جدید
  Future<bool> registerUser(String name, String email, String password) async {
    try {
      final response = await _dio.post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        print('SUCCESS: User created successfully: ${response.data}');
        return true;
      }
    } on DioException catch (e) {
      // مدیریت خطای ایمیل تکراری
      if (e.response?.statusCode == 409) {
        print('ERROR creating user: This email is already registered.');
      } else {
        print('ERROR creating user: ${e.response?.data}');
      }
    }
    return false;
  }

  /// متد برای ورود کاربر و دریافت توکن
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        // اگر موفق بود، توکن را برگردان
        final token = response.data['access_token'];
        print('Login successful, token received!');
        return token;
      }
    } on DioException catch (e) {
      // مدیریت خطای عدم مجوز (ایمیل یا پسورد اشتباه)
      if (e.response?.statusCode == 401) {
        print('Error logging in: Invalid credentials.');
      } else {
        print('Error logging in: ${e.response?.data}');
      }
    }
    // اگر ناموفق بود، null برگردان
    return null;
  }
}