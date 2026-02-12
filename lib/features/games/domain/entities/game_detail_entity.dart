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
  final List<String> genres; // "Action RPG"
  final List<String> screenshots;
  // We map platform requirements: {'minimum': '...', 'recommended': '...'}
  final Map<String, String>? pcRequirements;
  // Info block data
  final String? website;
  final String? esrbRating;
  final String? developer;
  final String? publisher;

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
    this.developer,
    this.publisher,
  });
}