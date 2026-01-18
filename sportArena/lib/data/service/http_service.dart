import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpService {
  final String baseURL = 'http://192.168.1.8:8000/api/';

  String? _token;

  void setToken(String token) {
    _token = token;
    log('Token set: $token');
  }

  void clearToken() {
    _token = null;
    log('Token cleared');
  }

  Map<String, String> _getHeaders({
    bool isMultipart = false,
    Map<String, String>? extraHeaders,
  }) {
    final headers = {'Accept': 'application/json'};
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');
    final response = await http.get(
      url,
      headers: _getHeaders(extraHeaders: headers),
    );
    log(response.body);
    return response;
  }

  Future<http.Response> post(
    String endPoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseURL$endPoint');
    final response = await http.post(
      url,
      headers: _getHeaders(extraHeaders: headers),
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> postWithFile(
    String endPoint,
    Map<String, String> fields,
    File? file,
    String fileFieldName, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$baseURL$endPoint');
      final request = http.MultipartRequest('POST', url);

      request.headers.addAll(
        _getHeaders(isMultipart: true, extraHeaders: headers),
      );
      request.fields.addAll(fields);

      if (file != null) {
        final imageFile = await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
        );
        request.files.add(imageFile);
        log('File added: ${file.path}');
      }
      log('POST with File to: $url');
      log('Fields: ${request.fields}');
      log('Files: ${request.files.length}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      log('POST with File Response: ${response.statusCode}');
      return response;
    } catch (e) {
      log('Error in postWithFile: $e');
      rethrow;
    }
  }

  Future<http.Response> delete(
    String endPoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseURL$endPoint');
    final response = await http.delete(
      url,
      headers: _getHeaders(extraHeaders: headers),
    );
    return response;
  }
}
