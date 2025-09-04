import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/features/account/domain/entities/account_entity.dart';
import 'package:template_app/features/account/domain/usecases/get_all_accounts.dart';
import 'package:template_app/features/account/domain/usecases/save_account.dart';
import 'package:template_app/features/account/domain/usecases/delete_account.dart';
import 'package:template_app/features/account/domain/usecases/get_total_balance.dart';

// Events
abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccounts extends AccountEvent {
  const LoadAccounts({this.userId});
  
  final int? userId;

  @override
  List<Object?> get props => [userId];
}

class AddAccount extends AccountEvent {
  const AddAccount(this.account);
  
  final AccountEntity account;

  @override
  List<Object> get props => [account];
}

class UpdateAccount extends AccountEvent {
  const UpdateAccount(this.account);
  
  final AccountEntity account;

  @override
  List<Object> get props => [account];
}

class DeleteAccountEvent extends AccountEvent {
  const DeleteAccountEvent(this.accountId);
  
  final int accountId;

  @override
  List<Object> get props => [accountId];
}

class RefreshAccounts extends AccountEvent {
  const RefreshAccounts({this.userId});
  
  final int? userId;

  @override
  List<Object?> get props => [userId];
}

// States
abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  const AccountLoaded({
    required this.accounts,
    required this.totalBalance,
  });

  final List<AccountEntity> accounts;
  final double totalBalance;

  @override
  List<Object> get props => [accounts, totalBalance];
}

class AccountError extends AccountState {
  const AccountError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class AccountOperationSuccess extends AccountState {
  const AccountOperationSuccess(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

// BLoC
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({
    required this.getAllAccounts,
    required this.saveAccount,
    required this.deleteAccount,
    required this.getTotalBalance,
  }) : super(AccountInitial()) {
    on<LoadAccounts>(_onLoadAccounts);
    on<AddAccount>(_onAddAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<RefreshAccounts>(_onRefreshAccounts);
  }

  final GetAllAccounts getAllAccounts;
  final SaveAccount saveAccount;
  final DeleteAccount deleteAccount;
  final GetTotalBalance getTotalBalance;

  Future<void> _onLoadAccounts(
    LoadAccounts event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    
    final accountsResult = await getAllAccounts(GetAllAccountsParams(userId: event.userId));
    final balanceResult = await getTotalBalance(GetTotalBalanceParams(userId: event.userId));
    
    accountsResult.fold(
      (failure) => emit(AccountError('Failed to load accounts: ${failure.toString()}')),
      (accounts) {
        balanceResult.fold(
          (failure) => emit(AccountError('Failed to load balance: ${failure.toString()}')),
          (balance) => emit(AccountLoaded(accounts: accounts, totalBalance: balance)),
        );
      },
    );
  }

  Future<void> _onAddAccount(
    AddAccount event,
    Emitter<AccountState> emit,
  ) async {
    final result = await saveAccount(SaveAccountParams(account: event.account));
    
    result.fold(
      (failure) => emit(AccountError('Failed to add account: ${failure.toString()}')),
      (account) {
        emit(const AccountOperationSuccess('Account added successfully'));
        add(LoadAccounts(userId: event.account.userId));
      },
    );
  }

  Future<void> _onUpdateAccount(
    UpdateAccount event,
    Emitter<AccountState> emit,
  ) async {
    final result = await saveAccount(SaveAccountParams(account: event.account));
    
    result.fold(
      (failure) => emit(AccountError('Failed to update account: ${failure.toString()}')),
      (account) {
        emit(const AccountOperationSuccess('Account updated successfully'));
        add(LoadAccounts(userId: event.account.userId));
      },
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    final result = await deleteAccount(DeleteAccountParams(accountId: event.accountId));
    
    result.fold(
      (failure) => emit(AccountError('Failed to delete account: ${failure.toString()}')),
      (_) {
        emit(const AccountOperationSuccess('Account deleted successfully'));
        add(const RefreshAccounts());
      },
    );
  }

  Future<void> _onRefreshAccounts(
    RefreshAccounts event,
    Emitter<AccountState> emit,
  ) async {
    add(LoadAccounts(userId: event.userId));
  }
}
