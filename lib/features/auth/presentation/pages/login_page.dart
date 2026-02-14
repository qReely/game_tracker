import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/utils/app_snackbar.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_bloc.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_event.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
              const Icon(AppIcons.gamepad, size: 100, color: AppColors.primary),
              SizedBox(height: Dimens.lg.h),
              Text(
                "Game Tracker",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: Dimens.sm.h),
              Text(
                "Track your backlog with ease.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: Dimens.xxl.h),

              // The Google Sign-In Button
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const CircularProgressIndicator(color: AppColors.primary);
                  }

                  return ElevatedButton.icon(
                    onPressed: () {
                      context.read<LoginBloc>().add(GoogleSignInRequested());
                    },
                    icon: const Icon(AppIcons.google, color: Colors.black),
                    label: Text("Sign in with Google", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: Dimens.xl.w, vertical: Dimens.md.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  );
                },
              ),
              SizedBox(height: Dimens.md.h),
              TextButton(
                onPressed: () {
                  context.read<LoginBloc>().add(AnonymousSignInRequested());
                },
                child: Text(
                  "Continue as Guest",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}