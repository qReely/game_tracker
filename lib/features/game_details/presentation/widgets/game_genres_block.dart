import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/core/domain/entities/genre_entity.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_block_header.dart';
import 'package:go_router/go_router.dart';

class GameGenresBlock extends StatelessWidget {
  final List<GenreEntity> genres;

  const GameGenresBlock({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GameBlockHeader(headerTitle: "Genres"),
        SizedBox(height: Dimens.sm.h),
        Wrap(
          spacing: Dimens.sm.w,
          runSpacing: Dimens.sm.h,
          children: genres.map((genre) => _buildGenreChip(context, genre)).toList(),
        ),
        SizedBox(height: Dimens.xl.h),
      ],
    );
  }

  Widget _buildGenreChip(BuildContext context, GenreEntity genre) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'genre_games',
            pathParameters: {'slug': genre.slug},
            queryParameters: {'name': genre.name},
          );
        },
        borderRadius: BorderRadius.circular(Dimens.radiusCircular.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.md.w, vertical: Dimens.sm.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.radiusCircular.r),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
          child: Text(
            genre.name,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
