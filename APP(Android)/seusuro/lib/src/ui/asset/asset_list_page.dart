import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seusuro/src/ui/asset/individual_item.dart';

class AssetList extends StatefulWidget {
  const AssetList({super.key});

  @override
  State<StatefulWidget> createState() => _AssetListState();
  
}

class _AssetListState extends State<AssetList> {
  List<dynamic> assets = [];
  
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
    return ListView.separated(
      itemCount: assets.length,
      itemBuilder: (BuildContext context, int index) {
        return individualItem(assets[index]['category'], assets[index]['name'], assets[index]['totalAmount']);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}