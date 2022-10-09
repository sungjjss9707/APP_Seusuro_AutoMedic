import 'dart:convert';
import 'dart:typed_data';

import 'package:seusuro/src/model/dto/register_request_dto.dart';
import 'package:seusuro/src/model/dto/response_dto.dart';
import 'package:seusuro/src/repository/base_url.dart';

import 'package:http/http.dart' as http;

class RegisterRepository {
  Future<ResponseDto> checkEmail(String email) async {
    var url = Uri.parse('$baseUrl/user/reduplication');

    http.Response response = await http.post(url, body: {
      "email": email,
    });

    return ResponseDto.fromJson(jsonDecode(response.body));
  }

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

  Future<ResponseDto> checkMilitaryUnit(
    String militaryUnit,
    String accessCode,
  ) async {
    var url = Uri.parse('$baseUrl/user/belong');

    http.Response response = await http.post(url, body: {
      "militaryUnit": militaryUnit,
      "accessCode": accessCode,
    });

    return ResponseDto.fromJson(jsonDecode(response.body));
  }

  Future<http.Response> register(RegisterRequestDto registerRequestDto) async {
    var url = Uri.parse('$baseUrl/user');

    http.Response response =
        await http.post(url, body: registerRequestDto.toJson());

    return response;
  }
}
