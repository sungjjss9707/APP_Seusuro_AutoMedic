class LoginRequestDto {
  final String email;
  final String password;

  LoginRequestDto(
    this.email,
    this.password,
  );

  LoginRequestDto.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
