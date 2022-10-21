import 'dart:convert';

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
    List? storagePlace,
  ) async {
    var url = Uri.parse('$baseUrl/property');

    http.Response response = await http.post(
      url,
      headers: DataController.to.tokenInfo.toJson(),
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
