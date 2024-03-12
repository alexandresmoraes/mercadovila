class CompraItemDto {
  late final String produtoId;
  late final String nome;
  late final String descricao;
  late final String imageUrl;
  late final double precoPago;
  late final int quantidade;
  late final String unidadeMedida;

  CompraItemDto({
    required this.produtoId,
    required this.nome,
    required this.descricao,
    required this.imageUrl,
    required this.precoPago,
    required this.quantidade,
    required this.unidadeMedida,
  });

  CompraItemDto.fromJson(Map<String, dynamic> json) {
    produtoId = json['produtoId'];
    nome = json['nome'];
    descricao = json['descricao'];
    imageUrl = json['imageUrl'];
    precoPago = json['precoPago'];
    quantidade = json['quantidade'];
    unidadeMedida = json['unidadeMedida'];
  }
}

class CompraDto {
  late final int id;
  late final DateTime dataHora;
  late final num total;
  late final String usuarioId;
  late final String usuarioNome;
  late final String usuarioEmail;
  late final String? usuarioFotoUrl;
  late final List<CompraItemDto> itens;

  CompraDto({
    required this.id,
    required this.dataHora,
    required this.total,
    required this.usuarioId,
    required this.usuarioNome,
    required this.usuarioEmail,
    this.usuarioFotoUrl,
    required this.itens,
  });

  CompraDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataHora = DateTime.parse(json['dataHora'] as String);
    total = json['total'];
    usuarioId = json['usuarioId'];
    usuarioNome = json['usuarioNome'];
    usuarioEmail = json['usuarioEmail'];
    usuarioFotoUrl = json['usuarioFotoUrl'];
    itens = List<CompraItemDto>.from(json["itens"].map((x) => CompraItemDto.fromJson(x)));
  }
}

class CompraDetalheDto {
  late final int id;
  late final DateTime dataHora;
  late final double total;
  late final String usuarioId;
  late final String usuarioNome;
  late final String usuarioEmail;
  late final String? usuarioFotoUrl;
  late final List<CompraDetalheItemDto> itens;

  CompraDetalheDto({
    required this.id,
    required this.dataHora,
    required this.total,
    required this.usuarioId,
    required this.usuarioNome,
    required this.usuarioEmail,
    this.usuarioFotoUrl,
  });

  CompraDetalheDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataHora = DateTime.parse(json['dataHora'] as String);
    total = json['total'];
    usuarioId = json['usuarioId'];
    usuarioNome = json['usuarioNome'];
    usuarioEmail = json['usuarioEmail'];
    usuarioFotoUrl = json['usuarioFotoUrl'];
    itens = List<CompraDetalheItemDto>.from(json["itens"].map((x) => CompraDetalheItemDto.fromJson(x)));
  }
}

class CompraDetalheItemDto {
  CompraDetalheItemDto({
    required this.produtoId,
    required this.nome,
    required this.descricao,
    required this.imageUrl,
    required this.precoPago,
    required this.precoSugerido,
    required this.isPrecoMedioSugerido,
    required this.quantidade,
    required this.unidadeMedida,
  });
  late final String produtoId;
  late final String nome;
  late final String descricao;
  late final String imageUrl;
  late final double precoPago;
  late final double precoSugerido;
  late final bool isPrecoMedioSugerido;
  late final num quantidade;
  late final String unidadeMedida;

  CompraDetalheItemDto.fromJson(Map<String, dynamic> json) {
    produtoId = json['produtoId'];
    nome = json['nome'];
    descricao = json['descricao'];
    imageUrl = json['imageUrl'];
    precoPago = json['precoPago'];
    precoSugerido = json['precoSugerido'];
    isPrecoMedioSugerido = json['isPrecoMedioSugerido'];
    quantidade = json['quantidade'];
    unidadeMedida = json['unidadeMedida'];
  }
}
