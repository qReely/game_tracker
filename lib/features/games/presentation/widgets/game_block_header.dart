import 'package:flutter/material.dart';

class GameBlockHeader extends StatelessWidget {
  final String headerTitle;
  const GameBlockHeader({super.key, required this.headerTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(headerTitle, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
