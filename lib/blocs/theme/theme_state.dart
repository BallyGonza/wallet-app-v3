part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState.initial({ThemeMode? initialThemeMode})
      : themeMode = initialThemeMode ?? ThemeMode.system,
        error = null;

  const ThemeState.loaded(this.themeMode) : error = null;

  const ThemeState.error(this.error) : themeMode = ThemeMode.system;

  final ThemeMode themeMode;
  final String? error;

  @override
  List<Object?> get props => [themeMode, error];
}
