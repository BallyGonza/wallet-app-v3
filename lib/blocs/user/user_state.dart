import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_app/data/data.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = UserInitialState;
  const factory UserState.loading() = UserLoadingState;
  const factory UserState.loaded(UserModel user) = UserLoadedState;
  const factory UserState.error(String message) = UserErrorState;
}
