import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:seusuro/src/ui/asset/individual_item.dart';
import 'package:seusuro/src/ui/asset/asset.dart';

class AssetList extends StatefulWidget {
  const AssetList({super.key});

  @override
  State<StatefulWidget> createState() => _AssetListState();
  
}

class _AssetListState extends State<AssetList> {
  List<dynamic> assets = [];
  
  static DateFormat dateFormat = DateFormat("yyyy년 MM월 dd일");

  List<dynamic> testAssets = [
    Asset(
      id: '1234567890',
      name: '아세트아미노펜',
      unit: 'EA',
      totalAmount: 2500,
      amountByPlace: [

      ],
      expirationDate: dateFormat.parse("2022년 10월 27일"),
      logRecord: [

      ],
      createdAt: dateFormat.parse('2022년 09월 12일'),
      updatedAt: dateFormat.parse('2022년 10월 06일')
    ),
    Asset(
      id: '1234567890',
      name: '아세트아미노펜',
      unit: 'EA',
      totalAmount: 2500,
      amountByPlace: [

      ],
      expirationDate: dateFormat.parse("2022년 10월 27일"),
      logRecord: [

      ],
      createdAt: dateFormat.parse('2022년 09월 12일'),
      updatedAt: dateFormat.parse('2022년 10월 06일')
    ),
    Asset(
      id: '1234567890',
      name: '아세트아미노펜',
      unit: 'EA',
      totalAmount: 2500,
      amountByPlace: [

      ],
      expirationDate: dateFormat.parse("2022년 10월 27일"),
      logRecord: [

      ],
      createdAt: dateFormat.parse('2022년 09월 12일'),
      updatedAt: dateFormat.parse('2022년 10월 06일')
    ),
  ];

  @override
  void initState() {
    super.initState();
    _requestAssets();
  }

  _requestAssets() async {
    var response = await http.get(Uri.parse('https://seusuro.com/property/show'));
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
    });
  }

  @override
  Widget build(BuildContext context) {
    if (testAssets.isNotEmpty) {
      return Container(
        width: 360,
        height: 579,
        child: ListView.separated(
          itemCount: testAssets.length,
          itemBuilder: (context, index) {
            return individualItem('경구약', testAssets[index].name, testAssets[index].totalAmount);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      );
    } else {
      return Container(
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
