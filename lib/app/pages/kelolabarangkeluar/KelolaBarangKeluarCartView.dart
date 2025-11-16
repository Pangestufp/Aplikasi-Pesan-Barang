import 'package:aplikasipemesananpulaubaru/app/controllers/PesananController.dart';
import 'package:aplikasipemesananpulaubaru/shared/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class KelolaBarangKeluarCartView extends GetView<PesananController> {
  const KelolaBarangKeluarCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.bar("Keranjang Barang"),
      body: Obx(() {
        if (controller.cartList.isEmpty) {
          return const Center(child: Text("Keranjang masih kosong"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.cartList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final barang = controller.cartList[index];
            final hargaJual =Styles.formatMoneyRp(barang['hargajual']);
            final jumlah = barang['jumlah'] ?? 0;
            final hargajualtes = double.tryParse(barang['hargajual'])??0;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Styles.primaryColor.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  )
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          barang['namatext'] ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          controller.removeFromCart(barang['id_barang']);
                          Get.snackbar(
                              "Dihapus",
                              "${barang['namatext']} telah dihapus dari keranjang",
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Sisa : ${barang['stok'] ?? '-'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: hargaJual),
                    decoration: null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Jumlah : ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text(Styles.formatMoneyRp("${hargajualtes*jumlah}")),                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,color: Styles.primaryColor,),
                            onPressed: () {
                              final currentJumlah = controller.cartList[index]['jumlah'] ?? 0;
                              if (currentJumlah > 1) {
                                controller.cartList[index]['jumlah'] = currentJumlah - 1;
                                controller.cartList.refresh();
                              }
                            },
                          ),
                          Text(
                            jumlah.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Styles.primaryColor,),
                            onPressed: () {
                              final currentJumlah = controller.cartList[index]['jumlah'] ?? 0;
                              final stok = int.tryParse(controller.cartList[index]['stok'].toString()) ?? 0;

                              if (currentJumlah < stok) {
                                controller.cartList[index]['jumlah'] = currentJumlah + 1;
                                controller.cartList.refresh();
                              } else {
                                Get.snackbar(
                                  "Stok Habis",
                                  "Jumlah tidak boleh melebihi stok (${stok.toString()})",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  colorText: Colors.white,
                                );
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(
              () => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: controller.isLoading.value
                ? null
                : () {
              final invalidItem = controller.cartList.any((item) {
                final hargaJual = item['hargajual'];
                final jumlah = item['jumlah'];

                final hargaValid = hargaJual != null &&
                    (hargaJual is num ? hargaJual > 0 :
                    (double.tryParse(hargaJual.toString()) ?? 0) > 0);

                final jumlahValid = jumlah != null && jumlah > 0;

                return !hargaValid || !jumlahValid;
              });

              if (invalidItem) {
                Get.snackbar(
                  "Error",
                  "Pastikan semua barang punya Jumlah yang valid",
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi"),
                    content:
                    const Text("Apakah Anda yakin ingin menyimpan?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          controller.tambahBarangKeluar();
                        },
                        child: const Text("Simpan"),
                      ),
                    ],
                  );
                },
              );
            },
            child: controller.isLoading.value
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 8),
                Text("Menyimpan..."),
              ],
            )
                : const Text("Buat"),
          ),
        ),
      ),
    );
  }
}

