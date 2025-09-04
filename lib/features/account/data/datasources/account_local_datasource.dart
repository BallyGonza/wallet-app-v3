import 'package:template_app/core/errors/exceptions.dart';
import 'package:template_app/features/account/data/models/account_model.dart';
import 'package:template_app/services/database_service.dart';

abstract class AccountLocalDataSource {
  Future<List<AccountModel>> getAllAccounts({int? userId});
  Future<AccountModel?> getAccountById(int id);
  Future<AccountModel> saveAccount(AccountModel account);
  Future<void> deleteAccount(int id);
  Future<List<AccountModel>> getAccountsByType(String type, {int? userId});
  Future<List<AccountModel>> getActiveAccounts({int? userId});
  Future<double> getTotalBalance({int? userId});
  Future<List<AccountModel>> getAccountsWithBalance({int? userId});
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  const AccountLocalDataSourceImpl();

  @override
  Future<List<AccountModel>> getAllAccounts({int? userId}) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = userId != null
          ? await db.query('accounts', where: 'user_id = ?', whereArgs: [userId])
          : await db.query('accounts');
      return maps.map((map) => AccountModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get all accounts: ${e.toString()}');
    }
  }

  @override
  Future<AccountModel?> getAccountById(int id) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'accounts',
        where: 'id = ?',
        whereArgs: [id],
      );
      return maps.isNotEmpty ? AccountModel.fromMap(maps.first) : null;
    } catch (e) {
      throw DatabaseException('Failed to get account by id: ${e.toString()}');
    }
  }

  @override
  Future<AccountModel> saveAccount(AccountModel account) async {
    try {
      final db = await DatabaseService.database;
      final now = DateTime.now();
      
      if (account.id == null) {
        // Insert new account
        final accountWithTimestamp = account.copyWith(
          createdAt: now,
          updatedAt: now,
        );
        final accountId = await db.insert('accounts', accountWithTimestamp.toMap());
        return accountWithTimestamp.copyWith(id: accountId);
      } else {
        // Update existing account
        final updatedAccount = account.copyWith(updatedAt: now);
        await db.update(
          'accounts',
          updatedAccount.toMap(),
          where: 'id = ?',
          whereArgs: [updatedAccount.id],
        );
        return updatedAccount;
      }
    } catch (e) {
      throw DatabaseException('Failed to save account: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount(int id) async {
    try {
      await DatabaseService.deleteAccount(id);
    } catch (e) {
      throw DatabaseException('Failed to delete account: ${e.toString()}');
    }
  }

  @override
  Future<List<AccountModel>> getAccountsByType(String type, {int? userId}) async {
    try {
      final allAccounts = await getAllAccounts(userId: userId);
      return allAccounts.where((account) => account.type.name == type).toList();
    } catch (e) {
      throw DatabaseException('Failed to get accounts by type: ${e.toString()}');
    }
  }

  @override
  Future<List<AccountModel>> getActiveAccounts({int? userId}) async {
    try {
      final allAccounts = await getAllAccounts(userId: userId);
      return allAccounts.where((account) => account.isActive).toList();
    } catch (e) {
      throw DatabaseException('Failed to get active accounts: ${e.toString()}');
    }
  }

  @override
  Future<double> getTotalBalance({int? userId}) async {
    try {
      final accounts = await getActiveAccounts(userId: userId);
      return accounts.fold<double>(0.0, (sum, account) => sum + account.balance);
    } catch (e) {
      throw DatabaseException('Failed to get total balance: ${e.toString()}');
    }
  }

  @override
  Future<List<AccountModel>> getAccountsWithBalance({int? userId}) async {
    try {
      final accounts = await getActiveAccounts(userId: userId);
      return accounts.where((account) => account.balance > 0).toList();
    } catch (e) {
      throw DatabaseException('Failed to get accounts with balance: ${e.toString()}');
    }
  }
}
