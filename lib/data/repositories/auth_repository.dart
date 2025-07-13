import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  final String baseUrl = 'https://jewelrystore-production-ec35.up.railway.app/api';

  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        json['data'] != null &&
        json['data']['token'] != null &&
        json['data']['user'] != null) {
      return UserModel.fromLoginJson(json['data']);
    } else {
      final errorMessage = json['message'] ?? json['msg'] ?? 'Login failed';
      throw Exception(errorMessage);
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'phone': phone,
      },
    );

    final json = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        json['data'] != null &&
        json['data']['token'] != null) {
      return UserModel.fromRegisterJson(json['data']);
    } else {
      final errorMessage = json['message'] ?? json['msg'] ?? 'Registration failed';
      throw Exception(errorMessage);
    }
  }

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final json = jsonDecode(response.body);
      final errorMessage = json['message'] ?? 'Logout failed';
      throw Exception(errorMessage);
    }
  }
}
