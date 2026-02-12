import 'package:game_tracker/features/games/domain/entities/game_entity.dart';

abstract class GameRepository {
  Future<List<GameEntity>> getTrendingGames();
}