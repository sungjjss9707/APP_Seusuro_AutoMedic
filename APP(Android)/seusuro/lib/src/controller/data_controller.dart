import 'package:get/get.dart';

class DataController extends GetxService {
  static DataController get to => Get.find();

  var mobileWidth = 360.0;

  RxDouble screenWidth = 0.0.obs;

  bool isDesktop() => GetPlatform.isDesktop && screenWidth.value > mobileWidth;

  RxString userId = ''.obs;
  RxString accessToken = ''.obs;
  RxString refreshToken = ''.obs;
}
