import 'package:template_app/core/errors/exceptions.dart';
import 'package:template_app/features/transaction/data/models/transaction_model.dart';
import 'package:template_app/services/database_service.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions({
    int? userId,
    int? accountId,
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<TransactionModel?> getTransactionById(int id);
  Future<TransactionModel> saveTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(int id);
  Future<Map<String, double>> getTransactionSummary({
    int? userId,
    int? accountId,
    DateTime? startDate,
    DateTime? endDate,
  });
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  const TransactionLocalDataSourceImpl();

  @override
  Future<List<TransactionModel>> getAllTransactions({
    int? userId,
    int? accountId,
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final db = await DatabaseService.database;
      
      String whereClause = '';
      List<dynamic> whereArgs = [];
      
      if (userId != null) {
        whereClause += 'user_id = ?';
        whereArgs.add(userId);
      }
      
      if (accountId != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'account_id = ?';
        whereArgs.add(accountId);
      }
      
      if (categoryId != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'category_id = ?';
        whereArgs.add(categoryId);
      }
      
      if (startDate != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'date >= ?';
        whereArgs.add(startDate.millisecondsSinceEpoch);
      }
      
      if (endDate != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'date <= ?';
        whereArgs.add(endDate.millisecondsSinceEpoch);
      }
      
      final List<Map<String, dynamic>> maps = await db.query(
        'transactions',
        where: whereClause.isNotEmpty ? whereClause : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        orderBy: 'date DESC',
      );
      
      return maps.map((map) => TransactionModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get transactions: ${e.toString()}');
    }
  }

  @override
  Future<TransactionModel?> getTransactionById(int id) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );
      return maps.isNotEmpty ? TransactionModel.fromMap(maps.first) : null;
    } catch (e) {
      throw DatabaseException('Failed to get transaction by id: ${e.toString()}');
    }
  }

  @override
  Future<TransactionModel> saveTransaction(TransactionModel transaction) async {
    try {
      final db = await DatabaseService.database;
      final now = DateTime.now();
      
      if (transaction.id == null) {
        // Insert new transaction
        final transactionWithTimestamp = transaction.copyWith(
          createdAt: now,
          updatedAt: now,
        );
        final transactionId = await db.insert('transactions', transactionWithTimestamp.toMap());
        return transactionWithTimestamp.copyWith(id: transactionId);
      } else {
        // Update existing transaction
        final updatedTransaction = transaction.copyWith(updatedAt: now);
        await db.update(
          'transactions',
          updatedTransaction.toMap(),
          where: 'id = ?',
          whereArgs: [updatedTransaction.id],
        );
        return updatedTransaction;
      }
    } catch (e) {
      throw DatabaseException('Failed to save transaction: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    try {
      final db = await DatabaseService.database;
      await db.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete transaction: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, double>> getTransactionSummary({
    int? userId,
    int? accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final db = await DatabaseService.database;
      
      String whereClause = '';
      List<dynamic> whereArgs = [];
      
      if (userId != null) {
        whereClause += 'user_id = ?';
        whereArgs.add(userId);
      }
      
      if (accountId != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'account_id = ?';
        whereArgs.add(accountId);
      }
      
      if (startDate != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'date >= ?';
        whereArgs.add(startDate.millisecondsSinceEpoch);
      }
      
      if (endDate != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'date <= ?';
        whereArgs.add(endDate.millisecondsSinceEpoch);
      }
      
      final List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT 
          type,
          SUM(amount) as total
        FROM transactions
        ${whereClause.isNotEmpty ? 'WHERE $whereClause' : ''}
        GROUP BY type
      ''', whereArgs);
      
      double income = 0.0;
      double expense = 0.0;
      
      for (final row in result) {
        final type = row['type'] as String;
        final total = (row['total'] as num?)?.toDouble() ?? 0.0;
        
        if (type == 'income') {
          income = total;
        } else if (type == 'expense') {
          expense = total;
        }
      }
      
      return {
        'income': income,
        'expense': expense,
        'net': income - expense,
      };
    } catch (e) {
      throw DatabaseException('Failed to get transaction summary: ${e.toString()}');
    }
  }
}
