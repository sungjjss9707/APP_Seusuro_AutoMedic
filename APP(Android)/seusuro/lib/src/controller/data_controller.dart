import 'package:get/get.dart';
import 'package:seusuro/src/model/token_info.dart';
import 'package:seusuro/src/model/user_info.dart';

class DataController extends GetxService {
  static DataController get to => Get.find();

  var mobileWidth = 360.0;

  RxDouble screenWidth = 0.0.obs;

  bool isDesktop() => GetPlatform.isDesktop && screenWidth.value > mobileWidth;

  var userInfo = Rxn<UserInfo>();
  var tokenInfo = Rxn<TokenInfo>();

  void logout() {
    userInfo.value = null;
    tokenInfo.value = null;
  }
}
