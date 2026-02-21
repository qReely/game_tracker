class GameEntity {
  final int id;
  final String name;
  final String? backgroundImage;
  final double rating;
  final String? releasedYear;
  final String? releasedDate;

  const GameEntity({
    required this.id,
    required this.name,
    this.backgroundImage,
    required this.rating,
    this.releasedYear,
    this.releasedDate,
  });
}