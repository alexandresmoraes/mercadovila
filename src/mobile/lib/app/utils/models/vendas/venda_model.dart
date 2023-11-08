class VendaModel {
  VendaModel({
    required this.compradorNome,
  });
  late final String compradorNome;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['compradorNome'] = compradorNome;
    return data;
  }

  VendaModel.fromJson(Map<String, dynamic> json) {
    compradorNome = json['compradorNome'];
  }
}

class VendaResponseModel {
  VendaResponseModel({required this.id});
  late final int id;

  VendaResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
