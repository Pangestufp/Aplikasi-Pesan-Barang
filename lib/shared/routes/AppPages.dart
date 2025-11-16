import 'package:aplikasipemesananpulaubaru/app/bindings/AuthBinding.dart';
import 'package:aplikasipemesananpulaubaru/app/bindings/MenuUtamaBinding.dart';
import 'package:aplikasipemesananpulaubaru/app/bindings/PesananBinding.dart';
import 'package:aplikasipemesananpulaubaru/app/pages/LoginView.dart';
import 'package:aplikasipemesananpulaubaru/app/pages/MenuUtamaView.dart';
import 'package:aplikasipemesananpulaubaru/app/pages/kelolabarangkeluar/DetailBarang.dart';
import 'package:aplikasipemesananpulaubaru/app/pages/kelolabarangkeluar/KelolaBarangKeluarAddView.dart';
import 'package:aplikasipemesananpulaubaru/app/pages/kelolabarangkeluar/KelolaBarangKeluarCartView.dart';
import 'package:aplikasipemesananpulaubaru/app/pages/kelolapesanan/KelolaPesananMitra.dart';
import 'package:aplikasipemesananpulaubaru/app/pages/kelolapesanan/KelolaPesananMitraAction.dart';
import 'package:aplikasipemesananpulaubaru/shared/routes/Routes.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static final routes = [
    // Login & Menu Utama
    GetPage(
      name: Routes.MENU_LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.MENU_UTAMA,
      page: () => MenuUtamaView(),
      binding: MenuUtamaBinding(),
    ),
    GetPage(
      name: Routes.KELOLA_PESANAN_MITRA,
      page: () => KelolaPesananMitra(),
      binding: PesananBinding(),
    ),
    GetPage(
      name: Routes.KELOLA_DETAIL_BARANG,
      page: () => DetailBarang(),
      binding: PesananBinding(),
    ),
    GetPage(
      name: Routes.KELOLA_PESANAN_MITRA_ACTION,
      page: () => KelolaPesananMitraAction(),
      binding: PesananBinding(),
    ),
    GetPage(
      name: Routes.KELOLA_BARANGKELUAR_ADD,
      page: () => KelolaBarangKeluarAddView(),
      binding: PesananBinding(),
    ),
    GetPage(
      name: Routes.KELOLA_BARANGKELUAR_CART,
      page: () => KelolaBarangKeluarCartView(),
      binding: PesananBinding(),
    ),
  ];
}
