import 'package:aplikasipemesananpulaubaru/app/services/AuthService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/BarangService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/PesananService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/ProfilTokoService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/TokenService.dart';
import 'package:aplikasipemesananpulaubaru/app/services/UserService.dart';
import 'package:aplikasipemesananpulaubaru/shared/routes/Routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final TokenService _tokenService = TokenService();
  final UserService _userService = UserService();
  final ProfilTokoService _profilTokoService = ProfilTokoService();
  final PesananService _pesananService = PesananService();
  final BarangService _barangService = BarangService();


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    isLoading.value = true;
    final success = await _authService.login(emailController.text, passwordController.text);
    isLoggedIn.value = success;
    isLoading.value = false;

    if (success) {
      await _userService.getMyData();
      await _profilTokoService.getProfilToko();
      await _pesananService.getAllPesanan();
      await _barangService.getAllBarang();
      Get.offAllNamed(Routes.MENU_UTAMA);
    } else {
      Get.snackbar(
        "Login Gagal",
        "Periksa kembali email dan password Anda.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    }
  }

  Future<void> logoutAndRedirect() async {
    final success = await _authService.logout();
    if (success) {
      isLoggedIn.value = false;
      Get.offAllNamed(Routes.MENU_LOGIN);
    } else {
      Get.snackbar("Error", "Logout gagal");
    }
  }

  Future<void> checkLoginStatus() async {
    final token = await _tokenService.getToken();
    isLoggedIn.value = token != null;
  }
}