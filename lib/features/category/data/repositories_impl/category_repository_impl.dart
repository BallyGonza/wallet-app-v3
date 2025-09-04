import 'package:template_app/core/errors/exceptions.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/features/category/data/datasources/category_local_datasource.dart';
import 'package:template_app/features/category/data/models/category_model.dart';
import 'package:template_app/features/category/domain/entities/category_entity.dart';
import 'package:template_app/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl({
    required this.localDataSource,
  });
  final CategoryLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories(
      {int? userId}) async {
    try {
      final categories = await localDataSource.getAllCategories(userId: userId);
      return Right(categories);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity?>> getCategoryById(int id) async {
    try {
      final category = await localDataSource.getCategoryById(id);
      return Right(category);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> saveCategory(
      CategoryEntity category) async {
    try {
      // Validate category
      if (category.name.trim().isEmpty) {
        return const Left(ValidationFailure('Category name cannot be empty'));
      }

      final categoryModel = CategoryModel.fromEntity(category);
      final savedCategory = await localDataSource.saveCategory(categoryModel);
      return Right(savedCategory);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      if (id <= 0) {
        return const Left(ValidationFailure('Valid category ID is required'));
      }

      await localDataSource.deleteCategory(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesByType(
    CategoryType type, {
    int? userId,
  }) async {
    try {
      final categories =
          await localDataSource.getCategoriesByType(type, userId: userId);
      return Right(categories);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }
}

class SubcategoryRepositoryImpl implements SubcategoryRepository {
  const SubcategoryRepositoryImpl({
    required this.localDataSource,
  });
  final SubcategoryLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<SubcategoryEntity>>> getAllSubcategories(
      {int? userId}) async {
    try {
      final subcategories =
          await localDataSource.getAllSubcategories(userId: userId);
      return Right(subcategories);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, SubcategoryEntity?>> getSubcategoryById(int id) async {
    try {
      final subcategory = await localDataSource.getSubcategoryById(id);
      return Right(subcategory);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, SubcategoryEntity>> saveSubcategory(
      SubcategoryEntity subcategory) async {
    try {
      // Validate subcategory
      if (subcategory.name.trim().isEmpty) {
        return const Left(
            ValidationFailure('Subcategory name cannot be empty'));
      }

      if (subcategory.categoryId <= 0) {
        return const Left(ValidationFailure('Valid category ID is required'));
      }

      final subcategoryModel = SubcategoryModel.fromEntity(subcategory);
      final savedSubcategory =
          await localDataSource.saveSubcategory(subcategoryModel);
      return Right(savedSubcategory);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSubcategory(int id) async {
    try {
      if (id <= 0) {
        return const Left(
            ValidationFailure('Valid subcategory ID is required'));
      }

      await localDataSource.deleteSubcategory(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<SubcategoryEntity>>> getSubcategoriesByCategory(
    int categoryId, {
    int? userId,
  }) async {
    try {
      if (categoryId <= 0) {
        return const Left(ValidationFailure('Valid category ID is required'));
      }

      final subcategories = await localDataSource.getSubcategoriesByCategory(
        categoryId,
        userId: userId,
      );
      return Right(subcategories);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
