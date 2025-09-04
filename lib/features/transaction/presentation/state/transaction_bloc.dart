import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/core/errors/failures.dart';
import 'package:template_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:template_app/features/transaction/domain/usecases/get_all_transactions.dart';
import 'package:template_app/features/transaction/domain/usecases/save_transaction.dart';
import 'package:template_app/features/transaction/domain/usecases/get_transaction_summary.dart';

// Events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final int? userId;
  final int? accountId;
  final int? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadTransactions({
    this.userId,
    this.accountId,
    this.categoryId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, accountId, categoryId, startDate, endDate];
}

class SaveTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  const SaveTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class LoadTransactionSummary extends TransactionEvent {
  final int? userId;
  final int? accountId;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadTransactionSummary({
    this.userId,
    this.accountId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, accountId, startDate, endDate];
}

// States
abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;

  const TransactionLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionSaved extends TransactionState {
  final TransactionEntity transaction;

  const TransactionSaved(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class TransactionSummaryLoaded extends TransactionState {
  final Map<String, double> summary;

  const TransactionSummaryLoaded(this.summary);

  @override
  List<Object> get props => [summary];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetAllTransactions getAllTransactions;
  final SaveTransaction saveTransaction;
  final GetTransactionSummary getTransactionSummary;

  TransactionBloc({
    required this.getAllTransactions,
    required this.saveTransaction,
    required this.getTransactionSummary,
  }) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<SaveTransactionEvent>(_onSaveTransaction);
    on<LoadTransactionSummary>(_onLoadTransactionSummary);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final result = await getAllTransactions(GetAllTransactionsParams(
      userId: event.userId,
      accountId: event.accountId,
      categoryId: event.categoryId,
      startDate: event.startDate,
      endDate: event.endDate,
    ));

    result.fold(
      (failure) {
        String message = 'Unknown error';
        if (failure is DatabaseFailure) message = failure.message;
        if (failure is ValidationFailure) message = failure.message;
        if (failure is GeneralFailure) message = failure.message;
        emit(TransactionError(message));
      },
      (transactions) => emit(TransactionLoaded(transactions)),
    );
  }

  Future<void> _onSaveTransaction(
    SaveTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final result = await saveTransaction(SaveTransactionParams(transaction: event.transaction));

    result.fold(
      (failure) {
        String message = 'Unknown error';
        if (failure is DatabaseFailure) message = failure.message;
        if (failure is ValidationFailure) message = failure.message;
        if (failure is GeneralFailure) message = failure.message;
        emit(TransactionError(message));
      },
      (transaction) => emit(TransactionSaved(transaction)),
    );
  }

  Future<void> _onLoadTransactionSummary(
    LoadTransactionSummary event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final result = await getTransactionSummary(GetTransactionSummaryParams(
      userId: event.userId,
      startDate: event.startDate,
      endDate: event.endDate,
    ));

    result.fold(
      (failure) {
        String message = 'Unknown error';
        if (failure is DatabaseFailure) message = failure.message;
        if (failure is ValidationFailure) message = failure.message;
        if (failure is GeneralFailure) message = failure.message;
        emit(TransactionError(message));
      },
      (summary) => emit(TransactionSummaryLoaded({
        'income': summary.totalIncome,
        'expense': summary.totalExpenses,
        'net': summary.netIncome,
      })),
    );
  }
}
