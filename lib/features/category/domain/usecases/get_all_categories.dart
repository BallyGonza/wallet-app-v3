import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/category/domain/entities/category_entity.dart';
import 'package:template_app/features/category/domain/repositories/category_repository.dart';

class GetAllCategories implements UseCase<List<CategoryEntity>, GetAllCategoriesParams> {
  const GetAllCategories(this.repository);

  final CategoryRepository repository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(GetAllCategoriesParams params) async {
    return await repository.getAllCategories(userId: params.userId);
  }
}

class GetAllCategoriesParams {
  const GetAllCategoriesParams({this.userId});

  final int? userId;
}
