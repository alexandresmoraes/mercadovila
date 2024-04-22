import 'package:dio/io.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/rating/rating_item.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_rating_repository.dart';

@Injectable()
class RatingRepository implements IRatingRepository {
  late final DioForNative dio;

  RatingRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future adicionarRating(String vendaId, String produtoId, int rating) async {
    await dio.post('/api/rating/$vendaId/$produtoId/$rating');
  }

  @override
  Future<RatingItem> getRating(String vendaId, String produtoId) async {
    var response = await dio.get('/api/rating/$vendaId/$produtoId');

    return RatingItem.fromJson(response.data);
  }
}
