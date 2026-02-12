import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart' as di;
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_bloc.dart';
import 'package:game_tracker/features/games/presentation/pages/home_page.dart';
import 'package:game_tracker/features/auth/presentation/pages/login_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: di.sl<AuthRepository>().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // If snapshot has data (AppUser), go to Home. Otherwise, Login.
        if (snapshot.hasData) {
          // check the data
          return const HomePage();
        } else {
          return BlocProvider(
            create: (_) => di.sl<LoginBloc>(),
            child: const LoginPage(),
          );
        }
      },
    );
  }
}