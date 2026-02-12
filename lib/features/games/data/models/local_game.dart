import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:isar_community/isar.dart';


part 'local_game.g.dart';

@collection
class LocalGame {
  Id id = Isar.autoIncrement; // Isar internal ID

  @Index(unique: true, replace: true)
  late int rawgId; // The ID from the RAWG API

  late String name;
  String? backgroundImage;
  late double rating;

  // Converter to Domain Entity
  GameEntity toEntity() => GameEntity(id: rawgId, name: name, backgroundImage: backgroundImage, rating: rating);
}