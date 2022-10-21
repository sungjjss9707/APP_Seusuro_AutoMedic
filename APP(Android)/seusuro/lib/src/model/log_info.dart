import 'package:seusuro/src/model/item_info.dart';
import 'package:seusuro/src/model/user_info.dart';

class LogInfo {
  final String id;
  final String receiptPayment;
  final String target;
  final List<dynamic> items;
  final UserInfo confirmor;
  final String createdAt;
  final String updatedAt;

  LogInfo(
    this.id,
    this.receiptPayment,
    this.target,
    this.items,
    this.confirmor,
    this.createdAt,
    this.updatedAt,
  );

  LogInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        receiptPayment = json['receiptPayment'],
        target = json['target'],
        items = json['items'].map((element) => ItemInfo.fromJson(element)).toList(),
        confirmor = UserInfo.fromJson(json['confirmor']),
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'receiptPayment': receiptPayment,
        'target': target,
        'items': items,
        'confirmor': confirmor,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
