enum EnumVendaStatus {
  pendentePagamento,
  pago,
  cancelada,
}

class VendaDto {
  VendaDto({
    required this.id,
    required this.status,
    required this.dataHora,
    required this.total,
    required this.compradorNome,
    this.compradorFotoUrl,
  });
  late final int id;
  late final int status;
  late final DateTime dataHora;
  late final num total;
  late final String compradorNome;
  late final String? compradorFotoUrl;
  late final List<VendaItemDto> itens;

  VendaDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    dataHora = DateTime.parse(json['dataHora'] as String);
    total = json['total'];
    compradorNome = json['compradorNome'];
    compradorFotoUrl = json['compradorFotoUrl'];
    itens = List<VendaItemDto>.from(json["itens"].map((x) => VendaItemDto.fromJson(x)));
  }
}

class VendaItemDto {
  VendaItemDto({
    required this.produtoId,
    required this.nome,
    required this.imageUrl,
    required this.preco,
    required this.quantidade,
    required this.unidadeMedida,
  });
  late final String produtoId;
  late final String nome;
  late final String imageUrl;
  late final num preco;
  late final num quantidade;
  late final String unidadeMedida;

  VendaItemDto.fromJson(Map<String, dynamic> json) {
    produtoId = json['produtoId'];
    nome = json['nome'];
    imageUrl = json['imageUrl'];
    preco = json['preco'];
    quantidade = json['quantidade'];
    unidadeMedida = json['unidadeMedida'];
  }
}

class VendaDetalheDto {
  VendaDetalheDto({
    required this.id,
    required this.status,
    required this.dataHora,
    required this.total,
    required this.compradorUserId,
  });
  late final int id;
  late final int status;
  late final DateTime dataHora;
  late final num total;
  late final String compradorUserId;
  late final List<VendaDetalheItemDto> itens;

  VendaDetalheDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    dataHora = DateTime.parse(json['dataHora'] as String);
    total = json['total'];
    compradorUserId = json['compradorUserId'];
    itens = List<VendaDetalheItemDto>.from(json["itens"].map((x) => VendaDetalheItemDto.fromJson(x)));
  }
}

class VendaDetalheItemDto {
  VendaDetalheItemDto({
    required this.produtoId,
    required this.nome,
    required this.descricao,
    required this.imageUrl,
    required this.preco,
    required this.quantidade,
    required this.unidadeMedida,
  });
  late final String produtoId;
  late final String nome;
  late final String descricao;
  late final String imageUrl;
  late final num preco;
  late final num quantidade;
  late final String unidadeMedida;

  VendaDetalheItemDto.fromJson(Map<String, dynamic> json) {
    produtoId = json['produtoId'];
    nome = json['nome'];
    descricao = json['descricao'];
    imageUrl = json['imageUrl'];
    preco = json['preco'];
    quantidade = json['quantidade'];
    unidadeMedida = json['unidadeMedida'];
  }
}
