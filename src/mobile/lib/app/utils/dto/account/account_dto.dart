class AccountDto {
  AccountDto({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    required this.isAtivo,
  });
  late final String id;
  late final String username;
  late final String email;
  late final String? phoneNumber;
  late final bool isAtivo;

  AccountDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    isAtivo = json['isAtivo'];
  }
}
