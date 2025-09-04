import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

// Database failures
class DatabaseFailure extends Failure {
  const DatabaseFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

// Account specific failures
class AccountNotFoundFailure extends Failure {}

class InsufficientBalanceFailure extends Failure {}

class AccountAlreadyExistsFailure extends Failure {}

// Transaction specific failures
class TransactionNotFoundFailure extends Failure {}

class InvalidTransactionFailure extends Failure {
  const InvalidTransactionFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

// General failure with message
class GeneralFailure extends Failure {
  const GeneralFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

// Category specific failures
class CategoryNotFoundFailure extends Failure {}

class CategoryInUseFailure extends Failure {}
