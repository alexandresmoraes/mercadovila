import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vilasesmo/app/utils/dto/account/account_dto.dart';
import 'package:vilasesmo/app/utils/models/account/new_and_update_account_model.dart';
import 'package:vilasesmo/app/utils/models/account/photo_upload_response_model.dart';
import 'package:vilasesmo/app/utils/models/account_model.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_account_repository.dart';

@Injectable()
class AccountRepository implements IAccountRepository {
  late final DioForNative dio;

  AccountRepository() {
    dio = Modular.get<DioForNative>();
  }

  @override
  void dispose() {}

  @override
  Future<AccountModel> getAccount(String id) async {
    var response = await dio.get('/api/account/$id');

    return AccountModel.fromJson(response.data);
  }

  @override
  Future<Either<ResultFailModel, NewAccountResponseModel>> newAccount(NewAndUpdateAccountModel newAccountModel) async {
    try {
      var response = await dio.post('/api/account', data: newAccountModel.toJson());
      var result = NewAccountResponseModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<Either<ResultFailModel, String>> updateAccount(String id, NewAndUpdateAccountModel updateAccountModel) async {
    try {
      await dio.put('/api/account/$id', data: updateAccountModel.toJson());
      return Right(id);
    } on DioException catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<PagedResult<AccountDto>> getAccounts(int page, String? usernameOrEmail) async {
    var response = await dio.get('/api/account', queryParameters: {
      "page": page.toString(),
      "limit": 5,
      "username": usernameOrEmail,
    });

    return PagedResult.fromJson(response.data);
  }

  @override
  Future<Either<ResultFailModel, PhotoUploadResponseModel>> uploadPhotoAccount(
      String id, String filepath, String? mimeType, String? filenameWeb) async {
    try {
      String filename = filepath.split('/').last;

      FormData formData;
      if (kIsWeb) {
        var file = XFile(filepath);
        var content = await file.readAsBytes();
        var mediaType = MediaType.parse(mimeType!);
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

      var response = await dio.post('/api/account/photo/$id', data: formData);
      var result = PhotoUploadResponseModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (err) {
      if (err.response?.statusCode == 413) {
        return Left(ResultFailModel.fromJson(null, err.response?.statusCode));
      } else {
        return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
      }
    }
  }
}
