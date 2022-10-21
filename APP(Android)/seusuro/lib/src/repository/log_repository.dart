import 'dart:convert';
import 'dart:io';

import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/item_info.dart';
import 'package:seusuro/src/repository/base_url.dart';

import 'package:http/http.dart' as http;

class LogRepository {
  Future<http.Response> getLogs(List<String>? type, String? date) async {
    var url = Uri.parse('$baseUrl/paymentLog/filter');

    var headers = DataController.to.tokenInfo.toJson();
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    http.Response response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'type': type,
        'date': date,
      }),
    );

    return response;
  }

  Future<http.Response> writeLog(
    String receiptPayment,
    String target,
    List<ItemInfo> itemList,
    String confirmorId,
  ) async {
    var url = Uri.parse('$baseUrl/paymentLog');

    var headers = DataController.to.tokenInfo.toJson();
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    http.Response response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'receiptPayment': receiptPayment,
        'target': target,
        'items':
            itemList.map((ItemInfo itemInfo) => itemInfo.toJson()).toList(),
        'confirmor': confirmorId,
      }),
    );

    return response;
  }
}
