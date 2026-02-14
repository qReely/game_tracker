import 'package:isar_community/isar.dart';

part 'cache_metadata.g.dart';

@collection
class CacheMetadata {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String cacheKey;

  late DateTime lastUpdated;
}