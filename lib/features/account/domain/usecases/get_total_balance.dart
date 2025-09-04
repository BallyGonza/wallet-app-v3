import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/core/utils/either.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/account/domain/repositories/account_repository.dart';

class GetTotalBalance implements UseCase<double, GetTotalBalanceParams> {
  const GetTotalBalance(this.repository);

  final AccountRepository repository;

  @override
  Future<Either<Failure, double>> call(GetTotalBalanceParams params) async {
    return await repository.getTotalBalance(userId: params.userId);
  }
}

class GetTotalBalanceParams {
  const GetTotalBalanceParams({this.userId});

  final int? userId;
}
