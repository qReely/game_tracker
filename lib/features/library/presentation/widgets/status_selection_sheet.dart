import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/utils/app_snackbar.dart';
import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';

void showStatusSheet(BuildContext context, GameDetailEntity game, LibraryItem? currentItem) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1F2430),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)),
            ),

            ...GameStatus.values.map((status) {
              final bool isSelected = currentItem?.status == status;

              return ListTile(
                leading: Icon(status.icon.icon, color: isSelected ? status.color : Colors.white60),
                title: Text(
                  status.name.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                // Highlight the current status with a checkmark
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: status.color)
                    : const SizedBox.shrink(),
                onTap: () {
                  context.read<LibraryBloc>().add(
                    AddGameToLibrary(
                      LibraryItem(
                        gameId: game.id,
                        gameName: game.name,
                        posterPath: game.backgroundImage,
                        status: status,
                        addedAt: DateTime.now(),
                      ),
                    ),
                  );
                  Navigator.pop(sheetContext);
                },
              );
            }).toList(),

            // Remove Option (Only show if game is in library)
            if (currentItem != null) ...[
              const Divider(color: Colors.white10, height: 32),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: const Text("REMOVE FROM LIBRARY", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onTap: () {
                  // Ensure your LibraryBloc has a Remove event
                  context.read<LibraryBloc>().add(RemoveGameFromLibrary(game.id));
                  Navigator.pop(sheetContext);
                  AppSnackbar.show(context, message: "Removed from library", type: SnackbarType.info);
                },
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      );
    },
  );
}