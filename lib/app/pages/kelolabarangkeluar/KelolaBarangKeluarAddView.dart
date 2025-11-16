import 'package:aplikasipemesananpulaubaru/app/controllers/PesananController.dart';
import 'package:aplikasipemesananpulaubaru/shared/endpoints/EndPoints.dart';
import 'package:aplikasipemesananpulaubaru/shared/routes/Routes.dart';
import 'package:aplikasipemesananpulaubaru/shared/styles/Styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KelolaBarangKeluarAddView extends GetView<PesananController> {
  const KelolaBarangKeluarAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.secondaryColor,
      appBar: AppBar(
        title: const Text(
          'Menambahkan Barang',
          style: TextStyle(color: Styles.primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Styles.tertiaryColor,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.primaryColor),
      ),
      body: Column(
        children: [
          Container(
            decoration: Styles.radiusDownTertiary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: Styles.whiteTextField(),
                decoration: Styles.roundedInput("Cari Barang"),
                onChanged: (value) => controller.searchBarang(value),
              ),
            ),
          ),
          SizedBox(height: 10,),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Styles.primaryColor),
                  ),
                );
              }
              if (controller.filteredList.isEmpty) {
                return const Center(child: Text("Tidak ada data Barang"));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.7,
                ),
                itemCount: controller.filteredList.length,
                itemBuilder: (context, index) {
                  final barang = controller.filteredList[index];

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.KELOLA_DETAIL_BARANG,
                        arguments: barang,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Styles.primaryColor.withOpacity(0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 240,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: "${EndPoints.imageUrl}${barang['imagepath']}",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.broken_image,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                              ,
                            ),
                          ),
                          Text(
                            "${barang['namasubkategori']} ${barang['ukuran']} ${barang['namasatuan']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Brand : ${barang['namabrand']}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                Styles.formatMoneyRp(barang['hargajual']) ?? '-',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Stok : ${barang['stok']}" ?? '-',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(height: 2,),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: double.infinity,
                              child:
                              Obx(() {
                                final isInCart = controller.cartIds.contains(barang['id_barang']);
                                return ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isInCart ? Colors.green : Styles.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  onPressed: () {
                                    controller.addToCart(barang);


                                  },
                                  icon: Icon(
                                    isInCart ? Icons.check_circle : Icons.add_shopping_cart,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    isInCart ? "Ditambahkan" : "Tambahkan",
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                );
                              })
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.primaryColor,
        child: const Icon(Icons.shopping_cart, color: Colors.white),
        onPressed: () {
          Get.toNamed(Routes.KELOLA_BARANGKELUAR_CART);
        },
      ),
    );
  }
}