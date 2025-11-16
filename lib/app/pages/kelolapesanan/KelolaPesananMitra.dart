import 'package:aplikasipemesananpulaubaru/app/controllers/PesananController.dart';
import 'package:aplikasipemesananpulaubaru/shared/routes/Routes.dart';
import 'package:aplikasipemesananpulaubaru/shared/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KelolaPesananMitra extends GetView<PesananController> {
  const KelolaPesananMitra({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.secondaryColor,
      appBar: AppBar(
        title: const Text(
          'Kelola Pesanan Partner',
          style: TextStyle(color: Styles.primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Styles.tertiaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Styles.primaryColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Styles.primaryColor),
                  ),
                );
              }

              if (controller.pesananList.isEmpty && controller.pesananTertundaList.isEmpty) {
                return const Center(child: Text("Tidak ada data Pembelian"));
              }

              return ListView(
                children: [
                  if (controller.pesananTertundaList.isNotEmpty) ...[
                    ...controller.pesananTertundaList
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key; // 0,1,2,...
                      final pesanan = entry.value;

                      // Ambil list detail dari pesanan
                      final List<dynamic> detailList = pesanan['detail'] ?? [];

                      // Helper: convert dynamic ke int
                      int parseInt(dynamic value) {
                        if (value is int) return value;
                        if (value is String) return int.tryParse(value) ?? 0;
                        return 0;
                      }

                      // Helper: convert dynamic ke double
                      double parseDouble(dynamic value) {
                        if (value is double) return value;
                        if (value is int) return value.toDouble();
                        if (value is String) return double.tryParse(value) ?? 0;
                        return 0;
                      }

                      // Hitung total jumlah
                      final totalJumlah = detailList.fold<int>(
                        0,
                            (sum, item) => sum + parseInt(item['jumlah']),
                      );

                      // Hitung total harga
                      final totalHarga = detailList.fold<double>(
                        0,
                            (sum, item) => sum + (parseInt(item['jumlah']) * parseDouble(item['hargajual'])),
                      );

                      // Nama pesanan jadi Draft-1, Draft-2, ...
                      final namaPesanan = 'Draft-${index + 1}';

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Styles.primaryColor.withOpacity(0.1),
                            child: const Icon(Icons.cloud_off, color: Styles.primaryColor),
                          ),
                          title: Text(
                            namaPesanan,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status: draft",
                                style: TextStyle(
                                  color: Styles.getStatusColor("draft"),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Total Qty: $totalJumlah  |  Total Harga: ${Styles.formatMoneyRp(totalHarga.toString())}",
                              ),
                            ],
                          ),
                          onTap: () {
                            _showPesananTertundaDetail(context, detailList);
                          },
                        ),
                      );
                    }).toList(),
                  ]
                  else ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Tidak ada pesanan tertunda",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],

                  ...controller.pesananList.map((pesanan) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Styles.primaryColor.withOpacity(0.1),
                        child: const Icon(Icons.receipt_long, color: Styles.primaryColor),
                      ),
                      title: Text(
                        pesanan['id_transaksi'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nama: ${pesanan['name'] ?? '-'}"),
                          Text(
                            "Status: ${pesanan['statuspesanan'] ?? '-'}",
                            style: TextStyle(
                              color: Styles.getStatusColor(pesanan['statuspesanan']),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text("Tanggal: ${Styles.formatDate(pesanan['createat']) ?? ''}"),
                        ],
                      ),
                      onTap: () {
                        controller.selectedid_transaksi.value = pesanan['id_transaksi'];
                        final transaksi = pesanan;

                        final header = {
                          "id_transaksi": transaksi["id_transaksi"],
                          "statuspesanan": transaksi["statuspesanan"],
                          "createat": transaksi["createat"],
                          "updateat": transaksi["updateat"],
                          "id_user": transaksi["id_user"],
                          "name": transaksi["name"],
                          "total": transaksi["total"],
                        };

                        final detailList = transaksi["detail"];

                        Get.toNamed(
                          Routes.KELOLA_PESANAN_MITRA_ACTION,
                          arguments: {
                            "header": header,
                            "detailList": detailList,
                          },
                        );
                      },
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            Styles.formatMoneyRp(pesanan['total']),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showPesananTertundaDetail(BuildContext context, List<dynamic> detailList) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Detail Pesanan Tertunda"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: detailList.length,
            itemBuilder: (context, index) {
              final item = detailList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama Barang: ${item['namatext']}"),
                    Text("ID Barang: ${item['id_barang']}"),
                    Text("Jumlah: ${item['jumlah']}"),
                    Text("Harga: ${Styles.formatMoneyRp(item['hargajual'])}"),
                    const Divider(),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

}
