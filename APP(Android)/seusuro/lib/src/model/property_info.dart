class PropertyInfo {
  final String id;
  final String name;
  final String unit;
  final int totalAmount;
  final String category;
  final String niin;
  final List amountByPlace;
  final String expirationDate;
  final String logRecord;
  final String createdAt;
  final String updatedAt;

  PropertyInfo(
    this.id,
    this.name,
    this.unit,
    this.totalAmount,
    this.category,
    this.niin,
    this.amountByPlace,
    this.expirationDate,
    this.logRecord,
    this.createdAt,
    this.updatedAt,
  );

  PropertyInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        unit = json['unit'],
        totalAmount = json['totalAmount'],
        category = json['category'],
        niin = json['niin'],
        amountByPlace = json['amountByPlace'],
        expirationDate = json['expirationDate'],
        logRecord = json['logRecord'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unit': unit,
        'totalAmount': totalAmount,
        'category': category,
        'niin': niin,
        'amountByPlace': amountByPlace,
        'expirationDate': expirationDate,
        'logRecord': logRecord,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
