import 'package:http/http.dart' as http;

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
}
