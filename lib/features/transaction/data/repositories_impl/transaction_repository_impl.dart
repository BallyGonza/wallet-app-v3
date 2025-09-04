import 'package:template_app/core/errors/exceptions.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:template_app/features/transaction/data/models/transaction_model.dart';
import 'package:template_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:template_app/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  const TransactionRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions({
    int? userId,
    int? accountId,
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final transactions = await localDataSource.getAllTransactions(
        userId: userId,
        accountId: accountId,
        categoryId: categoryId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(transactions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity?>> getTransactionById(int id) async {
    try {
      final transaction = await localDataSource.getTransactionById(id);
      return Right(transaction);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> saveTransaction(TransactionEntity transaction) async {
    try {
      // Validate transaction
      if (transaction.amount <= 0) {
        return Left(ValidationFailure('Transaction amount must be greater than 0'));
      }
      
      if (transaction.accountId <= 0) {
        return Left(ValidationFailure('Valid account ID is required'));
      }
      
      if (transaction.categoryId <= 0) {
        return Left(ValidationFailure('Valid category ID is required'));
      }

      final transactionModel = TransactionModel.fromEntity(transaction);
      final savedTransaction = await localDataSource.saveTransaction(transactionModel);
      return Right(savedTransaction);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(int id) async {
    try {
      if (id <= 0) {
        return Left(ValidationFailure('Valid transaction ID is required'));
      }

      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getTransactionSummary({
    int? userId,
    int? accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final summary = await localDataSource.getTransactionSummary(
        userId: userId,
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(summary);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByType(
    TransactionType type, {
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final transactions = await localDataSource.getAllTransactions(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      final filteredTransactions = transactions
          .where((transaction) => transaction.type == type)
          .toList();
      
      return Right(filteredTransactions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByAccount(
    int accountId, {
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (accountId <= 0) {
        return Left(ValidationFailure('Valid account ID is required'));
      }

      final transactions = await localDataSource.getAllTransactions(
        userId: userId,
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      );
      
      return Right(transactions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByCategory(
    int categoryId, {
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (categoryId <= 0) {
        return Left(ValidationFailure('Valid category ID is required'));
      }

      final transactions = await localDataSource.getAllTransactions(
        userId: userId,
        categoryId: categoryId,
        startDate: startDate,
        endDate: endDate,
      );
      
      return Right(transactions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  Future<Either<Failure, double>> getTotalByType(
    TransactionType type, {
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final summary = await localDataSource.getTransactionSummary(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      double total = 0.0;
      switch (type) {
        case TransactionType.income:
          total = summary['income'] ?? 0.0;
          break;
        case TransactionType.expense:
          total = summary['expense'] ?? 0.0;
          break;
        case TransactionType.transfer:
          // For transfers, we might want to handle differently
          total = 0.0;
          break;
      }
      
      return Right(total);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalIncome({
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final summary = await localDataSource.getTransactionSummary(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(summary['income'] ?? 0.0);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpenses({
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final summary = await localDataSource.getTransactionSummary(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(summary['expense'] ?? 0.0);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> getNetIncome({
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final summary = await localDataSource.getTransactionSummary(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(summary['net'] ?? 0.0);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getCurrentMonthTransactions({int? userId}) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      
      final transactions = await localDataSource.getAllTransactions(
        userId: userId,
        startDate: startOfMonth,
        endDate: endOfMonth,
      );
      
      return Right(transactions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getRecentTransactions({
    int? userId,
    int limit = 10,
  }) async {
    try {
      final transactions = await localDataSource.getAllTransactions(userId: userId);
      final recentTransactions = transactions.take(limit).toList();
      return Right(recentTransactions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
