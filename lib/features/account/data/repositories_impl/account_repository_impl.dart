import 'package:template_app/core/errors/exceptions.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/features/account/data/datasources/account_local_datasource.dart';
import 'package:template_app/features/account/data/models/account_model.dart';
import 'package:template_app/features/account/domain/entities/account_entity.dart';
import 'package:template_app/features/account/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  const AccountRepositoryImpl({
    required this.localDataSource,
  });

  final AccountLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<AccountEntity>>> getAllAccounts({int? userId}) async {
    try {
      final accounts = await localDataSource.getAllAccounts(userId: userId);
      return Right(accounts);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AccountEntity?>> getAccountById(int id) async {
    try {
      final account = await localDataSource.getAccountById(id);
      return Right(account);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> saveAccount(AccountEntity account) async {
    try {
      final accountModel = AccountModel.fromEntity(account);
      final savedAccount = await localDataSource.saveAccount(accountModel);
      return Right(savedAccount);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(int id) async {
    try {
      await localDataSource.deleteAccount(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AccountEntity>>> getAccountsByType(
    AccountType type, {
    int? userId,
  }) async {
    try {
      final accounts = await localDataSource.getAccountsByType(type.name, userId: userId);
      return Right(accounts);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AccountEntity>>> getActiveAccounts({int? userId}) async {
    try {
      final accounts = await localDataSource.getActiveAccounts(userId: userId);
      return Right(accounts);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalBalance({int? userId}) async {
    try {
      final balance = await localDataSource.getTotalBalance(userId: userId);
      return Right(balance);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AccountEntity>>> getAccountsWithBalance({int? userId}) async {
    try {
      final accounts = await localDataSource.getAccountsWithBalance(userId: userId);
      return Right(accounts);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
