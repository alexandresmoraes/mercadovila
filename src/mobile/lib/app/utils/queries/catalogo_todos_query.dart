class CatalogoTodosQuery {
  CatalogoTodosQuery({
    required this.page,
    required this.limit,
    required this.order,
    required this.inStock,
    required this.outOfStock,
    this.nome,
  });
  late final int page;
  late final int limit;
  late final int order;
  late final bool inStock;
  late final bool outOfStock;
  late final String? nome;

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'limit': limit,
      'order': order,
      'inStock': inStock,
      'outOfStock': outOfStock,
      'nome': nome,
    };
  }
}
