import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:template_app/features/transaction/domain/repositories/transaction_repository.dart';

class SaveTransaction implements UseCase<TransactionEntity, SaveTransactionParams> {
  const SaveTransaction(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, TransactionEntity>> call(SaveTransactionParams params) async {
    return await repository.saveTransaction(params.transaction);
  }
}

class SaveTransactionParams {
  const SaveTransactionParams({required this.transaction});

  final TransactionEntity transaction;
}
