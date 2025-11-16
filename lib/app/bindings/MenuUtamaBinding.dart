import 'package:aplikasipemesananpulaubaru/app/controllers/MenuUtamaController.dart';
import 'package:get/get.dart';

class MenuUtamaBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>MenuUtamaController());
  }

}