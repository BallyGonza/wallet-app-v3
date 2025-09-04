import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/account/domain/repositories/account_repository.dart';

class DeleteAccount implements UseCase<void, DeleteAccountParams> {
  const DeleteAccount(this.repository);

  final AccountRepository repository;

  @override
  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    return await repository.deleteAccount(params.accountId);
  }
}

class DeleteAccountParams {
  const DeleteAccountParams({required this.accountId});

  final int accountId;
}
