class NewAndUpdateAccountModel {
  NewAndUpdateAccountModel({
    required this.nome,
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.telefone,
    this.fotoUrl,
    required this.isAtivo,
    required this.isAdmin,
  });
  late final String nome;
  late final String username;
  late final String email;
  late final String password;
  late final String confirmPassword;
  late final String telefone;
  String? fotoUrl;
  late final bool isAtivo;
  late final bool isAdmin;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nome'] = nome;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['telefone'] = telefone;
    data['fotoUrl'] = fotoUrl;
    data['isAtivo'] = isAtivo;
    data['isAdmin'] = isAdmin;
    return data;
  }
}

class NewAccountResponseModel {
  NewAccountResponseModel({required this.id});
  late final String id;

  NewAccountResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
