import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/dto/register_request_dto.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/model/token_info.dart';
import 'package:seusuro/src/model/user_info.dart';
import 'package:seusuro/src/repository/base_url.dart';
import 'package:seusuro/src/repository/register_repository.dart';
import 'package:seusuro/src/responsive_snackbar.dart';

class RegisterPageController extends GetxController {
  static RegisterPageController get to => Get.find();

  final _registerRepository = RegisterRepository();

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
  RxString imagePath = ''.obs;
  Rx<Uint8List> imageAsBytes = Uint8List(0).obs;

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

  Future<bool> checkEmail() async {
    String email = emailEditingController.text;

    ResponseDto responseDto = await _registerRepository.checkEmail(email);

    if (responseDto.status == 200) {
      if (!responseDto.data) {
        rSnackbar(title: '알림', message: '이미 존재하는 이메일입니다');
        return false;
      } else {
        return true;
      }
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  Future<bool> uploadImage() async {
    if (imageAsBytes.value.isNotEmpty) {
      ResponseDto responseDto =
          await _registerRepository.uploadImage(imageAsBytes.value);

      if (responseDto.status == 200) {
        imagePath.value = '$baseUrl/${responseDto.data}';
        return true;
      } else {
        rSnackbar(title: '알림', message: responseDto.message);
        return false;
      }
    } else {
      return true;
    }
  }

  Future<bool> checkMilitaryUnit() async {
    String militaryUnit = militaryUnitEditingController.text;
    String accessCode = accessCodeEditingController.text;

    ResponseDto responseDto =
        await _registerRepository.checkMilitaryUnit(militaryUnit, accessCode);

    if (responseDto.status == 200) {
      if (!responseDto.data) {
        rSnackbar(title: '알림', message: '접속 코드가 일치하지 않습니다');
        return false;
      } else {
        return true;
      }
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  Future<bool> register() async {
    var registerRequestDto = RegisterRequestDto(
      nameEditingController.text,
      emailEditingController.text,
      passwordEditingController.text,
      phoneNumberEditingController.text,
      serviceNumberEditingController.text,
      rank.value,
      enlistmentDate.value.toString(),
      dischargeDate.value.toString(),
      militaryUnitEditingController.text,
      imagePath.value,
    );

    var response = await _registerRepository.register(registerRequestDto);

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.userInfo.value = UserInfo.fromJson(responseDto.data);
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      rSnackbar(
        title: '알림',
        message: '${responseDto.data['name']}님 가입을 환영합니다!',
      );
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
    passwordConfirmEditingController.dispose();

    nameEditingController.dispose();
    phoneNumberEditingController.dispose();
    serviceNumberEditingController.dispose();

    militaryUnitEditingController.dispose();
    accessCodeEditingController.dispose();

    super.onClose();
  }
}
