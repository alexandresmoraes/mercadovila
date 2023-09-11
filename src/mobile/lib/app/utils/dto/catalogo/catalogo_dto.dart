class CatalogoDto {
  CatalogoDto({
    required this.id,
    required this.nome,
    required this.imageUrl,
    required this.preco,
    required this.unidadeMedida,
    required this.estoque,
    required this.isAtivo,
  });
  late final String id;
  late final String nome;
  late final String imageUrl;
  late final double preco;
  late final String unidadeMedida;
  late final int estoque;
  late final bool isAtivo;

  CatalogoDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    imageUrl = json['imageUrl'];
    preco = json['preco'];
    unidadeMedida = json['unidadeMedida'];
    estoque = json['estoque'];
    isAtivo = json['isAtivo'];
  }

  String getDisponiveis() => estoque == 0
      ? 'Fora de estoque'
      : estoque == 1
          ? '1 disponível'
          : '$estoque disponíveis';
}
