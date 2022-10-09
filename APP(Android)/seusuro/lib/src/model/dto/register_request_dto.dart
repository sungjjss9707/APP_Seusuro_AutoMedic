class RegisterRequestDto {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String serviceNumber;
  final String rank;
  final String enlistmentDate;
  final String dischargeDate;
  final String militaryUnit;
  final String pictureName;

  RegisterRequestDto(
    this.name,
    this.email,
    this.password,
    this.phoneNumber,
    this.serviceNumber,
    this.rank,
    this.enlistmentDate,
    this.dischargeDate,
    this.militaryUnit,
    this.pictureName,
  );

  RegisterRequestDto.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'],
        phoneNumber = json['phoneNumber'],
        serviceNumber = json['serviceNumber'],
        rank = json['rank'],
        enlistmentDate = json['enlistmentDate'],
        dischargeDate = json['dischargeDate'],
        militaryUnit = json['militaryUnit'],
        pictureName = json['pictureName'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'serviceNumber': serviceNumber,
        'rank': rank,
        'enlistmentDate': enlistmentDate,
        'dischargeDate': dischargeDate,
        'militaryUnit': militaryUnit,
        'pictureName': pictureName,
      };
}
