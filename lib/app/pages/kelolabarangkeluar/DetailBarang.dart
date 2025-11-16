import 'package:aplikasipemesananpulaubaru/app/controllers/PesananController.dart';
import 'package:aplikasipemesananpulaubaru/shared/endpoints/EndPoints.dart';
import 'package:aplikasipemesananpulaubaru/shared/routes/Routes.dart';
import 'package:aplikasipemesananpulaubaru/shared/styles/Styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailBarang extends GetView<PesananController> {
  const DetailBarang({super.key});

  @override
  Widget build(BuildContext context) {
    final barang = Get.arguments; // ambil data barang dari halaman sebelumnya

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Styles.bar(barang['namatext']),
      body: Stack(
        children: [
          // Bagian scrollable isi detail
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Gambar produk setengah layar
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: "${EndPoints.imageUrl}${barang['imagepath']}",
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Barang
                      Text(
                        barang['namatext'] ?? '-',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Info produk
                      buildDetailTable(barang),
                      const SizedBox(height: 20),

                      // Deskripsi
                      const Text(
                        "Deskripsi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        barang['deskripsi'] ?? '-',
                        style: const TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 120), // jarak agar tidak ketutup tombol bawah
                    ],
                  ),
                )
              ],
            ),
          ),

          // ✅ Tombol + dan - yang ngambang di bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Obx(() {
                final cartItem = controller.cartList.firstWhereOrNull(
                      (e) => e['id_barang'] == barang['id_barang'],
                );
                final isInCart = controller.cartIds.contains(barang['id_barang']);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🔹 Tombol ke Halaman Keranjang
                    IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.KELOLA_BARANGKELUAR_CART);
                      },
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    ),

                    // 🔹 Tombol Tambah / Hapus dari Keranjang
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isInCart ? Colors.redAccent : Styles.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                          ),
                          onPressed: () {
                            if (isInCart) {
                              controller.removeFromCart(barang['id_barang']);
                            /*  Get.snackbar(
                                "Dihapus",
                                "${barang['namatext']} telah dihapus dari keranjang",
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );*/
                            } else {
                              controller.addToCart(barang);
/*                              Get.snackbar(
                                "Ditambahkan",
                                "${barang['namatext']} telah ditambahkan ke keranjang",
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );*/
                            }
                          },
                          icon: Icon(
                            isInCart ? Icons.delete_forever : Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                          label: Text(
                            isInCart ? "Hapus dari Keranjang" : "Tambah ke Keranjang",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildDetailTable(Map<String, dynamic> user) {
  return Table(
    columnWidths: const {
      0: IntrinsicColumnWidth(),
      1: FixedColumnWidth(20),
      2: FlexColumnWidth(),
    },
    defaultVerticalAlignment: TableCellVerticalAlignment.top,
    children: [
      buildDetailRow("Brand", user['namabrand']),
      buildDetailRow("Kategori", "${user['namasubkategori']}"),
      buildDetailRow("Ukuran", "${user['ukuran']} ${user['namasatuan']}"),
      buildDetailRow("Stok Tersedia", "${user['stok']}"),
      buildDetailRowHarga("Harga", "${Styles.formatMoneyRp(user['hargajual'])}"),
    ],
  );
}

TableRow buildDetailRow(String label, String? value) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0),
        child: Text("  :  "),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Text(
          value ?? "-",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ],
  );
}

TableRow buildDetailRowHarga(String label, String? value) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Styles.primaryColor,),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0),
        child: Text("  :  ",style: TextStyle(color: Styles.primaryColor,fontSize: 18,fontWeight: FontWeight.w600,),),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Text(
          value ?? "-",
          style: const TextStyle(fontSize: 18, color: Styles.primaryColor,fontWeight: FontWeight.w600,),
        ),
      ),
    ],
  );
}