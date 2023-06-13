class AccountDto {
  AccountDto({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
  });
  late final String id;
  late final String username;
  late final String email;
  late final String? phoneNumber;

  AccountDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }
}
