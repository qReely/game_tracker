import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_block_header.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_media_gallery_item.dart';

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
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: screenshots.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showImageViewer(context, index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: screenshots[index],
                    width: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.white10),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
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
      backgroundColor: Colors.black,
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
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_currentIndex + 1} / ${widget.screenshots.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          // Close Button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black45,
                child: Icon(Icons.close, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}