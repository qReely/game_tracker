import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';
import 'package:go_router/go_router.dart';

class GameNotesPage extends StatefulWidget {
  final int gameId;
  final String gameName;
  final String? initialNote;

  const GameNotesPage({
    super.key,
    required this.gameId,
    required this.gameName,
    this.initialNote,
  });

  @override
  State<GameNotesPage> createState() => _GameNotesPageState();
}

class _GameNotesPageState extends State<GameNotesPage> {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Personal Note", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.gameName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Done", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimens.lg),
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          maxLines: null,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
          decoration: const InputDecoration(
            hintText: "Write your thoughts about the game...",
            hintStyle: TextStyle(color: Colors.white24),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
