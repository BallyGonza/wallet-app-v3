import 'package:template_app/core/errors/exceptions.dart';
import 'package:template_app/features/category/data/models/category_model.dart';
import 'package:template_app/features/category/domain/entities/category_entity.dart';
import 'package:template_app/services/database_service.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAllCategories({int? userId});
  Future<CategoryModel?> getCategoryById(int id);
  Future<CategoryModel> saveCategory(CategoryModel category);
  Future<void> deleteCategory(int id);
  Future<List<CategoryModel>> getCategoriesByType(CategoryType type, {int? userId});
}

abstract class SubcategoryLocalDataSource {
  Future<List<SubcategoryModel>> getAllSubcategories({int? userId});
  Future<SubcategoryModel?> getSubcategoryById(int id);
  Future<SubcategoryModel> saveSubcategory(SubcategoryModel subcategory);
  Future<void> deleteSubcategory(int id);
  Future<List<SubcategoryModel>> getSubcategoriesByCategory(int categoryId, {int? userId});
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  const CategoryLocalDataSourceImpl();

  @override
  Future<List<CategoryModel>> getAllCategories({int? userId}) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = userId != null
          ? await db.query('categories', where: 'user_id = ?', whereArgs: [userId])
          : await db.query('categories');
      return maps.map((map) => CategoryModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get all categories: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      );
      return maps.isNotEmpty ? CategoryModel.fromMap(maps.first) : null;
    } catch (e) {
      throw DatabaseException('Failed to get category by id: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel> saveCategory(CategoryModel category) async {
    try {
      final db = await DatabaseService.database;
      final now = DateTime.now();
      
      if (category.id == null) {
        // Insert new category
        final categoryWithTimestamp = category.copyWith(
          createdAt: now,
          updatedAt: now,
        );
        final categoryId = await db.insert('categories', categoryWithTimestamp.toMap());
        return categoryWithTimestamp.copyWith(id: categoryId);
      } else {
        // Update existing category
        final updatedCategory = category.copyWith(updatedAt: now);
        await db.update(
          'categories',
          updatedCategory.toMap(),
          where: 'id = ?',
          whereArgs: [updatedCategory.id],
        );
        return updatedCategory;
      }
    } catch (e) {
      throw DatabaseException('Failed to save category: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      final db = await DatabaseService.database;
      await db.delete(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete category: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesByType(CategoryType type, {int? userId}) async {
    try {
      final db = await DatabaseService.database;
      
      String whereClause = 'type = ?';
      List<dynamic> whereArgs = [type.name];
      
      if (userId != null) {
        whereClause += ' AND user_id = ?';
        whereArgs.add(userId);
      }
      
      final List<Map<String, dynamic>> maps = await db.query(
        'categories',
        where: whereClause,
        whereArgs: whereArgs,
      );
      
      return maps.map((map) => CategoryModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get categories by type: ${e.toString()}');
    }
  }
}

class SubcategoryLocalDataSourceImpl implements SubcategoryLocalDataSource {
  const SubcategoryLocalDataSourceImpl();

  @override
  Future<List<SubcategoryModel>> getAllSubcategories({int? userId}) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = userId != null
          ? await db.query('subcategories', where: 'user_id = ?', whereArgs: [userId])
          : await db.query('subcategories');
      return maps.map((map) => SubcategoryModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get all subcategories: ${e.toString()}');
    }
  }

  @override
  Future<SubcategoryModel?> getSubcategoryById(int id) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'subcategories',
        where: 'id = ?',
        whereArgs: [id],
      );
      return maps.isNotEmpty ? SubcategoryModel.fromMap(maps.first) : null;
    } catch (e) {
      throw DatabaseException('Failed to get subcategory by id: ${e.toString()}');
    }
  }

  @override
  Future<SubcategoryModel> saveSubcategory(SubcategoryModel subcategory) async {
    try {
      final db = await DatabaseService.database;
      final now = DateTime.now();
      
      if (subcategory.id == null) {
        // Insert new subcategory
        final subcategoryWithTimestamp = subcategory.copyWith(
          createdAt: now,
          updatedAt: now,
        );
        final subcategoryId = await db.insert('subcategories', subcategoryWithTimestamp.toMap());
        return subcategoryWithTimestamp.copyWith(id: subcategoryId);
      } else {
        // Update existing subcategory
        final updatedSubcategory = subcategory.copyWith(updatedAt: now);
        await db.update(
          'subcategories',
          updatedSubcategory.toMap(),
          where: 'id = ?',
          whereArgs: [updatedSubcategory.id],
        );
        return updatedSubcategory;
      }
    } catch (e) {
      throw DatabaseException('Failed to save subcategory: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSubcategory(int id) async {
    try {
      final db = await DatabaseService.database;
      await db.delete(
        'subcategories',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete subcategory: ${e.toString()}');
    }
  }

  @override
  Future<List<SubcategoryModel>> getSubcategoriesByCategory(int categoryId, {int? userId}) async {
    try {
      final db = await DatabaseService.database;
      
      String whereClause = 'category_id = ?';
      List<dynamic> whereArgs = [categoryId];
      
      if (userId != null) {
        whereClause += ' AND user_id = ?';
        whereArgs.add(userId);
      }
      
      final List<Map<String, dynamic>> maps = await db.query(
        'subcategories',
        where: whereClause,
        whereArgs: whereArgs,
      );
      
      return maps.map((map) => SubcategoryModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get subcategories by category: ${e.toString()}');
    }
  }
}
