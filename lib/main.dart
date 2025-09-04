import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/blocs/blocs.dart';
import 'package:template_app/data/data.dart';
import 'package:template_app/services/services.dart';
import 'package:template_app/theme.dart';
import 'package:template_app/views/views.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    // Ensure Flutter binding is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize services
    await Future.wait<void>([
      DatabaseService.initialize(),
      SystemChromeService.setSystemChrome(),
    ]);

    // Run the app with error handling
    runApp(const MainApp());
  }, (error, stackTrace) {
    // Global error handling
    debugPrint('Unhandled error: $error');
    debugPrint('Stack trace: $stackTrace');
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(
            userRepository: UserRepository(),
          ),
        ),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Template App',
            theme: appThemeLight,
            darkTheme: appThemeDark,
            themeMode: themeState.themeMode,
            home: const App(),
            // Add global app configurations
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
