import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';

abstract class GameDetailsRepository {
  Future<GameDetailEntity?> getCachedGameDetails(int id);
  Future<GameDetailEntity> getGameDetails(int id);
  Future<List<GameEntity>> getGameSeries(int id);
}
