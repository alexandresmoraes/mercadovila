class AccountDto {
  AccountDto({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.fotoUrl,
    required this.isAtivo,
  });
  late final String id;
  late final String username;
  late final String email;
  late final String? phoneNumber;
  late final String? fotoUrl;
  late final bool isAtivo;

  AccountDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    fotoUrl = json['fotoUrl'];
    isAtivo = json['isAtivo'];
  }
}
