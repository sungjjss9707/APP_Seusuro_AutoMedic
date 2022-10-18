import 'dart:convert';

import 'package:get/get.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/drug_info.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/model/token_info.dart';
import 'package:seusuro/src/repository/bookmark_repository.dart';
import 'package:seusuro/src/responsive_snackbar.dart';

class BookmarkPageController extends GetxController with StateMixin {
  static BookmarkPageController get to => Get.find();

  final _bookmarkRepository = BookmarkRepository();

  RxList bookmarkList = [].obs;

  Future<bool> getAllBookmarks() async {
    change(null, status: RxStatus.loading());

    var response = await _bookmarkRepository.getAllBookmarks();

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      bookmarkList.value = responseDto.data
          .map((element) => DrugInfo.fromJson(element))
          .toList();

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

    await getAllBookmarks();
  }
}
