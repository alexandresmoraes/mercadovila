class NotificacaoDto {
  NotificacaoDto({
    required this.id,
    required this.titulo,
    required this.mensagem,
    this.imageUrl,
    required this.dataCriacao,
  });
  late final String id;
  late final String titulo;
  late final String mensagem;
  late final String? imageUrl;
  late final DateTime dataCriacao;

  NotificacaoDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    mensagem = json['mensagem'];
    imageUrl = json['imageUrl'];
    dataCriacao = DateTime.parse(json['dataCriacao']);
  }
}
