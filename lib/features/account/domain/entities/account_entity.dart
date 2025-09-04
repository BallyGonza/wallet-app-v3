import 'package:equatable/equatable.dart';

enum AccountType {
  bank,
  cash,
  creditCard,
  savings,
  investment,
  other,
}

class AccountEntity extends Equatable {
  const AccountEntity({
    this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    this.description,
    this.isActive = true,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final AccountType type;
  final double balance;
  final String currency;
  final String? description;
  final bool isActive;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    balance,
    currency,
    description,
    isActive,
    userId,
    createdAt,
    updatedAt,
  ];
}
