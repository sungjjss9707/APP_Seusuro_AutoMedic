import 'package:get/get.dart';

class AssetPageController extends GetxController {
  static AssetPageController get to => Get.find();

  RxInt orderIndex = 0.obs;
  RxInt sortIndex = 0.obs;
  RxInt dateIndex = 0.obs;
  RxInt locIndex = 0.obs;

  void changeOrderIndex(int index) {
    orderIndex(index);
  }

  void changeSortIndex(int index) {
    orderIndex(index);
  }

  void changeDateIndex(int index) {
    orderIndex(index);
  }

  void changeLocIndex(int index) {
    orderIndex(index);
  }
}
