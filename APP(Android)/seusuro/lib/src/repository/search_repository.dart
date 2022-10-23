import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/drug_info.dart';
import 'package:seusuro/src/repository/base_url.dart';

class SearchRepository {
  Future<http.Response> search(String searchWord) async {
    var baseUrl =
        'https://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList';

    var serviceKey =
        'jtgUeK2VSjlcB5%2FMNGgZbAqZjwsRXxipRJruRFf1iKU5uqIxl6eee9KerzTHOJut8OD1oBcXB55PEzc3UP6nYA%3D%3D';

    var url = Uri.parse('$baseUrl?serviceKey=$serviceKey&itemName=$searchWord');

    http.Response response = await http.get(url);

    return response;
  }

  Future<http.Response> getAllBookmarks() async {
    var url = Uri.parse('$baseUrl/bookmark');

    http.Response response = await http.get(
      url,
      headers: DataController.to.tokenInfo.toJson(),
    );

    return response;
  }

  Future<http.Response> addBookmark(DrugInfo drugInfo) async {
    var url = Uri.parse('$baseUrl/bookmark');

    var headers = DataController.to.tokenInfo.toJson();
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    http.Response response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(drugInfo.toJson()),
    );

    return response;
  }

  Future<http.Response> delBookmark(DrugInfo drugInfo) async {
    var url = Uri.parse('$baseUrl/bookmark');

    var headers = DataController.to.tokenInfo.toJson();
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    http.Response response = await http.delete(
      url,
      headers: headers,
      body: jsonEncode({
        'itemName': drugInfo.itemName,
      }),
    );

    return response;
  }
}
