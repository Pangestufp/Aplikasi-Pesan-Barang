import 'package:aplikasipemesananpulaubaru/app/services/BarangService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/PesananService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PesananController extends GetxController {

  final PesananService _pesananService = PesananService();
  final BarangService _barangService = BarangService();
  var barangList = <dynamic>[].obs;
  var pesananList = <dynamic>[].obs;
  var pesananTertundaList = <dynamic>[].obs;
  var cartList = <dynamic>[].obs;
  var cartIds = <int>{}.obs;
  var isLoading = false.obs;
  var filteredList = <dynamic>[].obs;

  var selectedid_transaksi = Rxn<String>();

  var pesananDetail = Rxn<Map<String, dynamic>>();


  @override
  void onInit() {
    super.onInit();
    fetchbarang();
  }


  Future<void> fetchbarang() async {
    try {
      isLoading.value = true;

      final pesanans = await _pesananService.getAllPesanan();
      pesananList.assignAll(pesanans);

      final barangs = await _barangService.getAllBarang();
      barangList.assignAll(barangs);
      filteredList.assignAll(barangs);

      final pesanantertunda = await _pesananService.getPesananTertunda();
      pesananTertundaList.assignAll(pesanantertunda);

    } finally {
      isLoading.value = false;
    }
  }


  var detailBarangKeluarList = <dynamic>[].obs;


  void searchBarang(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(barangList);
    } else {
      filteredList.assignAll(
        barangList.where((u) {
          final data = "${u['namatext']}${u['namakategori']}${u['deskripsi']}".toLowerCase();
          return data.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }



  void addToCart(Map<String, dynamic> barang) {
    final id = barang['id_barang'];
    if (!cartIds.contains(id)) {
      cartList.add(barang);
      cartIds.add(id);
    }
  }

  void removeFromCart(int idBarang) {
    cartList.removeWhere((item) => item['id_barang'] == idBarang);
    cartIds.remove(idBarang);
  }

  void clearCart() {
    cartList.clear();
    cartIds.clear();
  }


  Future<void> Setuju() async {
    isLoading.value = true;

    String? id = selectedid_transaksi.value;
    if(id != null) {
      try {
        final result = await _pesananService.Setuju(id);

        if (result != null && result is Map<String, dynamic>) {
          final message = result['message'] ?? "Pesanan berhasil disetujui";
          await fetchbarang();
          Get.back();
          Get.snackbar(
            "Notifikasi",
            message,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            "Error",
            "Gagal menyetujui",
            snackPosition: SnackPosition.BOTTOM,
          );
        }

      } finally {
        isLoading.value = false;
      }
    }
  }


  Future<void> Tolak() async {
    isLoading.value = true;

    String? id = selectedid_transaksi.value;
    if(id != null) {
      try {
        final result = await _pesananService.Tolak(id);

        if (result != null && result is Map<String, dynamic>) {
          final message = result['message'] ?? "Pesanan berhasil ditolak";
          await fetchbarang();
          Get.back();
          Get.snackbar(
            "Notifikasi",
            message,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            "Error",
            "Gagal menolak",
            snackPosition: SnackPosition.BOTTOM,
          );
        }

      } finally {
        isLoading.value = false;
      }
    }
  }



  Future<void> tambahBarangKeluar() async {
    isLoading.value = true;

    if(cartList.isEmpty){
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Cart Masih Kosong",
        snackPosition: SnackPosition.BOTTOM,
      );
    }else {
      final List<Map<String, dynamic>> detail = cartList.map((item) {
        return {
          "id_barang": item['id_barang'],
          "namatext": item['namatext'],
          "hargajual": item['hargajual'],
          "jumlah": item['jumlah'],
        };
      }).toList();

      final body = {
        "detail": detail,
      };

      try {
        final result = await _pesananService.tambahPesanan(body);

        if (result != null && result is Map<String, dynamic>) {
          final message = result['message'] ??
              "Barang keluar berhasil ditambahkan";
          String pesan = message;

          if(message=="Sukses"){
            pesan="Pesanan berhasil dibuat.";
          }

          if(message=="Offline"){
            pesan="Pesanan berhasil disimpan Offline.";
          }
          await fetchbarang();
          clearCart();
          Get.back();


          Get.snackbar(
            "Notifikasi",
            pesan,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          String message = "Gagal menambahkan Pesanan";

          if(result!=null) {
            message=result['message'] ?? "Gagal menambahkan Pesanan";
          }

            Get.snackbar(
              "Error",
              message,
              snackPosition: SnackPosition.BOTTOM,
            );

        }
      } finally {
        isLoading.value = false;
      }
    }
  }

}