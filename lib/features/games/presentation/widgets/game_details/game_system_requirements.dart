import 'package:flutter/material.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_block_header.dart';

class GameSystemRequirements extends StatelessWidget {
  final Map<String, String> pcRequirements;
  const GameSystemRequirements({super.key, required this.pcRequirements});

  @override
  Widget build(BuildContext context) {
    final cleanMin = parseRequirements(pcRequirements['minimum']?.replaceAll("Minimum:", "").trim() ?? "");
    if (cleanMin.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameBlockHeader(headerTitle: "System Requirements"),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2430),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("MINIMUM", style: TextStyle(color: Color(0xFF2F6BFF), fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...cleanMin.entries.map((entry) => _buildSpecRow(entry.key, entry.value)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> parseRequirements(String rawString) {
    final Map<String, String> specs = {};

    // Define the keys we want to extract
    final keys = ['OS', 'Processor', 'Memory', 'Graphics', 'Storage'];

    // Regex to find a key followed by its value until the next key or end of string
    // It looks for patterns like "OS: ... Processor:"
    for (var i = 0; i < keys.length; i++) {
      final currentKey = keys[i];
      final nextKey = (i + 1 < keys.length) ? keys[i + 1] : null;

      // Create a regex for the current key
      final regExp = RegExp(
        '$currentKey: (.*?)(?=${nextKey != null ? "$nextKey:" : r"Sound Card:|Additional Notes:|Other requirements:|$"})',
        caseSensitive: false,
        dotAll: true,
      );

      final match = regExp.firstMatch(rawString);
      if (match != null) {
        specs[currentKey] = match.group(1)?.trim() ?? 'N/A';
      }
    }

    return specs;
  }
}