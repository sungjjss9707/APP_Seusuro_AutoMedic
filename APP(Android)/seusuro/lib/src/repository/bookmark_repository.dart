import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/repository/base_url.dart';

import 'package:http/http.dart' as http;

class BookmarkRepository {
  Future<http.Response> getAllBookmarks() async {
    var url = Uri.parse('$baseUrl/bookmark');

    http.Response response = await http.get(
      url,
      headers: DataController.to.tokenInfo.toJson(),
    );

    return response;
  }
}
