import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories({int? userId});
  Future<Either<Failure, CategoryEntity?>> getCategoryById(int id);
  Future<Either<Failure, CategoryEntity>> saveCategory(CategoryEntity category);
  Future<Either<Failure, void>> deleteCategory(int id);
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesByType(CategoryType type, {int? userId});
  Future<Either<Failure, List<CategoryEntity>>> getIncomeCategories({int? userId});
  Future<Either<Failure, List<CategoryEntity>>> getExpenseCategories({int? userId});
  Future<Either<Failure, List<CategoryEntity>>> getActiveCategories({int? userId});
  Future<Either<Failure, void>> createDefaultCategories(int userId);
}

abstract class SubcategoryRepository {
  Future<Either<Failure, List<SubcategoryEntity>>> getSubcategoriesByCategory(int categoryId);
  Future<Either<Failure, SubcategoryEntity?>> getSubcategoryById(int id);
  Future<Either<Failure, SubcategoryEntity>> saveSubcategory(SubcategoryEntity subcategory);
  Future<Either<Failure, void>> deleteSubcategory(int id);
  Future<Either<Failure, List<SubcategoryEntity>>> getActiveSubcategoriesByCategory(int categoryId);
  Future<Either<Failure, void>> createDefaultSubcategories(int categoryId, String categoryName);
}
