import 'package:seusuro/src/model/dto/login_request_dto.dart';
import 'package:seusuro/src/repository/base_url.dart';

import 'package:http/http.dart' as http;

class LoginRepository {
  Future<http.Response> login(String email, String password) async {
    var url = Uri.parse('$baseUrl/login');

    http.Response response =
        await http.post(url, body: LoginRequestDto(email, password).toJson());

    return response;
  }
}
