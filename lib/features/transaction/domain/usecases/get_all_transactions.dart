import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:template_app/features/transaction/domain/repositories/transaction_repository.dart';

class GetAllTransactions implements UseCase<List<TransactionEntity>, GetAllTransactionsParams> {
  const GetAllTransactions(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(GetAllTransactionsParams params) async {
    return await repository.getAllTransactions(
      userId: params.userId,
      accountId: params.accountId,
      categoryId: params.categoryId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetAllTransactionsParams {
  const GetAllTransactionsParams({
    this.userId,
    this.accountId,
    this.categoryId,
    this.startDate,
    this.endDate,
  });

  final int? userId;
  final int? accountId;
  final int? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;
}
