class DrugInfo {
  final String? entpName; // 업체명
  final String? itemName; // 제품명
  final String? efcyQesitm; // 1. 효능
  final String? useMethodQesitm; // 2. 사용법
  final String? atpnWarnQesitm; // 3. 경고사항
  final String? atpnQesitm; // 4. 주의사항
  final String? intrcQesitm; // 5. 상호작용
  final String? seQesitm; // 6. 부작용
  final String? depositMethodQesitm; // 7. 보관법
  final String? itemImage; // 낱알이미지

  DrugInfo(
    this.entpName,
    this.itemName,
    this.efcyQesitm,
    this.useMethodQesitm,
    this.atpnWarnQesitm,
    this.atpnQesitm,
    this.intrcQesitm,
    this.seQesitm,
    this.depositMethodQesitm,
    this.itemImage,
  );

  DrugInfo.fromJson(Map<String, dynamic> json)
      : entpName = json['entpName'],
        itemName = json['itemName'],
        efcyQesitm = json['efcyQesitm'],
        useMethodQesitm = json['useMethodQesitm'],
        atpnWarnQesitm = json['atpnWarnQesitm'],
        atpnQesitm = json['atpnQesitm'],
        intrcQesitm = json['intrcQesitm'],
        seQesitm = json['seQesitm'],
        depositMethodQesitm = json['depositMethodQesitm'],
        itemImage = json['itemImage'];

  Map<String, dynamic> toJson() => {
        'entpName': entpName,
        'itemName': itemName,
        'efcyQesitm': efcyQesitm,
        'useMethodQesitm': useMethodQesitm,
        'atpnWarnQesitm': atpnWarnQesitm,
        'atpnQesitm': atpnQesitm,
        'intrcQesitm': intrcQesitm,
        'seQesitm': seQesitm,
        'depositMethodQesitm': depositMethodQesitm,
        'itemImage': itemImage,
      };
}
