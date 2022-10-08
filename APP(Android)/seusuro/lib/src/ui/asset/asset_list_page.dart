import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:seusuro/src/ui/asset/item.dart';
import 'package:seusuro/src/ui/asset/asset.dart';

// ignore: must_be_immutable
class AssetListPage extends StatefulWidget {
  AssetListPage({super.key});

  late int totalNum = 0;

  @override
  State<StatefulWidget> createState() => _AssetListPageState();
  
}

class _AssetListPageState extends State<AssetListPage> {
  List<dynamic> assets = [];
  
  static DateFormat dateFormat = DateFormat("yyyy년 MM월 dd일");

  List<Map<String, dynamic>> testAssets = [
    {
      'id': '1234567890',
      'name': '아세트아미노펜',
      'unit': 'EA',
      'totalAmount': 2500,
      'category': '경구약',
      'niin': '1234567890',
      'amountByPlace': [
        {
          'storagePlace': '약장함 1',
          'amount': 1900
        },
        {
          'storagePlace': '약장함 2',
          'amount': 600
        },
      ],
    },
    {
      'id': '1234567890',
      'name': '벤토린에보할러',
      'unit': 'EA',
      'totalAmount': 12,
      'category': '분무약',
      'niin': '1234567890',
      'amountByPlace': [
        {
          'storagePlace': '약장함 1',
          'amount': 1900
        },
        {
          'storagePlace': '약장함 2',
          'amount': 600
        },
      ],
    },
    {
      'id': '1234567890',
      'name': '하브릭스주',
      'unit': 'EA',
      'totalAmount': 20,
      'category': '백신류',
      'niin': '1234567890',
      'amountByPlace': [
        {
          'storagePlace': '약장함 1',
          'amount': 1900
        },
        {
          'storagePlace': '약장함 2',
          'amount': 600
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _requestAssets();
  }

  _requestAssets() async {
    var response = await http.get(Uri.parse('https://seusuro.com/property'));
    var statusCode = response.statusCode;

    List<dynamic> list = [];
    if (statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      list = jsonDecode(responseBody);
    } else {
      throw Exception('Failed to load AssetList.');
    }

    setState(() {
      assets = list;
      widget.totalNum = testAssets.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (testAssets.isNotEmpty) {
      return SizedBox(
        width: 360,
        height: MediaQuery.of(context).size.height - 235,
        child: ListView.separated(
          itemCount: testAssets.length,
          itemBuilder: (context, index) {
            return item(testAssets[index]['category'], testAssets[index]['name'], testAssets[index]['unit'], testAssets[index]['totalAmount']);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      );
    } else {
      return SizedBox(
        width: 360,
        height: 579,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(height: 265,),
            Text(
              '재산이 없습니다.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        )
      );
    }
  }
}
