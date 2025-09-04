import 'package:template_app/features/category/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    super.id,
    required super.name,
    required super.type,
    super.icon,
    super.color,
    super.createdAt,
    super.updatedAt,
  });
  // Create from Map (SQLite result)
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      type: CategoryType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CategoryType.expense,
      ),
      icon: map['icon'] as String?,
      color: map['color'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : null,
    );
  }

  // Create from Entity
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      icon: entity.icon,
      color: entity.color,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'icon': icon,
      'color': color,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // Create copy with updated values
  CategoryModel copyWith({
    int? id,
    String? name,
    CategoryType? type,
    String? icon,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SubcategoryModel extends SubcategoryEntity {
  const SubcategoryModel({
    super.id,
    required super.name,
    required super.categoryId,
    super.createdAt,
    super.updatedAt,
  });
  // Create from Map (SQLite result)
  factory SubcategoryModel.fromMap(Map<String, dynamic> map) {
    return SubcategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      categoryId: map['category_id'] as int? ?? 0,
      createdAt: map['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : null,
    );
  }

  // Create from Entity
  factory SubcategoryModel.fromEntity(SubcategoryEntity entity) {
    return SubcategoryModel(
      id: entity.id,
      name: entity.name,
      categoryId: entity.categoryId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // Create copy with updated values
  SubcategoryModel copyWith({
    int? id,
    String? name,
    int? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubcategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
