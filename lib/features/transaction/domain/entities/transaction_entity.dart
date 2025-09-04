import 'package:equatable/equatable.dart';

enum TransactionType {
  income,
  expense,
  transfer,
}

class TransactionEntity extends Equatable {
  const TransactionEntity({
    this.id,
    required this.amount,
    required this.type,
    required this.accountId,
    required this.categoryId,
    this.subcategoryId,
    this.toAccountId,
    this.description,
    this.notes,
    required this.date,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final double amount;
  final TransactionType type;
  final int accountId;
  final int categoryId;
  final int? subcategoryId;
  final int? toAccountId;
  final String? description;
  final String? notes;
  final DateTime date;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Helper methods
  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
  bool get isTransfer => type == TransactionType.transfer;

  @override
  List<Object?> get props => [
    id,
    amount,
    type,
    accountId,
    categoryId,
    subcategoryId,
    toAccountId,
    description,
    notes,
    date,
    userId,
    createdAt,
    updatedAt,
  ];
}
