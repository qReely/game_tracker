import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';

class GameUserRatingBar extends StatelessWidget {
  final int gameId;
  final double currentRating;

  const GameUserRatingBar({super.key, required this.gameId, required this.currentRating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Your Rating", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1.0;
            final isFilled = starValue <= currentRating;

            return IconButton(
              onPressed: () {
                context.read<LibraryBloc>().add(UpdateUserRating(gameId, starValue));
              },
              icon: Icon(
                isFilled ? Icons.star : Icons.star_border,
                color: isFilled ? Colors.amber : Colors.blueGrey,
                size: 32,
              ),
            );
          }),
        ),
      ],
    );
  }
}