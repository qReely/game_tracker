import 'package:flutter/material.dart';
import 'package:game_tracker/core/widgets/app_cached_image.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_block_header.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_media_gallery_item.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class GameMediaGallery extends StatelessWidget {
  final List<String> screenshots;
  const GameMediaGallery({super.key, required this.screenshots});

  @override
  Widget build(BuildContext context) {
    if (screenshots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameBlockHeader(headerTitle: "Media Gallery"),
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: screenshots.length,
            separatorBuilder: (_, _) => SizedBox(width: Dimens.sm.w),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
                    child: AppCachedImage(
                      imageUrl: screenshots[index],
                      width: 200.w,
                      height: 120.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showImageViewer(context, index),
                        borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _showImageViewer(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => FullScreenGallery(
        screenshots: screenshots,
        initialIndex: initialIndex,
      ),
    );
  }
}

class FullScreenGallery extends StatefulWidget {
  final List<String> screenshots;
  final int initialIndex;

  const FullScreenGallery({
    super.key,
    required this.screenshots,
    required this.initialIndex,
  });

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black, // Full screen media gallery usually strictly black
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.screenshots.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            physics: _isZooming
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return MediaGalleryItem(
                imageUrl: widget.screenshots[index],
                onZoomChanged: (zooming) {
                  if (_isZooming != zooming) setState(() => _isZooming = zooming);
                },
              );
            },
          ),

          // Page Index Indicator (e.g. "2 / 10")
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.md.w, vertical: Dimens.sm.h),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
                ),
                child: Text(
                  "${_currentIndex + 1} / ${widget.screenshots.length}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),

          // Close Button
          Positioned(
            top: 40.h,
            right: 20.w,
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.black45,
                radius: 20.r,
                child: Icon(AppIcons.close, color: Colors.white, size: Dimens.iconMd.sp),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}