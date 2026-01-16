import 'dart:convert';

import 'package:final_project/data/server/usecase/request/add_field_request.dart';
import 'package:final_project/data/server/usecase/response/get_all_field_response.dart';
import 'package:final_project/data/server/usecase/response/get_field_response.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FieldRepository {
  final HttpService httpService;

  FieldRepository(this.httpService);

  Future<GetAllFieldResponse> getAllFields() async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'fields',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GetAllFieldResponse.fromMap(responseBody);
      } else {
        throw Exception(
          responseBody['message'] ?? 'Failed to fetch field data',
        );
      }
    } catch (e) {
      throw Exception('Field Repository Error: $e');
    }
  }

  Future<GetFieldResponse> getFieldDetail(int id) async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'fields/$id',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseBody = jsonDecode(response.body);
      final responseData = GetFieldResponse.fromJson(responseBody);
      return responseData;
    } catch (e) {
      throw Exception('Error getting field detail $e');
    }
  }

  Future<GetAllFieldResponse> getFutsalFields() async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'fields/type/futsal',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseBody = jsonDecode(response.body);
      final responseData = GetAllFieldResponse.fromJson(responseBody);
      return responseData;
    } catch (e) {
      throw Exception('Error getting futsal fields');
    }
  }

  Future<GetAllFieldResponse> getBadmintonFields() async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'fields/type/badminton',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseBody = jsonDecode(response.body);
      final responseData = GetAllFieldResponse.fromJson(responseBody);
      return responseData;
    } catch (e) {
      throw Exception('Error getting badminton fields');
    }
  }

  Future<GetAllFieldResponse> getBasketFields() async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'fields/type/basket',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseBody = jsonDecode(response.body);
      final responseData = GetAllFieldResponse.fromJson(responseBody);
      return responseData;
    } catch (e) {
      throw Exception('Error getting basket fields');
    }
  }

  Future<bool> createField(AddFieldRequest request) async {
    final token = await _getToken();

    try {
      final response = await httpService.post(
        'admin/fields',
        request.toMap(),
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Create field failed: $e');
    }
  }

  Future<bool> updateField(AddFieldRequest request, int id) async {
    final token = await _getToken();

    try {
      final response = await httpService.post(
        'admin/fields/$id',
        request.toMap(),
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Update field failed: $e');
    }
  }

  Future<bool> deleteField(int id) async {
    final token = await _getToken();

    try {
      final response = await httpService.delete(
        'admin/fields/$id',
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Delete field failed: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
