class FilterEntity {
  final int id;
  final String name;
  final String slug;

  const FilterEntity({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory FilterEntity.fromJson(Map<String, dynamic> json) {
    return FilterEntity(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }
}