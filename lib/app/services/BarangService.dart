import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasipemesananpulaubaru/app/services/ApiService.dart';
import 'package:aplikasipemesananpulaubaru/shared/endpoints/EndPoints.dart';

class BarangService {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getAllBarang() async {
    const endpoint = EndPoints.barangReadAllWithPartPrice;
    final prefs = await SharedPreferences.getInstance();
    bool hasConnection = await _apiService.checkServerConnection();

    if (hasConnection) {
      try {
        final response = await _apiService.getRequest(endpoint);
        if (response.isNotEmpty) {
          await prefs.setString(endpoint, jsonEncode(response));
          print("Data barang berhasil diambil dari API dan disimpan ke cache.");
          return response;
        }
      } catch (e) {
        print("Error ambil data barang dari API ($endpoint): $e");
      }
    }

    final cachedData = prefs.getString(endpoint);
    if (cachedData != null) {
      print("Menggunakan data cache dari $endpoint");
      return jsonDecode(cachedData);
    }

    print("Tidak ada koneksi dan cache belum tersedia untuk $endpoint");
    return [];
  }
}
