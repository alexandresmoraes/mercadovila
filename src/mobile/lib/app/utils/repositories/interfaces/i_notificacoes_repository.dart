import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/utils/dto/notificacoes/notificacao_dto.dart';
import 'package:mercadovila/app/utils/models/notificacoes/notificacao_model.dart';
import 'package:mercadovila/app/utils/models/paged_result.dart';
import 'package:mercadovila/app/utils/models/produtos/image_upload_response_model.dart';
import 'package:mercadovila/app/utils/models/result_fail_model.dart';

abstract class INotificacoesRepository implements Disposable {
  Future<NotificacaoModel> getNotificacao(String id);
  Future<Either<ResultFailModel, NotificacaoResponseModel>> createNotificacao(NotificacaoModel notificacaoModel);
  Future<Either<ResultFailModel, String>> editNotificacao(String id, NotificacaoModel notificacaoModel);
  Future<PagedResult<NotificacaoDto>> getNotificacoes(int page);
  Future<Either<ResultFailModel, ImageUploadResponseModel>> uploadImageNotificacao(String filepath, String? mimeType, String? filenameWeb);
  Future<Either<ResultFailModel, String>> deleteNotificacao(String id);
}
