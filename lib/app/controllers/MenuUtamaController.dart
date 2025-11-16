import 'package:aplikasipemesananpulaubaru/app/services/AuthService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/BarangService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/PesananService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/ProfilTokoService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/TokenService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/UserService.dart';
import 'package:aplikasipemesananpulaubaru/shared/routes/Routes.dart';
import 'package:get/get.dart';

class MenuUtamaController extends GetxController {

  final BarangService _barangService = BarangService();
  final ProfilTokoService _profilTokoService = ProfilTokoService();
  final PesananService _pesananService = PesananService();
  var barangList = <dynamic>[].obs;

  Future<void> fetchbarang() async {
    try {
      isLoadingUser.value = true;
      final barangs = await _barangService.getAllBarang();
      if (barangs.length > 5) {
        barangs.shuffle();
        barangList.assignAll(barangs.take(5).toList());
      } else {
        barangList.assignAll(barangs);
      }
    } finally {
      isLoadingUser.value = false;
    }
  }



  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  final TokenService _tokenService = TokenService();


  var user = Rxn<Map<String, dynamic>>();
  var isLoadingUser = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchbarang();
  }


  Future<void> fetchUserData() async {
    isLoadingUser.value = true;
    try {
      await _userService.getMyData();


      final userData = await _userService.getMyData();
      if (userData != null) {
        user.value = userData;

        final role = user.value?['role'] ?? '';
        if (role.toLowerCase() != 'partner') {
            await _authService.logout();
            await Get.offAllNamed(Routes.MENU_LOGIN);
            Get.snackbar("Error", "Pemilik dan karyawan tidak bisa masuk ke aplikasi ini", snackPosition: SnackPosition.BOTTOM,);
        }
      }

      await _profilTokoService.getProfilToko();
      await _pesananService.getAllPesanan();
      await _barangService.getAllBarang();
      await _pesananService.kirimPesananOffline();

    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pengguna: $e", snackPosition: SnackPosition.BOTTOM,);
    } finally {
      isLoadingUser.value = false;
    }
  }

  Future<void> logoutAndRedirect() async {
    final success = await _authService.logout();
    if (success) {
      Get.offAllNamed(Routes.MENU_LOGIN);
    } else {
      Get.snackbar("Error", "Logout gagal", snackPosition: SnackPosition.BOTTOM,);
    }
  }

}