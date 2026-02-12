import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/utils/app_snackbar.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_bloc.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_event.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            AppSnackbar.show(
              context,
              message: state.message,
              type: SnackbarType.error,
              showAtTop: true,
            );
          }
          if (state is LoginSuccess) {
            AppSnackbar.show(
                context,
                message: "Successfully logged in!",
                type: SnackbarType.success
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your App Logo or a Gaming Icon
              const Icon(Icons.videogame_asset, size: 100, color: Colors.deepPurpleAccent),
              const SizedBox(height: 20),
              const Text(
                "Game Tracker",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text("Track your backlog with ease.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 50),

              // The Google Sign-In Button
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const CircularProgressIndicator(color: Colors.deepPurpleAccent);
                  }

                  return ElevatedButton.icon(
                    onPressed: () {
                      context.read<LoginBloc>().add(GoogleSignInRequested());
                    },
                    icon: const Icon(Icons.login, color: Colors.black),
                    label: const Text("Sign in with Google", style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}