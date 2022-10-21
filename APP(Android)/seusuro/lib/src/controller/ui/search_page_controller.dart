import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/model/drug_info.dart';
import 'package:seusuro/src/model/dto/search_response_dto.dart';
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

  @override
  void onClose() {
    searchWordEditingController.dispose();

    super.onClose();
  }
}
