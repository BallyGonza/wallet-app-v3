import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/blocs/blocs.dart';
import 'package:template_app/data/data.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const UserState.initial()) {
    on<UserInitialEvent>(_onInit);
    add(const UserEvent.init());
  }

  final UserRepository _userRepository;
  late UserModel _user;

  Future<void> _onInit(
    UserInitialEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserState.loading());
    try {
      _user = await _userRepository.getUser();
      emit(UserState.loaded(_user));
    } on Exception catch (e) {
      emit(UserState.error(e.toString()));
    }
  }
}
