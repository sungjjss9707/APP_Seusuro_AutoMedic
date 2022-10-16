import 'package:get/get.dart';

class MainPageController extends GetxController {
  static MainPageController get to => Get.find();

  RxInt currentIndex = 0.obs;

  void changePageIndex(int index) {
    currentIndex(index);
  }
}
