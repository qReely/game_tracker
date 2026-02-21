import 'package:isar_community/isar.dart';
import 'package:game_tracker/core/domain/entities/company_entity.dart';
import 'package:game_tracker/core/domain/entities/genre_entity.dart';
import '../../domain/entities/game_detail_entity.dart';

part 'local_game_detail.g.dart';

@embedded
class LocalCompany {
  int? rawgId;
  String? name;
  String? slug;
}

@embedded
class LocalGenre {
  int? rawgId;
  String? name;
  String? slug;
  String? imageBackground;
}

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
  late List<LocalGenre> genres;
  late List<String> screenshots;
  String? esrbRating;
  String? website;
  late List<LocalCompany> developer;
  late List<LocalCompany> publisher;

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
      genres: genres.map((g) => GenreEntity(
        id: g.rawgId ?? 0,
        name: g.name ?? '',
        slug: g.slug ?? '',
        imageBackground: g.imageBackground,
      )).toList(),
      screenshots: screenshots,
      esrbRating: esrbRating,
      website: website,
      developer: developer.map((d) => CompanyEntity(
        id: d.rawgId ?? 0,
        name: d.name ?? '',
        slug: d.slug ?? '',
      )).toList(),
      publisher: publisher.map((p) => CompanyEntity(
        id: p.rawgId ?? 0,
        name: p.name ?? '',
        slug: p.slug ?? '',
      )).toList(),
      pcRequirements: minRequirements != null ? {
        'minimum': minRequirements!,
        'recommended': recRequirements ?? '',
      } : null,
    );
  }
}