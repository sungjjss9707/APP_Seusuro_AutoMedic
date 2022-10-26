import 'dart:convert';
import 'dart:typed_data';

import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/model/user_info.dart';
import 'package:seusuro/src/repository/base_url.dart';

import 'package:http/http.dart' as http;

class MypageRepository {
  Future<ResponseDto> uploadImage(Uint8List imageAsBytes) async {
    var url = Uri.parse('$baseUrl/picture');

    var request = http.MultipartRequest('POST', url);

    var imageData = http.MultipartFile.fromBytes(
      'img',
      imageAsBytes,
      filename: 'userImage.png',
    );

    request.files.add(imageData);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return ResponseDto.fromJson(jsonDecode(response.body));
  }

  Future<ResponseDto> editProfile(UserInfo userInfo) async {
    var url = Uri.parse('$baseUrl/user');

    http.Response response = await http.put(
      url,
      headers: DataController.to.tokenInfo.toJson(),
      body: {
        'id': userInfo.id,
        'name': userInfo.name,
        'email': userInfo.email,
        'phoneNumber': userInfo.phoneNumber,
        'rank': userInfo.rank,
        'enlistmentDate': userInfo.enlistmentDate,
        'dischargeDate': userInfo.dischargeDate,
        'pictureName': userInfo.pictureName,
      },
    );

    return ResponseDto.fromJson(jsonDecode(response.body));
  }

  Future<http.Response> logout() async {
    var url = Uri.parse('$baseUrl/logout');

    http.Response response = await http.post(
      url,
      headers: DataController.to.tokenInfo.toJson(),
    );

    return response;
  }

  Future<ResponseDto> withdrawal() async {
    var url = Uri.parse('$baseUrl/user');

    http.Response response = await http.delete(
      url,
      headers: DataController.to.tokenInfo.toJson(),
    );

    return ResponseDto.fromJson(jsonDecode(response.body));
  }
}
