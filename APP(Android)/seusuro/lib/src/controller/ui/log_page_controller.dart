import 'dart:convert';

import 'package:get/get.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/model/log_info.dart';
import 'package:seusuro/src/model/token_info.dart';
import 'package:seusuro/src/repository/log_repository.dart';
import 'package:seusuro/src/responsive_snackbar.dart';

class LogPageController extends GetxController {
  static LogPageController get to => Get.find();

  final _logRepository = LogRepository();

  RxList dateList = [].obs;
  RxList showDateList = [].obs;

  RxList<String> logTypeList = <String>[].obs;
  Rx<DateTime> filterDate = DateTime(2000, 1, 1).obs;

  RxList logList = [].obs;

  Future<bool> getLogs() async {
    var type = logTypeList.isEmpty ? null : logTypeList;
    var date = filterDate.value == DateTime(2000, 1, 1)
        ? null
        : filterDate.value.toString();

    var response = await _logRepository.getLogs(type, date);

    ResponseDto responseDto = ResponseDto.fromJson(jsonDecode(response.body));

    if (responseDto.status == 200) {
      DataController.to.tokenInfo.value = TokenInfo.fromJson(response.headers);

      if (responseDto.data != null) {
        logList.addAll(
            responseDto.data.map((element) => LogInfo.fromJson(element)));
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

    await getLogs();
  }
}
