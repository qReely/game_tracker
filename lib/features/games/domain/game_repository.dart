import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';

abstract class GameRepository {
  Future<List<GameEntity>> getTrendingGames();
  Future<GameDetailEntity> getGameDetails(int id);
}