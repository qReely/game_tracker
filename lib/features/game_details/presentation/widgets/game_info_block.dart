import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/core/domain/entities/company_entity.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_block_header.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/core/constants/app_icons.dart';

class GameInfoBlock extends StatelessWidget {
  final GameDetailEntity game;

  const GameInfoBlock({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final bool hasDev = game.developer.isNotEmpty;
    final bool hasPub = game.publisher.isNotEmpty;
    final bool hasEsrb = game.esrbRating != null;
    final bool hasWebsite = game.website != null && game.website!.isNotEmpty;

    if (!hasDev && !hasPub && !hasEsrb && !hasWebsite) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameBlockHeader(headerTitle: "Information"),
        if (hasDev || hasPub)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasDev)
                Expanded(child: _buildInfoItem(
                  context, 
                  "Developer", 
                  game.developer,
                  isPublisher: false,
                )),
              if (hasPub)
                Expanded(child: _buildInfoItem(
                  context, 
                  "Publisher", 
                  game.publisher,
                  isPublisher: true,
                )),
            ],
          ),
        if (hasDev || hasPub)
          SizedBox(height: Dimens.lg),
        if (hasEsrb || hasWebsite)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasEsrb)
                Expanded(child: _buildAgeRating(context, "${game.esrbRating}")),
              if (hasWebsite)
                Expanded(child: _buildWebsiteLink(context, "${game.website}")),
            ],
          ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, 
    String label, 
    List<CompanyEntity> companies, 
    {required bool isPublisher}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp)),
        SizedBox(height: Dimens.sm.h),
        Wrap(
          spacing: Dimens.xs.w,
          children: companies.map((c) => InkWell(
            onTap: () {
              final route = isPublisher ? 'publisher' : 'developer';
              context.pushNamed(route, pathParameters: {'slug': c.slug}, queryParameters: {'name': c.name});
            },
            borderRadius: BorderRadius.circular(Dimens.radiusXs.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Text(
                c.name, 
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold, 
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                )
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildAgeRating(BuildContext context, String rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Age Rating", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp)),
        SizedBox(height: Dimens.sm.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.sm.w, vertical: Dimens.xs.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(Dimens.radiusSm.r),
            border: Border.all(color: AppColors.textSecondary.withValues(alpha: 60)),
          ),
          child: Text(rating, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        ),
      ],
    );
  }

  Widget _buildWebsiteLink(BuildContext context, String website) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Website", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp)),
        TextButton.icon(
          onPressed: () async {
            final uri = Uri.tryParse(website);
            if (uri != null && await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
            }
          },
          icon: Text("Visit Site", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary, fontSize: 14.sp)),
          label: Icon(AppIcons.openInNew, color: AppColors.primary, size: 16.sp),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
        ),
      ],
    );
  }
}