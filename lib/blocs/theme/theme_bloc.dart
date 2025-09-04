import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState.initial()) {
    on<ThemeInitialEvent>(_onInit);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeModeEvent>(_onSetThemeMode);

    add(const ThemeInitialEvent());
  }

  Future<void> _onInit(
    ThemeInitialEvent event,
    Emitter<ThemeState> emit,
  ) async {
    // In a real app, you might load the theme from persistent storage
    emit(const ThemeState.loaded(ThemeMode.system));
  }

  void _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState.loaded(newThemeMode));
  }

  void _onSetThemeMode(
    SetThemeModeEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(ThemeState.loaded(event.themeMode));
  }
}
