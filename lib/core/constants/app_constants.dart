class AppConstants {
  // Database
  static const String databaseName = 'wallet_app.db';
  static const int databaseVersion = 1;
  
  // Table names
  static const String usersTable = 'users';
  static const String accountsTable = 'accounts';
  static const String categoriesTable = 'categories';
  static const String subcategoriesTable = 'subcategories';
  static const String transactionsTable = 'transactions';
  
  // App info
  static const String appName = 'Wallet App';
  static const String appVersion = '1.0.0';
  
  // Default values
  static const String defaultCurrency = 'USD';
  static const double defaultBalance = 0.0;
  
  // Limits
  static const int maxTransactionLimit = 10;
  static const int maxAccountNameLength = 50;
  static const int maxCategoryNameLength = 30;
  
  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
}
