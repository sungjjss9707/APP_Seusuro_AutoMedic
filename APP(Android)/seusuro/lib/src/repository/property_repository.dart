import 'dart:convert';
import 'dart:io';

import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/repository/base_url.dart';

import 'package:http/http.dart' as http;

class PropertyRepository {
  Future<http.Response> getAllStoragePlaces() async {
    var url = Uri.parse('$baseUrl/property/storagePlace');

    http.Response response = await http.get(
      url,
      headers: DataController.to.tokenInfo.toJson(),
    );

    return response;
  }

  Future<http.Response> getProperties(
    List<String>? category,
    String? firstDate,
    String? lastDate,
    String? storagePlace,
  ) async {
    var url = Uri.parse('$baseUrl/property');

    var headers = DataController.to.tokenInfo.toJson();
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    http.Response response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'category': category,
        'firstDate': firstDate,
        'lastDate': lastDate,
        'storagePlace': storagePlace,
      }),
    );

    return response;
  }
}
