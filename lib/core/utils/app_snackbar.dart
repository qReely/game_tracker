import 'package:flutter/material.dart';

enum SnackbarType { info, success, warning, error }

extension SnackbarTypeX on SnackbarType {
  Color get color {
    switch (this) {
      case SnackbarType.success: return Colors.green;
      case SnackbarType.error: return Colors.red;
      case SnackbarType.warning: return Colors.orange;
      case SnackbarType.info: return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case SnackbarType.success: return Icons.check_circle_outline;
      case SnackbarType.error: return Icons.error_outline;
      case SnackbarType.warning: return Icons.warning_amber_rounded;
      case SnackbarType.info: return Icons.info_outline;
    }
  }
}

class AppSnackbar {
  static void show(
      BuildContext context, {
        required String message,
        required SnackbarType type,
        bool showAtTop = false,
      }) {
    final color = type.color;
    final icon = type.icon;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        dismissDirection: showAtTop ? DismissDirection.up : DismissDirection.down,
        margin: showAtTop
            ? EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 160, left: 20, right: 20)
            : const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}