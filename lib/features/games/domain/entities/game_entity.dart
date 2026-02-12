class GameEntity {
  final int id;
  final String name;
  final String? backgroundImage;
  final double rating;

  const GameEntity({required this.id, required this.name, this.backgroundImage, required this.rating});
}