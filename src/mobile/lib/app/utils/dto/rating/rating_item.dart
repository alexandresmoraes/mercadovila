class RatingItem {
  RatingItem({
    required this.vendaId,
    required this.produtoId,
    required this.rating,
  });
  late final int vendaId;
  late final String produtoId;
  late final int rating;

  RatingItem.fromJson(Map<String, dynamic> json) {
    vendaId = json['vendaId'];
    produtoId = json['produtoId'];
    rating = json['rating'];
  }
}
