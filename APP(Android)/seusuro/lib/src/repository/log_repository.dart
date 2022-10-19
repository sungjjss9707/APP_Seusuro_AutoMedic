import 'dart:convert';

import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/repository/base_url.dart';

import 'package:http/http.dart' as http;

class LogRepository {
  Future<http.Response> getLogs(List<String>? type, String? date) async {
    var url = Uri.parse('$baseUrl/paymentLog/filter');

    http.Response response = await http.post(
      url,
      headers: DataController.to.tokenInfo.toJson(),
      body: jsonEncode({
        'type': type,
        'date': date,
      }),
    );

    return response;
  }
}
