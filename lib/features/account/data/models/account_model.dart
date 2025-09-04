import 'package:template_app/features/account/domain/entities/account_entity.dart';

class AccountModel extends AccountEntity {
  const AccountModel({
    super.id,
    required super.name,
    required super.type,
    required super.balance,
    required super.currency,
    super.description,
    super.isActive = true,
    super.userId,
    super.createdAt,
    super.updatedAt,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'balance': balance,
      'currency': currency,
      'description': description,
      'is_active': isActive ? 1 : 0,
      'user_id': userId,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // Create from Map (SQLite result)
  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      type: AccountType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AccountType.other,
      ),
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] as String? ?? 'USD',
      description: map['description'] as String?,
      isActive: (map['is_active'] as int?) == 1,
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
  factory AccountModel.fromEntity(AccountEntity entity) {
    return AccountModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      balance: entity.balance,
      currency: entity.currency,
      description: entity.description,
      isActive: entity.isActive,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Create copy with updated values
  AccountModel copyWith({
    int? id,
    String? name,
    AccountType? type,
    double? balance,
    String? currency,
    String? description,
    bool? isActive,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
