import 'dart:convert';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>?> init() async {
    await ApiService.loadToken();
    if (ApiService.token != null) {
      // Validate token by fetching profile
      final response = await ApiService.get('/profile');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Returns the user object
      } else {
        await ApiService.clearToken();
        return null;
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await ApiService.saveToken(data['token']);
        return {'success': true, 'user': data['user']};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['error'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan'};
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await ApiService.post('/auth/register', userData);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // By-passing OTP logic: save token directly to login automatically
        await ApiService.saveToken(data['token']);
        return {'success': true, 'user': data['user']};
      } else {
        final error = jsonDecode(response.body);
        String message = 'Registrasi gagal';
        if (error['error'] is String) {
          message = error['error'];
        } else if (error['error'] is Map) {
          // Flatten zod errors
          message = 'Pastikan data valid';
        }
        return {'success': false, 'message': message};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan'};
    }
  }

  static Future<void> logout() async {
    await ApiService.post('/auth/logout', {});
    await ApiService.clearToken();
  }
}
