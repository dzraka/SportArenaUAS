import 'dart:convert';

import 'package:final_project/data/server/usecase/request/add_booking_request.dart';
import 'package:final_project/data/server/usecase/response/get_all_booking_response.dart';
import 'package:final_project/data/server/usecase/response/get_booking_response.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingRepository {
  final HttpService httpService;

  BookingRepository(this.httpService);

  Future<GetAllBookingResponse> getAllBookings() async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'admin/bookings',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseData = GetAllBookingResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        return responseData;
      }
    } catch (e) {
      throw Exception('Error parsing bookings: $e');
    }
  }

  Future<GetBookingResponse> createBooking(AddBookingRequest request) async {
    final token = await _getToken();

    try {
      final response = await httpService.post(
        'bookings',
        request.toMap(),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = GetBookingResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorBody = jsonDecode(response.body);
        String errorMessage =
            errorBody['message'] ?? 'Terjadi kesalahan pada server';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<GetAllBookingResponse> getUserBookings() async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'user-bookings',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseData = GetAllBookingResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        return responseData;
      }
    } catch (e) {
      throw Exception('Error fetching user bookings: $e');
    }
  }

  Future<bool> cancelBooking(int bookingId) async {
    final token = await _getToken();

    try {
      final response = await httpService.post(
        'bookings/$bookingId/cancel',
        {},
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Cancel booking failed: $e');
    }
  }

  Future<GetBookingResponse> getBookingDetails(int bookingId) async {
    final token = await _getToken();

    try {
      final response = await httpService.get(
        'bookings/$bookingId',
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseData = GetBookingResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        return responseData;
      }
    } catch (e) {
      throw Exception('Error fetching details: $e');
    }
  }

  Future<bool> updateBookingStatus(int bookingId, String status) async {
    final token = await _getToken();

    try {
      final response = await httpService.post(
        'admin/bookings/$bookingId/status',
        {'status': status},
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Upadate status failed: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<GetAllBookingResponse> getBookingsByDate(
    int fieldId,
    String date,
  ) async {
    final token = await _getToken();

    try {
      final String url = 'bookings?field_id=$fieldId&booking_date=$date';

      final response = await httpService.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseData = GetAllBookingResponse.fromJson(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        return responseData;
      }
    } catch (e) {
      throw Exception('Error fetching booked slots: $e');
    }
  }
}
