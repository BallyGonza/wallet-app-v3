import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/blocs/theme/theme.dart';
import 'package:template_app/blocs/user/user.dart';
import 'package:template_app/core/di/injection_container.dart' as di;
import 'package:template_app/data/repositories/user_repository.dart';
import 'package:template_app/features/account/presentation/state/account_bloc.dart';
import 'package:template_app/features/category/presentation/state/category_bloc.dart';
import 'package:template_app/features/transaction/presentation/state/transaction_bloc.dart';
import 'package:template_app/services/services.dart';
import 'package:template_app/theme.dart';
import 'package:template_app/views/views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountBloc>(
          create: (context) => di.sl<AccountBloc>(),
        ),
        BlocProvider<TransactionBloc>(
          create: (context) => di.sl<TransactionBloc>(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => di.sl<CategoryBloc>(),
        ),
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
            title: 'Wallet App',
            theme: themeState.themeMode == ThemeMode.light
                ? ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  )
                : ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                    brightness: Brightness.dark,
                  ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: themeState.themeMode,
            home: const MyHomePage(title: 'Wallet App - Clean Architecture'),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
