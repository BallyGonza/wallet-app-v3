import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:template_app/data/models/user/user_model.dart';
import 'package:template_app/data/models/account/account_model.dart';
import 'package:template_app/data/models/category/category_model.dart';
import 'package:template_app/data/models/subcategory/subcategory_model.dart';
import 'package:template_app/data/models/transaction/transaction_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'wallet_app.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _usersTable = 'users';
  static const String _accountsTable = 'accounts';
  static const String _categoriesTable = 'categories';
  static const String _subcategoriesTable = 'subcategories';
  static const String _transactionsTable = 'transactions';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE $_usersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');

    // Accounts table
    await db.execute('''
      CREATE TABLE $_accountsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        balance REAL NOT NULL DEFAULT 0.0,
        currency TEXT NOT NULL DEFAULT 'USD',
        description TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        user_id INTEGER,
        created_at INTEGER,
        updated_at INTEGER,
        FOREIGN KEY (user_id) REFERENCES $_usersTable (id) ON DELETE CASCADE
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE $_categoriesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        icon TEXT,
        color TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        user_id INTEGER,
        created_at INTEGER,
        updated_at INTEGER,
        FOREIGN KEY (user_id) REFERENCES $_usersTable (id) ON DELETE CASCADE
      )
    ''');

    // Subcategories table
    await db.execute('''
      CREATE TABLE $_subcategoriesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        icon TEXT,
        color TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER,
        updated_at INTEGER,
        FOREIGN KEY (category_id) REFERENCES $_categoriesTable (id) ON DELETE CASCADE
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE $_transactionsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        account_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        subcategory_id INTEGER,
        to_account_id INTEGER,
        description TEXT,
        notes TEXT,
        date INTEGER NOT NULL,
        user_id INTEGER,
        created_at INTEGER,
        updated_at INTEGER,
        FOREIGN KEY (account_id) REFERENCES $_accountsTable (id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES $_categoriesTable (id) ON DELETE CASCADE,
        FOREIGN KEY (subcategory_id) REFERENCES $_subcategoriesTable (id) ON DELETE SET NULL,
        FOREIGN KEY (to_account_id) REFERENCES $_accountsTable (id) ON DELETE SET NULL,
        FOREIGN KEY (user_id) REFERENCES $_usersTable (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_transactions_date ON $_transactionsTable (date)');
    await db.execute('CREATE INDEX idx_transactions_account ON $_transactionsTable (account_id)');
    await db.execute('CREATE INDEX idx_transactions_category ON $_transactionsTable (category_id)');
    await db.execute('CREATE INDEX idx_accounts_user ON $_accountsTable (user_id)');
    await db.execute('CREATE INDEX idx_categories_user ON $_categoriesTable (user_id)');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic here when needed
    }
  }

  // User operations
  static Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(_usersTable, user.toMap());
  }

  static Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_usersTable);
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  static Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      _usersTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      _usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Account operations
  static Future<int> insertAccount(AccountModel account) async {
    final db = await database;
    return await db.insert(_accountsTable, account.toMap());
  }

  static Future<List<AccountModel>> getAllAccounts({int? userId}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = userId != null
        ? await db.query(_accountsTable, where: 'user_id = ?', whereArgs: [userId])
        : await db.query(_accountsTable);
    return List.generate(maps.length, (i) {
      return AccountModel.fromMap(maps[i]);
    });
  }

  static Future<AccountModel?> getAccountById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _accountsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return AccountModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> updateAccount(AccountModel account) async {
    final db = await database;
    return await db.update(
      _accountsTable,
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  static Future<int> deleteAccount(int id) async {
    final db = await database;
    return await db.delete(
      _accountsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Category operations
  static Future<int> insertCategory(CategoryModel category) async {
    final db = await database;
    return await db.insert(_categoriesTable, category.toMap());
  }

  static Future<List<CategoryModel>> getAllCategories({int? userId}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = userId != null
        ? await db.query(_categoriesTable, where: 'user_id = ?', whereArgs: [userId])
        : await db.query(_categoriesTable);
    return List.generate(maps.length, (i) {
      return CategoryModel.fromMap(maps[i]);
    });
  }

  static Future<CategoryModel?> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _categoriesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return CategoryModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> updateCategory(CategoryModel category) async {
    final db = await database;
    return await db.update(
      _categoriesTable,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  static Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      _categoriesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Subcategory operations
  static Future<int> insertSubcategory(SubcategoryModel subcategory) async {
    final db = await database;
    return await db.insert(_subcategoriesTable, subcategory.toMap());
  }

  static Future<List<SubcategoryModel>> getSubcategoriesByCategory(int categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _subcategoriesTable,
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return List.generate(maps.length, (i) {
      return SubcategoryModel.fromMap(maps[i]);
    });
  }

  static Future<SubcategoryModel?> getSubcategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _subcategoriesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return SubcategoryModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> updateSubcategory(SubcategoryModel subcategory) async {
    final db = await database;
    return await db.update(
      _subcategoriesTable,
      subcategory.toMap(),
      where: 'id = ?',
      whereArgs: [subcategory.id],
    );
  }

  static Future<int> deleteSubcategory(int id) async {
    final db = await database;
    return await db.delete(
      _subcategoriesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Transaction operations
  static Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    final transactionId = await db.insert(_transactionsTable, transaction.toMap());
    
    // Update account balance
    await _updateAccountBalance(transaction.accountId, transaction.amount, transaction.type);
    
    // If it's a transfer, update the destination account balance
    if (transaction.isTransfer && transaction.toAccountId != null) {
      await _updateAccountBalance(transaction.toAccountId!, transaction.amount, TransactionType.income);
    }
    
    return transactionId;
  }

  static Future<List<TransactionModel>> getAllTransactions({
    int? userId,
    int? accountId,
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
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
      _transactionsTable,
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  static Future<TransactionModel?> getTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _transactionsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TransactionModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    
    // Get the old transaction to reverse its balance effect
    final oldTransaction = await getTransactionById(transaction.id!);
    if (oldTransaction != null) {
      // Reverse old transaction balance effect
      await _updateAccountBalance(
        oldTransaction.accountId, 
        -oldTransaction.amount, 
        oldTransaction.type,
      );
      
      if (oldTransaction.isTransfer && oldTransaction.toAccountId != null) {
        await _updateAccountBalance(
          oldTransaction.toAccountId!, 
          -oldTransaction.amount, 
          TransactionType.income,
        );
      }
    }
    
    // Apply new transaction balance effect
    await _updateAccountBalance(transaction.accountId, transaction.amount, transaction.type);
    
    if (transaction.isTransfer && transaction.toAccountId != null) {
      await _updateAccountBalance(transaction.toAccountId!, transaction.amount, TransactionType.income);
    }
    
    return await db.update(
      _transactionsTable,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  static Future<int> deleteTransaction(int id) async {
    final db = await database;
    
    // Get the transaction to reverse its balance effect
    final transaction = await getTransactionById(id);
    if (transaction != null) {
      await _updateAccountBalance(
        transaction.accountId, 
        -transaction.amount, 
        transaction.type,
      );
      
      if (transaction.isTransfer && transaction.toAccountId != null) {
        await _updateAccountBalance(
          transaction.toAccountId!, 
          -transaction.amount, 
          TransactionType.income,
        );
      }
    }
    
    return await db.delete(
      _transactionsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Helper method to update account balance
  static Future<void> _updateAccountBalance(int accountId, double amount, TransactionType type) async {
    final account = await getAccountById(accountId);
    if (account != null) {
      double newBalance = account.balance;
      
      switch (type) {
        case TransactionType.income:
          newBalance += amount;
          break;
        case TransactionType.expense:
          newBalance -= amount;
          break;
        case TransactionType.transfer:
          newBalance -= amount; // Transfer out reduces balance
          break;
      }
      
      final updatedAccount = account.copyWith(
        balance: newBalance,
        updatedAt: DateTime.now(),
      );
      
      await updateAccount(updatedAccount);
    }
  }

  // Utility methods
  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Initialize the database (call this in main.dart)
  static Future<void> initialize() async {
    await database;
  }
}
