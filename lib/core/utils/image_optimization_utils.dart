import 'package:flutter/widgets.dart';

class ImageOptimizationUtils {
  /// Calculates optimal memCacheWidth based on viewport and columns.
  /// Default for a 2-column grid on mobile is ~400-500px.
  static int getOptimalMemCacheWidth(BuildContext context, {int crossAxisCount = 2}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    
    // Calculate the width of a single item in the grid
    final itemWidth = screenWidth / crossAxisCount;
    
    // Multiply by pixel ratio for high-density screens (retina/amoled)
    // We cap it to avoid excessively large decodes on tablets, but increased slightly for better quality on phones
    // Adding a 2.5x buffer to ensure sharpness even when scaled up slightly or on high-res displays
    return (itemWidth * devicePixelRatio * 2.5).toInt().clamp(200, 3000);
  }
}
