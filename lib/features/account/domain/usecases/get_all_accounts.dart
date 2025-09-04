import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/account/domain/entities/account_entity.dart';
import 'package:template_app/features/account/domain/repositories/account_repository.dart';

class GetAllAccounts implements UseCase<List<AccountEntity>, GetAllAccountsParams> {
  const GetAllAccounts(this.repository);

  final AccountRepository repository;

  @override
  Future<Either<Failure, List<AccountEntity>>> call(GetAllAccountsParams params) async {
    return await repository.getAllAccounts(userId: params.userId);
  }
}

class GetAllAccountsParams {
  const GetAllAccountsParams({this.userId});

  final int? userId;
}
