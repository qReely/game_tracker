import 'package:flutter/material.dart';
import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';

class GameStatsRow extends StatelessWidget {
  final GameDetailEntity game;

  const GameStatsRow({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("CRITIC", game.metacritic.toString(), Colors.blueAccent),
          _buildStatItem("RELEASED", game.released.split('-').first, Colors.white),
          _buildStatItem("PLAYTIME", "${game.playtime}h+", Colors.white),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2)),
      ],
    );
  }
}