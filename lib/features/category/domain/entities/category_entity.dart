import 'package:equatable/equatable.dart';

enum CategoryType {
  income,
  expense,
}

class CategoryEntity extends Equatable {
  const CategoryEntity({
    this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    this.isActive = true,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final CategoryType type;
  final String? icon;
  final String? color;
  final bool isActive;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    icon,
    color,
    isActive,
    userId,
    createdAt,
    updatedAt,
  ];
}

class SubcategoryEntity extends Equatable {
  const SubcategoryEntity({
    this.id,
    required this.name,
    required this.categoryId,
    this.icon,
    this.color,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final int categoryId;
  final String? icon;
  final String? color;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    categoryId,
    icon,
    color,
    isActive,
    createdAt,
    updatedAt,
  ];
}
