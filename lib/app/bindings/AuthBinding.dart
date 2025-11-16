import 'package:aplikasipemesananpulaubaru/app/controllers/AuthController.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>AuthController());
  }

}