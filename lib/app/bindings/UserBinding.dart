import 'package:aplikasipemesananpulaubaru/app/controllers/UserController.dart';
import 'package:get/get.dart';

class UserBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>UserController());
  }

}