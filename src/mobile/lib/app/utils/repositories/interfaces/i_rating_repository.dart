import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/dto/rating/rating_item.dart';

abstract class IRatingRepository implements Disposable {
  Future adicionarRating(String vendaId, String produtoId, int rating);
  Future<RatingItem> getRating(String vendaId, String produtoId);
}
