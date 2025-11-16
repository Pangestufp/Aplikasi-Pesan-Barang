import 'dart:convert';
import 'dart:io';
import 'package:aplikasipemesananpulaubaru/app/services/AuthService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/TokenService.dart';
import 'package:aplikasipemesananpulaubaru/shared/endpoints/EndPoints.dart';
import 'package:aplikasipemesananpulaubaru/shared/routes/Routes.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiService {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();
  final AuthService _authService = AuthService();

  Future<List<Map<String, dynamic>>> getRequest(String endpoint) async {
    final token = await _tokenService.getToken();
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return _normalizeResponse(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final token = await _tokenService.getToken();
    try {
      final response = await _dio.post(
        endpoint,
        data: jsonEncode(body),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      return _normalizeResponse(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> patchRequest(
      String endpoint, Map<String, dynamic> body) async {
    final token = await _tokenService.getToken();
    try {
      final response = await _dio.patch(
        endpoint,
        data: jsonEncode(body),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      return _normalizeResponse(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }



  Future<List<Map<String, dynamic>>> postMultipartRequest(
      String endpoint, Map<String, dynamic> body,
      {File? file, String fileKey = "image"}) async {
    final token = await _tokenService.getToken();
    try {
      final formData = dio.FormData.fromMap({
        ...body,
        if (file != null)
          fileKey: await dio.MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
      });

      print('=== MULTIPART REQUEST DEBUG ===');
      print('Endpoint: $endpoint');
      print('Headers: Bearer $token');
      print('Body data: $body');
      print('File: ${file?.path}');

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      print('=== RESPONSE DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Raw Response: ${response.data}');
      print('Response Type: ${response.data.runtimeType}');

      return _normalizeResponse(response.data);
    } on DioException catch (e) {
      print('=== DIO ERROR ===');
      print('Error: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');
      return _handleError(e);
    }
  }

  /// PATCH request dengan file (Multipart)
  Future<List<Map<String, dynamic>>> patchMultipartRequest(
      String endpoint, Map<String, dynamic> body,
      {File? file, String fileKey = "image"}) async {
    final token = await _tokenService.getToken();
    try {
      final formData = dio.FormData.fromMap({
        ...body,
        if (file != null)
          fileKey: await dio.MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
      });

      final response = await _dio.patch(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      return _normalizeResponse(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  List<Map<String, dynamic>> _normalizeResponse(dynamic data) {
    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else if (data is Map) {
      return [Map<String, dynamic>.from(data)];
    } else {
      return [];
    }
  }

  List<Map<String, dynamic>> _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      _forceLogout();
    }
    return [];
  }

  Future<void> _forceLogout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.MENU_LOGIN);
  }

  Future<bool> checkServerConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final response = await _dio.get(
        "${EndPoints.imageUrl}Ping",
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

      if (response.statusCode == 200) {
        print("Server aktif: ${EndPoints.imageUrl}/Ping");
        return true;
      } else {
        print("Server merespons tapi bukan 200: ${response.statusCode}");
        return false;
      }
    } on DioException catch (e) {
      print("Gagal menjangkau server: ${e.message}");
      return false;
    } catch (e) {
      print("Error tak terduga: $e");
      return false;
    }
  }


}
