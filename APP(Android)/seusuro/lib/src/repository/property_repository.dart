import 'dart:convert';

import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/repository/base_url.dart';

import 'package:http/http.dart' as http;

class PropertyRepository {
  Future<ResponseDto> viewIndividualProperty(String inherentID) async {
    var url = Uri.parse('$baseUrl/property/$inherentID');

    http.Response response = await http.get(url);

    return ResponseDto.fromJson(jsonDecode(response.body));
  }

  Future<ResponseDto> viewBookmarkedProperty() async {
    var url = Uri.parse('$baseUrl/property/favorite');

    http.Response response = await http.get(url);

    return ResponseDto.fromJson(jsonDecode(response.body));
  }

  Future<ResponseDto> addBookmarkedProperty(String inherentID) async {
    var url = Uri.parse('$baseUrl/property/favorite');

    http.Response response = await http.post(
      url,
      body: {
        'id': inherentID
      },
    );

    return ResponseDto.fromJson(jsonDecode(response.body));
  }
}