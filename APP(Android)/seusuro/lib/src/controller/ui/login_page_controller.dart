import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  static LoginPageController get to => Get.find();

  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();

  @override
  void onClose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();

    super.onClose();
  }
}
