import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/auth/data/repositiories/firebase_auth_repository_impl.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.instance;

void init() {
  // Repository
  GoogleSignIn.instance.initialize(
    serverClientId: '490063376002-au8b40tqmbkqaku721oerad5a08as06q.apps.googleusercontent.com', // needed for idToken
  );
  sl.registerLazySingleton(() => GoogleSignIn.instance);

  sl.registerLazySingleton<AuthRepository>(() => FirebaseAuthRepository(sl(), sl()));

  // BLoC (Using registerFactory for BLoCs, to get a fresh one per screen)
  sl.registerFactory(() => LoginBloc(sl()));

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}