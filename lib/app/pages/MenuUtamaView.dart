import 'package:aplikasipemesananpulaubaru/app/controllers/MenuUtamaController.dart';
import 'package:aplikasipemesananpulaubaru/shared/routes/Routes.dart';
import 'package:aplikasipemesananpulaubaru/shared/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuUtamaView extends GetView<MenuUtamaController> {
  const MenuUtamaView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text( ''),
        centerTitle: true,
        backgroundColor: Styles.tertiaryColor,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.primaryColor),
      ),
      drawer: Drawer(
        child: Obx(
              () {
            final userName = controller.user.value?['name'] ?? 'Pengguna';
            final userEmail = controller.user.value?['email'] ?? 'email@example.com';

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Styles.primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Styles.primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Get.back();
                    controller.logoutAndRedirect();
                  },
                ),
              ],
            );
          },
        ),
      ),

      body: Obx(() {
        if (controller.isLoadingUser.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Styles.primaryColor),
                SizedBox(height: 12),
                Text("Memuat data pengguna...", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Styles.tertiaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Obx(() {
                  final list = controller.barangList;

                  if (list.isEmpty) {
                    return const Center(
                      child: Text("Belum ada data barang."),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: SizedBox(
                      height: 420,
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index]['namatext'].toString();
                          final stok = list[index]['stok'];
                          final harga = Styles.formatMoneyRp(list[index]['hargajual']);


                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _buildProductCard(item, "Sisa Stok (${stok})", harga),
                          );
                        },
                      ),
                    ),
                  );
                })

              ),



              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildMenuItem(
                        icon: Icons.input,
                        label: 'Pesan',
                        onTap: () {
                          Get.toNamed(Routes.KELOLA_BARANGKELUAR_ADD);
                        }
                    ),
                    _buildMenuItem(
                      icon: Icons.input,
                      label: 'Kelola Pesanan',
                      onTap: () {
                            Get.toNamed(Routes.KELOLA_PESANAN_MITRA);
                      }
                    ),

                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProductCard(String name, String dtl1, String dtl2) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Styles.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.thumb_up_alt_rounded,
              color: Styles.primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Styles.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dtl1,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dtl2,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Styles.primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Styles.secondaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Styles.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildMenuItem2({
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.receipt_rounded, color: Styles.primaryColor,),
        title: Text(
          label,
          style: TextStyle(
            color: Styles.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.open_in_new_rounded,
          color: Styles.primaryColor,
        ),
      ),
    );
  }

}
