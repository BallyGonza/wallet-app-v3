import 'package:template_app/features/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    super.id,
    required super.amount,
    required super.type,
    required super.accountId,
    required super.categoryId,
    super.subcategoryId,
    super.toAccountId,
    super.description,
    super.notes,
    required super.date,
    super.userId,
    super.createdAt,
    super.updatedAt,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type.name,
      'account_id': accountId,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'to_account_id': toAccountId,
      'description': description,
      'notes': notes,
      'date': date.millisecondsSinceEpoch,
      'user_id': userId,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // Create from Map (SQLite result)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      accountId: map['account_id'] as int? ?? 0,
      categoryId: map['category_id'] as int? ?? 0,
      subcategoryId: map['subcategory_id'] as int?,
      toAccountId: map['to_account_id'] as int?,
      description: map['description'] as String?,
      notes: map['notes'] as String?,
      date: DateTime.fromMillisecondsSinceEpoch(
        map['date'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
      userId: map['user_id'] as int?,
      createdAt: map['created_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : null,
    );
  }

  // Create from Entity
  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      type: entity.type,
      accountId: entity.accountId,
      categoryId: entity.categoryId,
      subcategoryId: entity.subcategoryId,
      toAccountId: entity.toAccountId,
      description: entity.description,
      notes: entity.notes,
      date: entity.date,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Create copy with updated values
  TransactionModel copyWith({
    int? id,
    double? amount,
    TransactionType? type,
    int? accountId,
    int? categoryId,
    int? subcategoryId,
    int? toAccountId,
    String? description,
    String? notes,
    DateTime? date,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      toAccountId: toAccountId ?? this.toAccountId,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
