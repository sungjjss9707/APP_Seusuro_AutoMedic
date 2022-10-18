class ItemInfo {
  final String name;
  final int amount;
  final String unit;
  final String category;
  final String storagePlace;
  final String expirationDate;
  final String niin;

  ItemInfo(
    this.name,
    this.amount,
    this.unit,
    this.category,
    this.storagePlace,
    this.expirationDate,
    this.niin,
  );

  ItemInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        amount = json['amount'],
        unit = json['unit'],
        category = json['category'],
        storagePlace = json['storagePlace'],
        expirationDate = json['expirationDate'],
        niin = json['niin'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'unit': unit,
        'category': category,
        'storagePlace': storagePlace,
        'expirationDate': expirationDate,
        'niin': niin,
      };
}
