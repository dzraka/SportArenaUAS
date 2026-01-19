import 'dart:convert';
import 'dart:io';

import 'package:final_project/data/server/usecase/request/login_request.dart';
import 'package:final_project/data/server/usecase/request/register_request.dart';
import 'package:final_project/data/server/usecase/response/get_all_user_response.dart';
import 'package:final_project/data/server/usecase/response/get_user_response.dart';
import 'package:final_project/data/server/usecase/response/login_response.dart';
import 'package:final_project/data/server/usecase/response/register_response.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final HttpService httpService;

  AuthRepository(this.httpService);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await httpService.post('login', request.toMap());
      final responseData = LoginResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        if (responseData.data != null) {
          await _saveToken(responseData.data!.token);
        }
        return responseData;
      } else {
        return responseData;
      }
    } catch (e) {
      throw Exception('Login Error: $e');
    }
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await httpService.post('register', request.toMap());

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromMap(responseBody);
      } else {
        return RegisterResponse(
          status: 'error',
          message: responseBody['message'] ?? 'Terjadi kesalahan',
          data: null,
        );
      }
    } catch (e) {
      throw Exception('Register Error: $e');
    }
  }

  Future<bool> logout() async {
    final token = await _getToken();

    try {
      await httpService.post(
        'logout',
        {},
        headers: {'Authorization': 'Bearer $token'},
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      return true;
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      return false;
    }
  }

  Future<GetAllUserResponse> getAllUser() async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'admin/users',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GetAllUserResponse.fromMap(responseBody);
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('User Repository Error: $e');
    }
  }

  Future<GetUserResponse> getUserProfile() async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'me',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseData = GetUserResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        return responseData;
      }
    } catch (e) {
      throw Exception('Get Profle Error: $e');
    }
  }

  Future<bool> updateProfile(Map<String, String> data, File? imageFile) async {
    final token = await _getToken();

    try {
      http.Response response;
      if (imageFile != null) {
        response = await httpService.postWithFile(
          'profile',
          data,
          imageFile,
          'image',
          headers: {'Authorization': 'Bearer $token'},
        );
      } else {
        response = await httpService.post(
          'profile',
          data,
          headers: {'Authorization': 'Bearer $token'},
        );
      }

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Update Profle Error: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
