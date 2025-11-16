import 'dart:convert';
import 'package:aplikasipemesananpulaubaru/app/services/TokenService.dart';
import 'package:aplikasipemesananpulaubaru/shared/endpoints/EndPoints.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        EndPoints.login,
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      final data = response.data;

      if (data is String) {
        await _tokenService.saveToken(data);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final token = await _tokenService.getToken();
      await _tokenService.deleteToken();

      final response = await _dio.post(
        EndPoints.logout,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}