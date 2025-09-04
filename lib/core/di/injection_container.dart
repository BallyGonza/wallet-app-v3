import 'package:get_it/get_it.dart';
import 'package:template_app/features/account/data/datasources/account_local_datasource.dart';
import 'package:template_app/features/account/data/repositories_impl/account_repository_impl.dart';
import 'package:template_app/features/account/domain/repositories/account_repository.dart';
import 'package:template_app/features/account/domain/usecases/delete_account.dart';
import 'package:template_app/features/account/domain/usecases/get_all_accounts.dart';
import 'package:template_app/features/account/domain/usecases/get_total_balance.dart';
import 'package:template_app/features/account/domain/usecases/save_account.dart';
import 'package:template_app/features/account/presentation/state/account_bloc.dart';
import 'package:template_app/features/category/data/datasources/category_local_datasource.dart';
import 'package:template_app/features/category/data/repositories_impl/category_repository_impl.dart';
import 'package:template_app/features/category/domain/repositories/category_repository.dart';
import 'package:template_app/features/category/domain/usecases/get_all_categories.dart';
import 'package:template_app/features/category/domain/usecases/save_category.dart';
import 'package:template_app/features/category/presentation/state/category_bloc.dart';
import 'package:template_app/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:template_app/features/transaction/data/repositories_impl/transaction_repository_impl.dart';
import 'package:template_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:template_app/features/transaction/domain/usecases/get_all_transactions.dart';
import 'package:template_app/features/transaction/domain/usecases/get_transaction_summary.dart';
import 'package:template_app/features/transaction/domain/usecases/save_transaction.dart';
import 'package:template_app/features/transaction/presentation/state/transaction_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Features - Account
  // Bloc
  sl
    ..registerFactory(
      () => AccountBloc(
        getAllAccounts: sl(),
        saveAccount: sl(),
        deleteAccount: sl(),
        getTotalBalance: sl(),
      ),
    )

    // Use cases
    ..registerLazySingleton(() => GetAllAccounts(sl()))
    ..registerLazySingleton(() => SaveAccount(sl()))
    ..registerLazySingleton(() => DeleteAccount(sl()))
    ..registerLazySingleton(() => GetTotalBalance(sl()))

    // Repository
    ..registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(
        localDataSource: sl(),
      ),
    )

    // Data sources
    ..registerLazySingleton<AccountLocalDataSource>(
      () => const AccountLocalDataSourceImpl(),
    )

    //! Features - Transaction
    // Bloc
    ..registerFactory(
      () => TransactionBloc(
        getAllTransactions: sl(),
        saveTransaction: sl(),
        getTransactionSummary: sl(),
      ),
    )

    // Use cases
    ..registerLazySingleton(() => GetAllTransactions(sl()))
    ..registerLazySingleton(() => SaveTransaction(sl()))
    ..registerLazySingleton(() => GetTransactionSummary(sl()))

    // Repository
    ..registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(
        localDataSource: sl(),
      ),
    )

    // Data sources
    ..registerLazySingleton<TransactionLocalDataSource>(
      () => const TransactionLocalDataSourceImpl(),
    )

    //! Features - Category
    // Bloc
    ..registerFactory(
      () => CategoryBloc(
        getAllCategories: sl(),
        saveCategory: sl(),
      ),
    )

    // Use cases
    ..registerLazySingleton(() => GetAllCategories(sl()))
    ..registerLazySingleton(() => SaveCategory(sl()))

    // Repository
    ..registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(
        localDataSource: sl(),
      ),
    )

    // Data sources
    ..registerLazySingleton<CategoryLocalDataSource>(
      () => const CategoryLocalDataSourceImpl(),
    );

  //! Core
  // Add other core dependencies here if needed

  //! External
  // Add external dependencies here (databases, http clients, etc.)
}
