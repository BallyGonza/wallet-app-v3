import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/account/domain/entities/account_entity.dart';
import 'package:template_app/features/account/domain/repositories/account_repository.dart';

class SaveAccount implements UseCase<AccountEntity, SaveAccountParams> {
  const SaveAccount(this.repository);

  final AccountRepository repository;

  @override
  Future<Either<Failure, AccountEntity>> call(SaveAccountParams params) async {
    return await repository.saveAccount(params.account);
  }
}

class SaveAccountParams {
  const SaveAccountParams({required this.account});

  final AccountEntity account;
}
