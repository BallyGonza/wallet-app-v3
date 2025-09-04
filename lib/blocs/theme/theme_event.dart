part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ThemeInitialEvent extends ThemeEvent {
  const ThemeInitialEvent();

  @override
  List<Object> get props => [];
}

class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();

  @override
  List<Object> get props => [];
}

class SetThemeModeEvent extends ThemeEvent {
  const SetThemeModeEvent(this.themeMode);
  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}
