import 'package:flutter/material.dart';

class GameGenreSubtitle extends StatelessWidget {
  final List<String> genres;
  const GameGenreSubtitle({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    switch (genres.length) {
      case 0: return const SizedBox.shrink();
      case 1: return Text(genres.first, style: const TextStyle(color: Colors.blueGrey, fontSize: 16));
      default: return Text("${genres.first} • ${genres[1]}", style: const TextStyle(color: Colors.blueGrey, fontSize: 16));
    }
  }
}