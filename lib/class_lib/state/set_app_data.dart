import 'package:get/get.dart';
import 'dart:typed_data';

class SetAppDataController extends GetxController {
  var octWidth = 1024.obs;
  var octHeight = 1000.obs;
  var startPoint = 0.obs;
  var tempIndex = 0.obs;
  var showPage = 0.obs;
  Rx<Uint8List?> bmpHead = Rxn<Uint8List>();
  Rx<Uint8List?> receivedImageData = Rxn<Uint8List>();

  void switchPage(int page) {
    showPage.value = page;
  }
}
