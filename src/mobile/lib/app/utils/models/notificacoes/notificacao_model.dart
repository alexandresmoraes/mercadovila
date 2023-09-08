class NotificacaoModel {
  NotificacaoModel({
    required this.titulo,
    required this.mensagem,
    this.imageUrl,
  });
  late final String titulo;
  late final String mensagem;
  late final String? imageUrl;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['titulo'] = titulo;
    data['mensagem'] = mensagem;
    data['imageUrl'] = imageUrl;
    return data;
  }

  NotificacaoModel.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    mensagem = json['mensagem'];
    imageUrl = json['imageUrl'];
  }
}

class NotificacaoResponseModel {
  NotificacaoResponseModel({required this.id});
  late final String id;

  NotificacaoResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
