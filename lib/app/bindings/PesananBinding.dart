import 'package:aplikasipemesananpulaubaru/app/controllers/PesananController.dart';
import 'package:get/get.dart';

class PesananBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>PesananController());
  }

}