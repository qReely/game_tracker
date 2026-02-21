import 'package:game_tracker/core/domain/entities/company_entity.dart';
import 'package:game_tracker/core/domain/entities/genre_entity.dart';

class GameDetailEntity {
  final int id;
  final String name;
  final String description;
  final String? backgroundImage;
  final double rating; // RAWG user rating
  final int metacritic; // Critic Score (92)
  final String released; // "2024-10-24"
  final int playtime; // "45" hours
  final List<String> platforms;
  final List<GenreEntity> genres; // "Action RPG"
  final List<String> screenshots;
  // We map platform requirements: {'minimum': '...', 'recommended': '...'}
  final Map<String, String>? pcRequirements;
  // Info block data
  final String? website;
  final String? esrbRating;
  final List<CompanyEntity> developer;
  final List<CompanyEntity> publisher;

  const GameDetailEntity({
    required this.id,
    required this.name,
    required this.description,
    this.backgroundImage,
    required this.rating,
    required this.metacritic,
    required this.released,
    required this.playtime,
    required this.platforms,
    required this.genres,
    required this.screenshots,
    this.pcRequirements,
    this.website,
    this.esrbRating,
    required this.developer,
    required this.publisher,
  });
}