import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/model/token_info.dart';
import 'package:seusuro/src/model/user_info.dart';
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

    var response = await _loginRepository.login(email, password);

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.userInfo.value = UserInfo.fromJson(responseDto.data);
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      rSnackbar(title: '알림', message: '${responseDto.data['name']}님 환영합니다!');
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
