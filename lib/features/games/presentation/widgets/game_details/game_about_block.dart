import 'package:flutter/material.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_block_header.dart';

class GameAboutBlock extends StatefulWidget {
  final String description;
  const GameAboutBlock({super.key, required this.description});

  @override
  State<GameAboutBlock> createState() => _GameAboutBlockState();
}

class _GameAboutBlockState extends State<GameAboutBlock> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Strips HTML tags from RAWG's description
    final cleanDescription = widget.description.replaceAll(RegExp(r'<[^>]*>'), '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameBlockHeader(headerTitle: "About"),
        Text(
          cleanDescription,
          maxLines: isExpanded ? null : 4,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 15),
        ),
        TextButton(
          onPressed: () => setState(() => isExpanded = !isExpanded),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
          child: Text(isExpanded ? "Show less" : "Read more", style: const TextStyle(color: Color(0xFF2F6BFF))),
        ),
      ],
    );
  }
}