import 'dart:convert';

import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/model/property_info.dart';
import 'package:seusuro/src/model/token_info.dart';
import 'package:seusuro/src/repository/property_repository.dart';
import 'package:seusuro/src/responsive_snackbar.dart';

class PropertyPageController extends GetxController {
  static PropertyPageController get to => Get.find();

  final _propertyRepository = PropertyRepository();

  RxString selectedOrder = '가나다 순'.obs;
  RxString selectedStoragePlace = ''.obs;

  RxList selectedCategories = [].obs;

  Rx<DateTime> firstDate = DateTime(2000, 1, 1).obs;
  Rx<DateTime> lastDate = DateTime(2000, 1, 1).obs;

  var orderList = ['가나다 순', '최신 등록 순', '유효기간 짧은 순'];
  var categoryMap = {
    '경구약': AppColors().textBlue,
    '백신류': AppColors().textPurple,
    '분무약': AppColors().textOrange,
    '보호대': AppColors().textGreen,
    '마스크': AppColors().textGrey,
    '소모품': AppColors().textBrown,
  };
  var storagePlaceList = [].obs;

  RxList propertyList = [].obs;

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

  Future<bool> getProperties() async {
    var category = null;
    var firstDate = null;
    var lastDate = null;
    var storagePlace = null;

    var response = await _propertyRepository.getProperties(
      category,
      firstDate,
      lastDate,
      storagePlace,
    );

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      if (responseDto.data != null) {
        propertyList.addAll(
            responseDto.data.map((element) => PropertyInfo.fromJson(element)));
      }

      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    // await getProperties();
    await getAllStoragePlaces();
  }
}
