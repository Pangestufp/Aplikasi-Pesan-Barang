import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasipemesananpulaubaru/app/services/ApiService.dart';
import 'package:aplikasipemesananpulaubaru/shared/endpoints/EndPoints.dart';
import 'package:get/get.dart';

class PesananService {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getAllPesanan() async {
    const endpoint = EndPoints.pesananGetByUser;
    final prefs = await SharedPreferences.getInstance();
    bool hasConnection = await _apiService.checkServerConnection();

    if (hasConnection) {
      try {
        final response = await _apiService.getRequest(endpoint);
        if (response.isNotEmpty) {
          await prefs.setString(endpoint, jsonEncode(response));
          print("Data pesanan berhasil diambil dari API dan disimpan ke cache.");
          return response;
        }
      } catch (e) {
        print("Error ambil data pesanan dari API ($endpoint): $e");
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



Future<Map<String, dynamic>?> Setuju(String id) async {
    final response = await _apiService.postRequest(EndPoints.pesananSetuju+"/"+id, {});
    if (response.isNotEmpty) {
      return response.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> Tolak(String id) async {
    final response = await _apiService.postRequest(EndPoints.pesananTolak+"/"+id, {});
    if (response.isNotEmpty) {
      return response.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> tambahPesanan(Map<String, dynamic> body) async {
    bool hasConnection = await _apiService.checkServerConnection();

    print(hasConnection);
    List<Map<String, dynamic>> response;
    if (hasConnection) {
      response = await _apiService.postRequest(EndPoints.pesananCreate, body);
    }else{
      await _simpanPesananOffline(body);
      return {"message":"Offline"};
    }

    if (response.isNotEmpty) {
      return response.first;
    } else {
      Get.snackbar("Gagal", "Gagal mengirim pesanan ke server", snackPosition: SnackPosition.BOTTOM,);
      return null;
    }
  }


  Future<void> _simpanPesananOffline(Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getStringList('offline_orders') ?? [];
    existing.add(jsonEncode(body));

    await prefs.setStringList('offline_orders', existing);
  }

  Future<void> kirimPesananOffline() async {
    final prefs = await SharedPreferences.getInstance();
    final storedOrders = prefs.getStringList('offline_orders') ?? [];

    bool hasConnection = await _apiService.checkServerConnection();

    if (!hasConnection) {
      return;
    }

    if (storedOrders.isEmpty) {
      print("Tidak ada pesanan offline untuk dikirim.");
      return;
    }

    int totalOrders = storedOrders.length;
    int successCount = 0;
    int failCount = 0;

    final List<String> failedOrders = [];


    for (var orderJson in storedOrders) {
      final Map<String, dynamic> order = jsonDecode(orderJson);
      try {
        final response = await _apiService.postRequest(EndPoints.pesananCreate, order);

        if (response.isNotEmpty) {
          successCount++;
        } else {
          failCount++;
          failedOrders.add(orderJson);
        }
      } catch (e) {
        failCount++;
        failedOrders.add(orderJson);
      }
    }

    await prefs.remove('offline_orders');

    if (failCount == 0) {
      Get.snackbar("Berhasil", "Semua $successCount pesanan berhasil dikirim!", snackPosition: SnackPosition.BOTTOM,);
    } else if (successCount > 0 && failCount > 0) {
      Get.snackbar(
        "Sebagian Terkirim",
        "$successCount dari $totalOrders pesanan berhasil dikirim, "
            "$failCount gagal. Draft sudah dibersihkan.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar("Gagal", "Semua $failCount pesanan gagal dikirim. Draft sudah dibersihkan.", snackPosition: SnackPosition.BOTTOM,);
    }

  }


  Future<List<dynamic>> getPesananTertunda() async {
    final prefs = await SharedPreferences.getInstance();

    final storedOrders = prefs.getStringList('offline_orders') ?? [];

    final List<dynamic> decodedOrders = storedOrders.map((e) {
      return jsonDecode(e);
    }).toList();
    print(decodedOrders);
    return decodedOrders;
  }


}
