import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';

class GamePrivateNoteField extends StatefulWidget {
  final int gameId;
  final String? initialNote;

  const GamePrivateNoteField({super.key, required this.gameId, this.initialNote});

  @override
  State<GamePrivateNoteField> createState() => _GamePrivateNoteFieldState();
}

class _GamePrivateNoteFieldState extends State<GamePrivateNoteField> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<LibraryBloc>().add(UpdatePrivateNote(widget.gameId, value));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Personal Notes", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          onChanged: _onChanged,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Write your thoughts about the game...",
            hintStyle: const TextStyle(color: Colors.white24),
            fillColor: const Color(0xFF1F2430),
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF2F6BFF), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}