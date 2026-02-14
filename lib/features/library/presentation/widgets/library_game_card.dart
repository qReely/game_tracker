import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:go_router/go_router.dart';

class LibraryGameCard extends StatelessWidget {
  final LibraryItem item;
  const LibraryGameCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('game_details', pathParameters: {'id': item.gameId.toString()}),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: item.posterPath ?? '',
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
              ),
            ),
            // Status Tag
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.status.name.toUpperCase(),
                  style: TextStyle(color: item.status.color, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Bottom Info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)],
                    stops: const [0.6, 1.0],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.gameName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    if (item.userRating != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            item.userRating!.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}