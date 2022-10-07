import 'package:get/get.dart';

class LogPageController extends GetxController {
  static LogPageController get to => Get.find();

  var detailTitleList = [
    '품명',
    '분류',
    'NIIN',
    '수량',
    '유효기간',
    '보관장소',
    '수입시각',
  ];

  var detailContentList = [
    '품명',
    '분류',
    'NIIN',
    '수량',
    '유효기간',
    '보관장소',
    '수입시각',
  ];
}
