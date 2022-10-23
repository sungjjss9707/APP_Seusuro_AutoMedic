import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/model/token_info.dart';
import 'package:seusuro/src/model/user_info.dart';
import 'package:seusuro/src/repository/base_url.dart';
import 'package:seusuro/src/repository/mypage_repository.dart';
import 'package:seusuro/src/responsive_snackbar.dart';

class MypagePageController extends GetxController {
  static MypagePageController get to => Get.find();

  final _mypageRepository = MypageRepository();

  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final phoneNumberEditingController = TextEditingController();

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

  void resetInputs() {
    var userInfo = DataController.to.userInfo.value;

    nameEditingController.text = userInfo!.name;
    emailEditingController.text = userInfo.email;
    phoneNumberEditingController.text = userInfo.phoneNumber;

    rank.value = userInfo.rank;
    imagePath.value = userInfo.pictureName;
    imageAsBytes.value = Uint8List(0);

    enlistmentDate.value =
        DateFormat('yyyy-MM-dd hh:mm:ss').parse(userInfo.enlistmentDate);
    dischargeDate.value =
        DateFormat('yyyy-MM-dd hh:mm:ss').parse(userInfo.dischargeDate);
  }

  Future<bool> uploadImage() async {
    if (imageAsBytes.value.isNotEmpty) {
      ResponseDto responseDto =
          await _mypageRepository.uploadImage(imageAsBytes.value);

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

  Future<bool> editProfile(UserInfo userInfo) async {
    ResponseDto responseDto = await _mypageRepository.editProfile(userInfo);

    if (responseDto.status == 200) {
      DataController.to.userInfo.value = userInfo;

      Get.back();
      rSnackbar(title: '알림', message: '회원 정보가 수정되었습니다!');
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  Future<bool> logout() async {
    var response = await _mypageRepository.logout();
    
    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      rSnackbar(title: '알림', message: '로그아웃이 완료되었습니다!');
      return true;
    } else {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);
      
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  Future<bool> withdrawal() async {
    ResponseDto responseDto = await _mypageRepository.withdrawal();

    if (responseDto.status == 200) {
      rSnackbar(title: '알림', message: '회원탈퇴가 완료되었습니다!');
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  @override
  void onClose() {
    nameEditingController.dispose();
    emailEditingController.dispose();
    phoneNumberEditingController.dispose();

    super.onClose();
  }
}
