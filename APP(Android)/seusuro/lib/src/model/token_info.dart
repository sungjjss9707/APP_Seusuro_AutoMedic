class TokenInfo {
  final String accessToken;
  final String refreshToken;

  TokenInfo(
    this.accessToken,
    this.refreshToken,
  );

  TokenInfo.fromJson(Map<String, dynamic> json)
      : accessToken = json['accesstoken'],
        refreshToken = json['refreshtoken'];

  Map<String, String> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}
