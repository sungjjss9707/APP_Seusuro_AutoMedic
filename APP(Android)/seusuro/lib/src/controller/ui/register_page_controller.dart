import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPageController extends GetxController {
  static RegisterPageController get to => Get.find();

  RxInt registerStep = 1.obs;

  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final passwordConfirmEditingController = TextEditingController();

  final nameEditingController = TextEditingController();
  final phoneNumberEditingController = TextEditingController();
  final serviceNumberEditingController = TextEditingController();

  final militaryUnitEditingController = TextEditingController();
  final accessCodeEditingController = TextEditingController();

  RxString rank = ''.obs;
  Rx<DateTime> enlistmentDate = DateTime(2000, 1, 1).obs;
  Rx<DateTime> dischargeDate = DateTime(2000, 1, 1).obs;

  var rankList = [
    '대위',
    '중위',
    '소위',
    '상사',
    '중사',
    '하사',
    '병장',
    '상병',
    '일병',
    '이병',
  ];

  @override
  void onClose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    passwordConfirmEditingController.dispose();

    nameEditingController.dispose();
    phoneNumberEditingController.dispose();
    serviceNumberEditingController.dispose();

    militaryUnitEditingController.dispose();
    accessCodeEditingController.dispose();

    super.onClose();
  }
}
