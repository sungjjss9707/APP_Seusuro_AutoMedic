class ItemInfo {
  final String name;
  final int amount;
  final String unit;
  final String category;
  final String storagePlace;
  final DateTime expirationDate;

  ItemInfo(
    this.name,
    this.amount,
    this.unit,
    this.category,
    this.storagePlace,
    this.expirationDate,
  );

  ItemInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        amount = json['amount'],
        unit = json['unit'],
        category = json['category'],
        storagePlace = json['storagePlace'],
        expirationDate = json['expirationDate'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'unit': unit,
        'category': category,
        'storagePlace': storagePlace,
        'expirationDate': expirationDate,
      };
}
