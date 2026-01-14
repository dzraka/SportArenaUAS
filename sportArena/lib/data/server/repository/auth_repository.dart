import 'package:final_project/data/server/usecase/request/login_request.dart';
import 'package:final_project/data/server/usecase/request/register_request.dart';
import 'package:final_project/data/server/usecase/response/login_response.dart';
import 'package:final_project/data/server/usecase/response/register_response.dart';
import 'package:final_project/data/service/http_service.dart';
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
      final responsData = RegisterResponse.fromJson(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responsData;
      } else {
        return responsData;
      }
    } catch (e) {
      throw Exception('Register Error: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
