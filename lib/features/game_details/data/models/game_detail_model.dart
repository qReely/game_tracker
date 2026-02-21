import 'package:game_tracker/core/domain/entities/company_entity.dart';
import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/game_details/data/models/local_game_detail.dart';
import 'package:game_tracker/core/domain/entities/genre_entity.dart';

class GameDetailModel extends GameDetailEntity{
  const GameDetailModel({
    required super.id,
    required super.name,
    required super.description,
    super.backgroundImage,
    required super.rating,
    required super.metacritic,
    required super.released,
    required super.playtime,
    required super.platforms,
    required super.genres,
    required super.screenshots,
    super.esrbRating,
    super.website,
    required super.developer,
    required super.publisher,
    super.pcRequirements,
  });

  LocalGameDetail toLocal() {
    return LocalGameDetail()
      ..rawgId = id
      ..name = name
      ..description = description
      ..backgroundImage = backgroundImage
      ..rating = rating
      ..metacritic = metacritic
      ..released = released
      ..playtime = playtime
      ..platforms = platforms
      ..genres = genres.map((g) => LocalGenre()
        ..rawgId = g.id
        ..name = g.name
        ..slug = g.slug
        ..imageBackground = g.imageBackground
      ).toList()
      ..screenshots = screenshots
      ..minRequirements = pcRequirements?['minimum']
      ..website = website
      ..esrbRating = esrbRating
      ..developer = developer.map((d) => LocalCompany()
        ..rawgId = d.id
        ..name = d.name
        ..slug = d.slug
      ).toList()
      ..publisher = publisher.map((p) => LocalCompany()
        ..rawgId = p.id
        ..name = p.name
        ..slug = p.slug
      ).toList()
      ..recRequirements = pcRequirements?['recommended'];
  }

  factory GameDetailModel.fromJson(Map<String, dynamic> json, Map<String, dynamic> screenshotJson) {
    final List screens = screenshotJson['results'] ?? [];

    // Encapsulate the PC requirements logic here
    Map<String, String>? pcReqs;
    final platforms = json['platforms'] as List?;
    final pcData = platforms?.firstWhere(
          (p) => p['platform']['slug'] == 'pc',
      orElse: () => null,
    );

    if (pcData != null && pcData['requirements'] != null) {
      pcReqs = {
        'minimum': pcData['requirements']['minimum'] ?? '',
        'recommended': pcData['requirements']['recommended'] ?? '',
      };
    }

    final developersList = (json['developers'] as List?)
        ?.map((d) => CompanyEntity(
          id: d['id'],
          name: d['name'].toString(),
          slug: d['slug'].toString(),
        ))
        .toList() ?? [];

    final publishersList = (json['publishers'] as List?)
        ?.map((p) => CompanyEntity(
          id: p['id'],
          name: p['name'].toString(),
          slug: p['slug'].toString(),
        ))
        .toList() ?? [];

    return GameDetailModel(
      id: json['id'],
      name: json['name'],
      description: json['description_raw'] ?? json['description'] ?? '',
      backgroundImage: json['background_image'],
      rating: (json['rating'] as num).toDouble(),
      metacritic: json['metacritic'] ?? 0,
      released: json['released'] ?? 'TBA',
      playtime: json['playtime'] ?? 0,
      platforms: (json['platforms'] as List?)
          ?.map((p) => p['platform']['name'].toString())
          .toList() ?? [],
      genres: (json['genres'] as List?)
          ?.map((g) => GenreEntity.fromJson(g))
          .toList() ?? [],
      screenshots: screens.map((s) => s['image'].toString()).toList(),
      esrbRating: json['esrb_rating']?['name'],
      website: json['website'],
      developer: developersList,
      publisher: publishersList,
      pcRequirements: pcReqs,
    );
  }
}