import 'package:dio/io.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mercadovila/app/utils/dto/notificacoes/notificacao_dto.dart';
import 'package:mercadovila/app/utils/models/notificacoes/notificacao_model.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';
import 'package:mercadovila/app/utils/models/produtos/image_upload_response_model.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_notificacoes_repository.dart';

@Injectable()
class NotificacoesRepository implements INotificacoesRepository {
  late final DioForNative dio;

  NotificacoesRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<Either<ResultFailModel, NotificacaoResponseModel>> createNotificacao(NotificacaoModel notificacaoModel) async {
    try {
      var response = await dio.post('/api/notificacoes', data: notificacaoModel.toJson());
      var result = NotificacaoResponseModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<Either<ResultFailModel, String>> editNotificacao(String id, NotificacaoModel notificacaoModel) async {
    try {
      await dio.put('/api/notificacoes/$id', data: notificacaoModel.toJson());
      return Right(id);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<NotificacaoModel> getNotificacao(String id) async {
    var response = await dio.get('/api/notificacoes/$id');

    return NotificacaoModel.fromJson(response.data);
  }

  @override
  Future<PagedResult<NotificacaoDto>> getNotificacoes(int page) async {
    var response = await dio.get('/api/notificacoes', queryParameters: {
      "page": page.toString(),
      "limit": 10,
    });

    return PagedResult.fromJson(response.data);
  }

  @override
  Future<Either<ResultFailModel, ImageUploadResponseModel>> uploadImageNotificacao(String filepath, String? mimeType, String? filenameWeb) async {
    try {
      String filename = filepath.split('/').last;

      FormData formData;
      if (kIsWeb) {
        var file = XFile(filepath);
        var content = await file.readAsBytes();
        MediaType mediaType = MediaType.parse(mimeType!);
        formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(
            content,
            contentType: mediaType,
            filename: filenameWeb,
          ),
        });
      } else {
        var multipartFile = await MultipartFile.fromFile(filepath, filename: filename);
        formData = FormData.fromMap({
          "file": multipartFile,
        });
      }

      var response = await dio.post('/api/notificacoes/image', data: formData);
      var result = ImageUploadResponseModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (err) {
      if (err.response?.statusCode == 413) {
        return Left(ResultFailModel.fromJson(null, err.response?.statusCode));
      } else {
        return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
      }
    }
  }

  @override
  Future<Either<ResultFailModel, String>> deleteNotificacao(String id) async {
    try {
      await dio.delete('/api/notificacoes/$id');
      return Right(id);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }
}
