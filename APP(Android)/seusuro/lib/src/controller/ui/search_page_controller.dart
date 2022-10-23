import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/drug_info.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/model/dto/search_response_dto.dart';
import 'package:seusuro/src/model/token_info.dart';
import 'package:seusuro/src/repository/search_repository.dart';
import 'package:seusuro/src/responsive_snackbar.dart';
import 'package:xml2json/xml2json.dart';

class SearchPageController extends GetxController with StateMixin {
  static SearchPageController get to => Get.find();

  final _searchRepository = SearchRepository();

  final searchWordEditingController = TextEditingController();

  RxBool isSearching = false.obs;
  RxString searchWord = ''.obs;

  RxList recentSearchList = [].obs;
  RxList resultList = [].obs;

  RxList bookmarkList = [].obs;

  Future<bool> search(String searchWord) async {
    change(null, status: RxStatus.loading());

    var response = await _searchRepository.search(searchWord);
    var responseXml = utf8.decode(response.bodyBytes);

    final transformer = Xml2Json();
    transformer.parse(responseXml);

    var responseJson = transformer.toParker();
    var responseHeader = jsonDecode(responseJson)['response']['header'];
    var responseBody = jsonDecode(responseJson)['response']['body'];

    if (responseHeader['resultCode'] == '00') {
      SearchResponseDto searchResponseDto =
          SearchResponseDto.fromJson(responseBody);

      if (searchResponseDto.totalCount != '0') {
        if (searchResponseDto.totalCount == '1') {
          resultList.add(DrugInfo.fromJson(searchResponseDto.items['item']));
        } else {
          resultList.addAll(searchResponseDto.items['item']
              .map((element) => DrugInfo.fromJson(element)));
        }
      }

      change(null, status: RxStatus.success());
      return true;
    } else {
      rSnackbar(title: '알림', message: responseHeader['resultMsg']);

      change(null, status: RxStatus.success());
      return false;
    }
  }

  Future<bool> getAllBookmarks() async {
    change(null, status: RxStatus.loading());

    var response = await _searchRepository.getAllBookmarks();

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      bookmarkList.clear();

      if (responseDto.data != null) {
        bookmarkList.addAll(
            responseDto.data.map((element) => DrugInfo.fromJson(element)));
      }

      change(null, status: RxStatus.success());
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);

      change(null, status: RxStatus.success());
      return false;
    }
  }

  Future<bool> addBookmark(DrugInfo drugInfo) async {
    var response = await _searchRepository.addBookmark(drugInfo);

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      bookmarkList.clear();

      if (responseDto.data != null) {
        bookmarkList.addAll(
            responseDto.data.map((element) => DrugInfo.fromJson(element)));
      }

      rSnackbar(title: '알림', message: '북마크에 추가하였습니다!');
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  Future<bool> delBookmark(DrugInfo drugInfo) async {
    var response = await _searchRepository.delBookmark(drugInfo);

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      bookmarkList.clear();

      if (responseDto.data != null) {
        bookmarkList.addAll(
            responseDto.data.map((element) => DrugInfo.fromJson(element)));
      }

      rSnackbar(title: '알림', message: '북마크에서 삭제하였습니다!');
      return true;
    } else {
      rSnackbar(title: '알림', message: responseDto.message);
      return false;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    await getAllBookmarks();
  }

  @override
  void onClose() {
    searchWordEditingController.dispose();

    super.onClose();
  }
}
