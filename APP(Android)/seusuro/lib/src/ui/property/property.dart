import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

Future<Property> fetchAsset() async {
  final response = await http.get(Uri.parse('https://seusuro.com/property/show'));

  if (response.statusCode == 200) {
    return Property.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Property.');
  }
}

class Property {
  final String id;
  final String name;
  final String unit;
  final int totalAmount;
  final List amountByPlace;
  final DateTime expirationDate;
  final List logRecord;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Property({
    required this.id,
    required this.name,
    required this.unit,
    required this.totalAmount,
    required this.amountByPlace,
    required this.expirationDate,
    required this.logRecord,
    required this.createdAt, 
    required this.updatedAt
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      totalAmount: json['totalAmount'],
      amountByPlace: json['amountByPlace'],
      expirationDate: json['expirationDate'],
      logRecord: json['logRecord'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt']
    );
  }
}