import 'package:flutter/material.dart';
import 'package:game_tracker/core/widgets/app_cached_image.dart';

class MediaGalleryItem extends StatefulWidget {
  final String imageUrl;
  final Function(bool) onZoomChanged;

  const MediaGalleryItem({
    super.key,
    required this.imageUrl,
    required this.onZoomChanged,
  });

  @override
  State<MediaGalleryItem> createState() => _MediaGalleryItemState();
}

class _MediaGalleryItemState extends State<MediaGalleryItem> {
  late TransformationController _transformationController;
  int _pointerCount = 0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => setState(() => _pointerCount++),
      onPointerUp: (e) => setState(() => _pointerCount--),
      child: Container(
        color: Colors.black,
        // Fill the full screen via LayoutBuilder so InteractiveViewer
        // knows the exact viewport size for boundary clamping.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double viewportWidth = constraints.maxWidth;
            final double viewportHeight = constraints.maxHeight;

            return InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1.0,
              maxScale: 2.0,
              boundaryMargin: EdgeInsets.zero,
              constrained: false,
              clipBehavior: Clip.hardEdge,
              onInteractionUpdate: (details) {
                final double scale =
                _transformationController.value.getMaxScaleOnAxis();
                widget.onZoomChanged(scale > 1.1 || _pointerCount >= 2);
              },
              onInteractionEnd: (details) {
                final double scale =
                _transformationController.value.getMaxScaleOnAxis();
                if (scale <= 1.0) widget.onZoomChanged(false);
              },
              child: SizedBox(
                width: viewportWidth,
                height: viewportHeight,
                child: AppCachedImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}