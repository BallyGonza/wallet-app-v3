import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseSync<Type, Params> {
  Either<Failure, Type> call(Params params);
}

class NoParams {
  const NoParams();
}
