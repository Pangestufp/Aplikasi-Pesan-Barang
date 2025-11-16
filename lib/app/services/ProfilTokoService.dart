import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasipemesananpulaubaru/app/services/ApiService.dart';
import 'package:aplikasipemesananpulaubaru/shared/endpoints/EndPoints.dart';

class ProfilTokoService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>?> getProfilToko() async {
    const endpoint = EndPoints.profilTokoGet;
    final prefs = await SharedPreferences.getInstance();
    bool hasConnection = await _apiService.checkServerConnection();

    if (hasConnection) {
      try {
        final response = await _apiService.getRequest(endpoint);
        if (response.isNotEmpty) {
          final data = response.first;

          await prefs.setString(endpoint, jsonEncode(data));

          return data;
        }
      } catch (e) {
        print("Error ambil data dari API ($endpoint): $e");
      }
    }

    final cachedData = prefs.getString(endpoint);
    if (cachedData != null) {
      print("Menggunakan data cache dari $endpoint");
      return jsonDecode(cachedData);
    }

    return null;
  }
}
