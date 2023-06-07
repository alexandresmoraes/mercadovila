import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/utils/models/account/new_and_update_account_model.dart';
import 'package:vilasesmo/app/utils/models/account_model.dart';
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
    } on DioError catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }

  @override
  Future<Either<ResultFailModel, String>> updateAccount(String id, NewAndUpdateAccountModel updateAccountModel) async {
    try {
      await dio.put('/api/account/$id');
      return Right(id);
    } on DioError catch (err) {
      return Left(ResultFailModel.fromJson(err.response?.data, err.response?.statusCode));
    }
  }
}
