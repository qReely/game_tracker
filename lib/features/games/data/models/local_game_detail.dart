import 'package:isar_community/isar.dart';

import '../../domain/entities/game_detail_entity.dart';

part 'local_game_detail.g.dart';

@collection
class LocalGameDetail {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int rawgId;

  late String name;
  late String description;
  String? backgroundImage;
  late double rating;
  late int metacritic;
  late String released;
  late int playtime;
  late List<String> platforms;
  late List<String> genres;
  late List<String> screenshots;
  String? esrbRating;
  String? website;
  String? developer;
  String? publisher;

  // Simplified storage for requirements
  String? minRequirements;
  String? recRequirements;

  GameDetailEntity toEntity() {
    return GameDetailEntity(
      id: rawgId,
      name: name,
      description: description,
      backgroundImage: backgroundImage,
      rating: rating,
      metacritic: metacritic,
      released: released,
      playtime: playtime,
      platforms: platforms,
      genres: genres,
      screenshots: screenshots,
      esrbRating: esrbRating,
      website: website,
      developer: developer,
      publisher: publisher,
      pcRequirements: minRequirements != null ? {
        'minimum': minRequirements!,
        'recommended': recRequirements ?? '',
      } : null,
    );
  }
}