import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/repository/login_repository.dart';
import 'package:seusuro/src/responsive_snackbar.dart';

class LoginPageController extends GetxController {
  static LoginPageController get to => Get.find();

  final _loginRepository = LoginRepository();

  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();

  Future<bool> login() async {
    String email = emailEditingController.text;
    String password = passwordEditingController.text;

    ResponseDto responseDto = await _loginRepository.login(email, password);

    if (responseDto.status == 200) {
      rSnackbar(title: '알림', message: '로그인에 성공하였습니다!');
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  @override
  void onClose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();

    super.onClose();
  }
}
