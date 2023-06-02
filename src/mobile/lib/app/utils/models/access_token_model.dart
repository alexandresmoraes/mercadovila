class AccessTokenModel {
  AccessTokenModel({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
    required this.refreshToken,
    required this.issuedUtc,
  });
  late final String accessToken;
  late final int expiresIn;
  late final String tokenType;
  late final String refreshToken;
  late final int issuedUtc;

  AccessTokenModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    expiresIn = json['expiresIn'];
    tokenType = json['tokenType'];
    refreshToken = json['refreshToken'];
    issuedUtc = json['issuedUtc'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['expiresIn'] = expiresIn;
    data['tokenType'] = tokenType;
    data['refreshToken'] = refreshToken;
    data['issuedUtc'] = issuedUtc;
    return data;
  }
}
