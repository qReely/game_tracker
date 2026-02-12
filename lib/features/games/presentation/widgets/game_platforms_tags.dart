import 'package:flutter/material.dart';

class GamePlatformsTags extends StatelessWidget {
  final List<String> platforms;
  const GamePlatformsTags({super.key, required this.platforms});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: platforms.map((p) => _buildTag(p)).toList(),
        ),
      ),
    );
  }
  Widget _buildTag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
