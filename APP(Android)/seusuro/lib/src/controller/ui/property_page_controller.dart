import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/model/property_info.dart';
import 'package:seusuro/src/model/token_info.dart';
import 'package:seusuro/src/repository/property_repository.dart';
import 'package:seusuro/src/responsive_snackbar.dart';

class PropertyPageController extends GetxController with StateMixin {
  static PropertyPageController get to => Get.find();

  final _propertyRepository = PropertyRepository();

  RxString selectedOrder = '가나다 순'.obs;
  RxString selectedStoragePlace = ''.obs;

  RxList<String> selectedCategories = <String>[].obs;

  Rx<DateTime> startDate = DateTime(2000, 1, 1).obs;
  Rx<DateTime> endDate = DateTime(2000, 1, 1).obs;

  var orderList = ['가나다 순', '최신 등록 순', '유효기간 짧은 순'];
  var categoryMap = {
    '경구약': Colors.blueAccent,
    '백신류': Colors.deepPurple,
    '분무약': Colors.green,
    '수액류': Colors.teal,
    '시럽류': Colors.deepOrange,
    '안약류': Colors.amber,
    '액체류': Colors.lightBlue,
    '연고류': Colors.lightGreen,
    '주사제': Colors.purple,
    '파스류': Colors.indigo,
    '의약외품': Colors.pink,
    '소모품': Colors.grey,
  };
  var storagePlaceList = [].obs;

  RxList propertyList = [].obs;

  RxList favoriteList = [].obs;

  Future<bool> getAllStoragePlaces() async {
    var response = await _propertyRepository.getAllStoragePlaces();

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      if (responseDto.data != null) {
        storagePlaceList.addAll(responseDto.data);
      }

      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  Future<bool> getAllFavorites() async {
    var response = await _propertyRepository.getAllFavorites();

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      favoriteList.clear();

      if (responseDto.data != null) {
        favoriteList.addAll(
            responseDto.data.map((element) => PropertyInfo.fromJson(element)));
      }
      
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  Future<bool> addFavorite(String propertyId) async {
    var response = await _propertyRepository.addFavorite(propertyId);

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      favoriteList.clear();

      if (responseDto.data != null) {
        favoriteList.addAll(
            responseDto.data.map((element) => PropertyInfo.fromJson(element)));
      }

      rSnackbar(title: '알림', message: '즐겨찾기에 추가하였습니다!');
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  Future<bool> delFavorite(String propertyId) async {
    var response = await _propertyRepository.delFavorite(propertyId);

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      favoriteList.clear();

      if (responseDto.data != null) {
        favoriteList.addAll(
            responseDto.data.map((element) => PropertyInfo.fromJson(element)));
      }

      rSnackbar(title: '알림', message: '즐겨찾기에서 삭제하였습니다!');
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  Future<bool> getProperties() async {
    change(null, status: RxStatus.loading());

    var category = selectedCategories.isEmpty ? null : selectedCategories;
    var firstDate = startDate.value == DateTime(2000, 1, 1)
        ? null
        : startDate.value.toString();
    var lastDate =
        endDate.value == DateTime(2000, 1, 1) ? null : endDate.value.toString();
    var storagePlace =
        selectedStoragePlace.isEmpty ? null : selectedStoragePlace.value;

    var response = await _propertyRepository.getProperties(
      category,
      firstDate,
      lastDate,
      storagePlace,
    );

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      propertyList.clear();

      if (responseDto.data != null) {
        propertyList.addAll(responseDto.data
            .map((element) => PropertyInfo.fromJson(element))
            .toList());
      }

      change(null, status: RxStatus.success());
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);

      change(null, status: RxStatus.success());
      return false;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    await getAllFavorites();
    await getAllStoragePlaces();

    await getProperties();
  }
}
