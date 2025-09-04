class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class DatabaseException implements Exception {
  const DatabaseException(this.message);
  
  final String message;
  
  @override
  String toString() => 'DatabaseException: $message';
}

class ValidationException implements Exception {
  const ValidationException(this.message);
  
  final String message;
  
  @override
  String toString() => 'ValidationException: $message';
}

class AccountNotFoundException implements Exception {}

class InsufficientBalanceException implements Exception {}

class AccountAlreadyExistsException implements Exception {}

class TransactionNotFoundException implements Exception {}

class InvalidTransactionException implements Exception {
  const InvalidTransactionException(this.message);
  
  final String message;
  
  @override
  String toString() => 'InvalidTransactionException: $message';
}

class CategoryNotFoundException implements Exception {}

class CategoryInUseException implements Exception {}
