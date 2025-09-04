import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions({
    int? userId,
    int? accountId,
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, TransactionEntity?>> getTransactionById(int id);
  Future<Either<Failure, TransactionEntity>> saveTransaction(TransactionEntity transaction);
  Future<Either<Failure, void>> deleteTransaction(int id);
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByType(
    TransactionType type, {
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, double>> getTotalIncome({
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, double>> getTotalExpenses({
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, double>> getNetIncome({
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, List<TransactionEntity>>> getCurrentMonthTransactions({int? userId});
  Future<Either<Failure, List<TransactionEntity>>> getRecentTransactions({
    int? userId,
    int limit = 10,
  });
}
