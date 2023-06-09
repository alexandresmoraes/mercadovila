class LoginModel {
  String? usernameOrEmail;
  String? password;

  LoginModel({this.usernameOrEmail, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usernameOrEmail'] = usernameOrEmail;
    data['password'] = password;
    return data;
  }
}
