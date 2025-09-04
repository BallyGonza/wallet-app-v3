import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/account/domain/entities/account_entity.dart';

abstract class AccountRepository {
  Future<Either<Failure, List<AccountEntity>>> getAllAccounts({int? userId});
  Future<Either<Failure, AccountEntity?>> getAccountById(int id);
  Future<Either<Failure, AccountEntity>> saveAccount(AccountEntity account);
  Future<Either<Failure, void>> deleteAccount(int id);
  Future<Either<Failure, List<AccountEntity>>> getAccountsByType(AccountType type, {int? userId});
  Future<Either<Failure, List<AccountEntity>>> getActiveAccounts({int? userId});
  Future<Either<Failure, double>> getTotalBalance({int? userId});
  Future<Either<Failure, List<AccountEntity>>> getAccountsWithBalance({int? userId});
}
