import 'package:game_tracker/features/games/domain/entities/filter_entity.dart';
import 'package:isar_community/isar.dart';

part 'local_filter.g.dart';

@collection
class LocalFilter {
  Id id = Isar.autoIncrement;

  @Index()
  late String endpoint; // The API endpoint this filter belongs to (e.g., "platforms", "genres")

  late int filterId; // The ID from the API
  late String name;
  late String slug;

  FilterEntity toEntity() => FilterEntity(id: filterId, name: name, slug: slug);
}
