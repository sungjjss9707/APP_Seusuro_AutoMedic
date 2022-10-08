import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/model/item_info.dart';

class WriteLogPageController extends GetxController {
  static WriteLogPageController get to => Get.find();

  final targetEditingController = TextEditingController();
  final nameEditingController = TextEditingController();
  final amountEditingController = TextEditingController();
  final storagePlaceEditingController = TextEditingController();

  RxString unit = 'EA'.obs;
  RxString category = ''.obs;
  Rx<DateTime> expirationDate = DateTime(2000, 1, 1).obs;

  RxList<ItemInfo> itemList = <ItemInfo>[].obs;

  var detailTitleList = [
    '품명',
    '분류',
    '수량',
    '유효기간',
    '보관장소',
  ];

  var categoryList = [
    '경구약',
    '백신류',
    '분무약',
    '보호대',
    '마스크',
    '소모품',
  ];

  var unitList = [
    'EA',
    'TT',
    'BT',
    'BX',
    'TU',
    'AMP',
  ];

  void resetInputs() {
    nameEditingController.clear();
    amountEditingController.clear();
    storagePlaceEditingController.clear();

    unit.value = 'EA';
    category.value = '';
    expirationDate.value = DateTime(2000, 1, 1);
  }

  @override
  void onClose() {
    targetEditingController.dispose();
    nameEditingController.dispose();
    amountEditingController.dispose();
    storagePlaceEditingController.dispose();

    super.onClose();
  }
}
