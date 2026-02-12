import 'package:flutter/material.dart';
import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_block_header.dart';

class GameInfoBlock extends StatelessWidget {
  final GameDetailEntity game;

  const GameInfoBlock({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameBlockHeader(headerTitle: "Information"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildInfoItem("Developer", "${game.developer}")), // Placeholder logic
            Expanded(child: _buildInfoItem("Publisher", "${game.publisher}")),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildAgeRating("${game.esrbRating}")),
            Expanded(child: _buildWebsiteLink("${game.website}")),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.blueGrey, fontSize: 14)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAgeRating(String rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Age Rating", style: TextStyle(color: Colors.blueGrey, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2430),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(rating, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildWebsiteLink(String website) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Website", style: TextStyle(color: Colors.blueGrey, fontSize: 14)),
        TextButton.icon(
          onPressed: () {
            // TODO url_launcher: website
          },
          icon: const Text("Visit Site", style: TextStyle(color: Color(0xFF2F6BFF), fontWeight: FontWeight.bold)),
          label: const Icon(Icons.open_in_new, color: Color(0xFF2F6BFF), size: 16),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
        ),
      ],
    );
  }
}