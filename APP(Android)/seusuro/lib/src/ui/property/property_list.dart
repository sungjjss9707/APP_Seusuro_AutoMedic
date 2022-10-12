import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seusuro/src/ui/property/item.dart';

// ignore: must_be_immutable
class PropertyList extends StatefulWidget {
  PropertyList({super.key});

  int? totalNum;

  @override
  State<StatefulWidget> createState() => PropertyListState();
  
}

class PropertyListState extends State<PropertyList> {
  List<dynamic> assets = [];
  

  List<dynamic> testAssets = [
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
      'expirationDate': DateTime(2023, 10, 27),
      'logRecord': [
        '2022년 08월 25일 수입 3500EA',
        '2022년 09월 13일 불출 400EA',
        '2022년 09월 30일 불출 600EA',
      ]
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
      'expirationDate': DateTime(2023, 5, 11),
      'logRecord': [
        '2022년 08월 25일 수입 3500EA',
        '2022년 09월 13일 수입 400EA',
        '2022년 09월 30일 불출 600EA',
      ]
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
      'expirationDate': DateTime(2024, 10, 15),
      'logRecord': [
        '2022년 08월 25일 수입 3500EA',
        '2022년 09월 13일 불출 400EA',
        '2022년 09월 30일 수입 600EA',
      ]
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
      throw Exception('Failed to load PropertyList.');
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
            return item(testAssets[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 1.0);
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
