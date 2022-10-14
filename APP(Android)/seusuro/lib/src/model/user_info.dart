class UserInfo {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String serviceNumber;
  final String rank;
  final String enlistmentDate;
  final String dischargeDate;
  final String militaryUnit;
  final String pictureName;
  final String createdAt;
  final String updatedAt;

  UserInfo(
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.serviceNumber,
    this.rank,
    this.enlistmentDate,
    this.dischargeDate,
    this.militaryUnit,
    this.pictureName,
    this.createdAt,
    this.updatedAt,
  );

  UserInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        serviceNumber = json['serviceNumber'],
        rank = json['rank'],
        enlistmentDate = json['enlistmentDate'],
        dischargeDate = json['dischargeDate'],
        militaryUnit = json['militaryUnit'],
        pictureName = json['pictureName'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'serviceNumber': serviceNumber,
        'rank': rank,
        'enlistmentDate': enlistmentDate,
        'dischargeDate': dischargeDate,
        'militaryUnit': militaryUnit,
        'pictureName': pictureName,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
