class GenreEntity {
  final int id;
  final String name;
  final String slug;
  final String? imageBackground;

  const GenreEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.imageBackground,
  });

  factory GenreEntity.fromJson(Map<String, dynamic> json) {
    return GenreEntity(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      imageBackground: json['image_background'],
    );
  }
}
