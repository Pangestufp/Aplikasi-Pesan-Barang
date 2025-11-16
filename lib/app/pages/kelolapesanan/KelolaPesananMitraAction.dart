import 'package:aplikasipemesananpulaubaru/app/controllers/PesananController.dart';
import 'package:aplikasipemesananpulaubaru/shared/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KelolaPesananMitraAction extends GetView<PesananController> {
  const KelolaPesananMitraAction({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: Styles.bar("Detail Pesanan"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final args = Get.arguments;
        final header = args["header"];
        final detailList = args["detailList"];

        if (detailList.isEmpty || header==null) {
          return const Center(child: Text("Detail barang keluar tidak ditemukan"));
        }


        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: FixedColumnWidth(20),
                      2: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    children: [
                      buildDetailRow("ID Transaksi", header['id_transaksi']),
                      buildDetailRow("Nama", header['name']),
                      buildDetailRow("Status", header['statuspesanan']),
                      buildDetailRow("Total", Styles.formatMoneyRp(header['total'])),
                      buildDetailRow("Waktu Dibuat", header['createat']),
                      buildDetailRow("Waktu Diubah", header['updateat']),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Detail Pesanan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: detailList.length,
                separatorBuilder: (context, index) => Divider(
                  color: Styles.primaryColor.withOpacity(0.3),
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final item = detailList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Styles.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.shopping_bag, color: Styles.primaryColor),
                    ),
                    title: Text(
                      item['namatext'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Harga: ${Styles.formatMoneyRp(item['hargajual'])}"),
                        Text("Jumlah: ${item['jumlah']}"),
                      ],
                    ),
                    trailing: Text(
                      Styles.formatMoneyRp(item['total']),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: Styles.radiusall,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMainActionButton(
                    context,
                    icon: Icons.fact_check,
                    label: "Setuju",
                    color: Colors.green,
                    onConfirm: () {
                      controller.Setuju();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMainActionButton(
                    context,
                    icon: Icons.description,
                    label: "Tolak",
                    color: Colors.red,
                    onConfirm: () {
                      controller.Tolak();
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ),




    );
  }
}

TableRow buildDetailRow(String label, String? value) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0),
        child: Text(":"),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          value ?? "-",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ],
  );
}


Widget _buildMainActionButton(
    BuildContext context, {
      required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onConfirm,
    }) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: Styles.primaryColor,
      backgroundColor: Styles.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Konfirmasi $label"),
            content: Text("Apakah Anda yakin ingin melakukan aksi '$label'?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                child: const Text("Ya"),
              ),
            ],
          );
        },
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 50, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    ),
  );
}
