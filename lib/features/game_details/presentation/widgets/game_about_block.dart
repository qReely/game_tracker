import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_block_header.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate if text overflows 4 lines
        final span = TextSpan(
          text: cleanDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.5),
        );
        final tp = TextPainter(
          text: span,
          maxLines: 4,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth - 4); // Added buffer for better precision
        final bool isLong = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GameBlockHeader(headerTitle: "About"),
            Text(
              cleanDescription,
              maxLines: isExpanded ? null : 4,
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary, 
                height: 1.5,
                fontSize: 14.sp,
              ),
            ),
            if (isLong)
              TextButton(
                onPressed: () {
                  if (isExpanded) {
                    // Scroll so that the block button remains visible at bottom
                    Scrollable.ensureVisible(
                      context,
                      duration: const Duration(milliseconds: 300),
                      alignment: 0.0, // Scroll back to top of the title
                    );
                  }
                  setState(() => isExpanded = !isExpanded);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, 
                  minimumSize: Size(0, 30.h),
                ),
                child: Text(
                  isExpanded ? "Show less" : "Read more", 
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: Dimens.xl.h),
          ],
        );
      },
    );
  }
}