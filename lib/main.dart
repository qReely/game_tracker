import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart' as di;
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/router/app_router.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';
import 'package:game_tracker/core/theme/app_theme.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

import 'package:flutter/services.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LibraryBloc>()..add(WatchLibrary())), // Provide globally
        BlocProvider(create: (_) => sl<LoginBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          UiScaler.init(context);
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            title: 'Game Tracker',
            theme: AppTheme.darkTheme,
          );
        },
      ),
    );
  }
}