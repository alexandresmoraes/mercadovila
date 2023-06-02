class AccountModel {
  AccountModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.fotoUrl,
    required this.roles,
  });
  late final String id;
  late final String username;
  late final String email;
  late final String phoneNumber;
  late final String fotoUrl;
  late final List<String> roles;

  AccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    fotoUrl = json['fotoUrl'];
    roles = List.castFrom<dynamic, String>(json['roles']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['fotoUrl'] = fotoUrl;
    data['roles'] = roles;
    return data;
  }
}
