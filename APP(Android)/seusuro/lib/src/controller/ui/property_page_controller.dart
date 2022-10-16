import 'package:get/get.dart';

class PropertyPageController extends GetxController {
  static PropertyPageController get to => Get.find();

  RxInt orderIndex = 0.obs;
  RxInt sortIndex = 0.obs;
  RxInt dateIndex = 0.obs;
  RxInt locIndex = 0.obs;

  RxBool includeOrally = false.obs;
  RxBool includeVaccine = false.obs;
  RxBool includeAerosol = false.obs;
  RxBool includeGuard = false.obs;
  RxBool includeMask = false.obs;
  RxBool includeConsumable = false.obs;

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
