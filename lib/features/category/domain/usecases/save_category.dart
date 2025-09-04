import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/category/domain/entities/category_entity.dart';
import 'package:template_app/features/category/domain/repositories/category_repository.dart';

class SaveCategory implements UseCase<CategoryEntity, SaveCategoryParams> {
  const SaveCategory(this.repository);

  final CategoryRepository repository;

  @override
  Future<Either<Failure, CategoryEntity>> call(SaveCategoryParams params) async {
    return await repository.saveCategory(params.category);
  }
}

class SaveCategoryParams {
  const SaveCategoryParams({required this.category});

  final CategoryEntity category;
}
