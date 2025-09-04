import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionSummary implements UseCase<TransactionSummary, GetTransactionSummaryParams> {
  const GetTransactionSummary(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, TransactionSummary>> call(GetTransactionSummaryParams params) async {
    final incomeResult = await repository.getTotalIncome(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
    
    final expensesResult = await repository.getTotalExpenses(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
    
    final netIncomeResult = await repository.getNetIncome(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
    );

    if (incomeResult.isLeft) return Left(incomeResult.left);
    if (expensesResult.isLeft) return Left(expensesResult.left);
    if (netIncomeResult.isLeft) return Left(netIncomeResult.left);

    return Right(TransactionSummary(
      totalIncome: incomeResult.right,
      totalExpenses: expensesResult.right,
      netIncome: netIncomeResult.right,
    ));
  }
}

class GetTransactionSummaryParams {
  const GetTransactionSummaryParams({
    this.userId,
    this.startDate,
    this.endDate,
  });

  final int? userId;
  final DateTime? startDate;
  final DateTime? endDate;
}

class TransactionSummary {
  const TransactionSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.netIncome,
  });

  final double totalIncome;
  final double totalExpenses;
  final double netIncome;
}
