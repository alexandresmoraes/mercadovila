import 'package:vilasesmo/app/utils/utils.dart';

class AccountModel {
  AccountModel({
    this.id,
    required this.nome,
    required this.username,
    required this.email,
    required this.telefone,
    this.fotoUrl,
    required this.isAtivo,
    required this.roles,
  });
  late final String? id;
  late final String nome;
  late final String username;
  late final String email;
  late final String telefone;
  late final String? fotoUrl;
  late final bool isAtivo;
  late final List<String> roles;

  AccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    username = json['username'];
    email = json['email'];
    telefone = json['telefone'];
    fotoUrl = json['fotoUrl'];
    isAtivo = json['isAtivo'];
    roles = List.castFrom<dynamic, String>(json['roles']);
  }

  bool get isEditing => !isNullorEmpty(id);
  bool get isAdmin => roles.any((element) => element.toLowerCase() == "admin");
}
