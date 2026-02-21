// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_game.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalGameCollection on Isar {
  IsarCollection<LocalGame> get localGames => this.collection();
}

const LocalGameSchema = CollectionSchema(
  name: r'LocalGame',
  id: -66848368087371061,
  properties: {
    r'backgroundImage': PropertySchema(
      id: 0,
      name: r'backgroundImage',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 1, name: r'name', type: IsarType.string),
    r'rating': PropertySchema(id: 2, name: r'rating', type: IsarType.double),
    r'rawgId': PropertySchema(id: 3, name: r'rawgId', type: IsarType.long),
    r'releasedDate': PropertySchema(
      id: 4,
      name: r'releasedDate',
      type: IsarType.string,
    ),
    r'releasedYear': PropertySchema(
      id: 5,
      name: r'releasedYear',
      type: IsarType.string,
    ),
  },

  estimateSize: _localGameEstimateSize,
  serialize: _localGameSerialize,
  deserialize: _localGameDeserialize,
  deserializeProp: _localGameDeserializeProp,
  idName: r'id',
  indexes: {
    r'rawgId': IndexSchema(
      id: 2032182402165228603,
      name: r'rawgId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'rawgId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _localGameGetId,
  getLinks: _localGameGetLinks,
  attach: _localGameAttach,
  version: '3.3.0',
);

int _localGameEstimateSize(
  LocalGame object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.backgroundImage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.releasedDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.releasedYear;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _localGameSerialize(
  LocalGame object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.backgroundImage);
  writer.writeString(offsets[1], object.name);
  writer.writeDouble(offsets[2], object.rating);
  writer.writeLong(offsets[3], object.rawgId);
  writer.writeString(offsets[4], object.releasedDate);
  writer.writeString(offsets[5], object.releasedYear);
}

LocalGame _localGameDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalGame();
  object.backgroundImage = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.name = reader.readString(offsets[1]);
  object.rating = reader.readDouble(offsets[2]);
  object.rawgId = reader.readLong(offsets[3]);
  object.releasedDate = reader.readStringOrNull(offsets[4]);
  object.releasedYear = reader.readStringOrNull(offsets[5]);
  return object;
}

P _localGameDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localGameGetId(LocalGame object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localGameGetLinks(LocalGame object) {
  return [];
}

void _localGameAttach(IsarCollection<dynamic> col, Id id, LocalGame object) {
  object.id = id;
}

extension LocalGameByIndex on IsarCollection<LocalGame> {
  Future<LocalGame?> getByRawgId(int rawgId) {
    return getByIndex(r'rawgId', [rawgId]);
  }

  LocalGame? getByRawgIdSync(int rawgId) {
    return getByIndexSync(r'rawgId', [rawgId]);
  }

  Future<bool> deleteByRawgId(int rawgId) {
    return deleteByIndex(r'rawgId', [rawgId]);
  }

  bool deleteByRawgIdSync(int rawgId) {
    return deleteByIndexSync(r'rawgId', [rawgId]);
  }

  Future<List<LocalGame?>> getAllByRawgId(List<int> rawgIdValues) {
    final values = rawgIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'rawgId', values);
  }

  List<LocalGame?> getAllByRawgIdSync(List<int> rawgIdValues) {
    final values = rawgIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'rawgId', values);
  }

  Future<int> deleteAllByRawgId(List<int> rawgIdValues) {
    final values = rawgIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'rawgId', values);
  }

  int deleteAllByRawgIdSync(List<int> rawgIdValues) {
    final values = rawgIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'rawgId', values);
  }

  Future<Id> putByRawgId(LocalGame object) {
    return putByIndex(r'rawgId', object);
  }

  Id putByRawgIdSync(LocalGame object, {bool saveLinks = true}) {
    return putByIndexSync(r'rawgId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRawgId(List<LocalGame> objects) {
    return putAllByIndex(r'rawgId', objects);
  }

  List<Id> putAllByRawgIdSync(
    List<LocalGame> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'rawgId', objects, saveLinks: saveLinks);
  }
}

extension LocalGameQueryWhereSort
    on QueryBuilder<LocalGame, LocalGame, QWhere> {
  QueryBuilder<LocalGame, LocalGame, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhere> anyRawgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'rawgId'),
      );
    });
  }
}

extension LocalGameQueryWhere
    on QueryBuilder<LocalGame, LocalGame, QWhereClause> {
  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> rawgIdEqualTo(
    int rawgId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'rawgId', value: [rawgId]),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> rawgIdNotEqualTo(
    int rawgId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'rawgId',
                lower: [],
                upper: [rawgId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'rawgId',
                lower: [rawgId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'rawgId',
                lower: [rawgId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'rawgId',
                lower: [],
                upper: [rawgId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> rawgIdGreaterThan(
    int rawgId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'rawgId',
          lower: [rawgId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> rawgIdLessThan(
    int rawgId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'rawgId',
          lower: [],
          upper: [rawgId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterWhereClause> rawgIdBetween(
    int lowerRawgId,
    int upperRawgId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'rawgId',
          lower: [lowerRawgId],
          includeLower: includeLower,
          upper: [upperRawgId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LocalGameQueryFilter
    on QueryBuilder<LocalGame, LocalGame, QFilterCondition> {
  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backgroundImage'),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backgroundImage'),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'backgroundImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundImage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'backgroundImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'backgroundImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'backgroundImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'backgroundImage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundImage', value: ''),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  backgroundImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'backgroundImage', value: ''),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> ratingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rating',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> ratingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rating',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> ratingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rating',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> ratingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rating',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> rawgIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rawgId', value: value),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> rawgIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rawgId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> rawgIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rawgId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> rawgIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rawgId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'releasedDate'),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'releasedDate'),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> releasedDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'releasedDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'releasedDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'releasedDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> releasedDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'releasedDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'releasedDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'releasedDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'releasedDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> releasedDateMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'releasedDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'releasedDate', value: ''),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'releasedDate', value: ''),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedYearIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'releasedYear'),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedYearIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'releasedYear'),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> releasedYearEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'releasedYear',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedYearGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'releasedYear',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedYearLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'releasedYear',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> releasedYearBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'releasedYear',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedYearStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'releasedYear',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedYearEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'releasedYear',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedYearContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'releasedYear',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition> releasedYearMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'releasedYear',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedYearIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'releasedYear', value: ''),
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterFilterCondition>
  releasedYearIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'releasedYear', value: ''),
      );
    });
  }
}

extension LocalGameQueryObject
    on QueryBuilder<LocalGame, LocalGame, QFilterCondition> {}

extension LocalGameQueryLinks
    on QueryBuilder<LocalGame, LocalGame, QFilterCondition> {}

extension LocalGameQuerySortBy on QueryBuilder<LocalGame, LocalGame, QSortBy> {
  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByBackgroundImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundImage', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByBackgroundImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundImage', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByRawgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawgId', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByRawgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawgId', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByReleasedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releasedDate', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByReleasedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releasedDate', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByReleasedYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releasedYear', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> sortByReleasedYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releasedYear', Sort.desc);
    });
  }
}

extension LocalGameQuerySortThenBy
    on QueryBuilder<LocalGame, LocalGame, QSortThenBy> {
  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByBackgroundImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundImage', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByBackgroundImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundImage', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByRawgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawgId', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByRawgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawgId', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByReleasedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releasedDate', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByReleasedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releasedDate', Sort.desc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByReleasedYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releasedYear', Sort.asc);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QAfterSortBy> thenByReleasedYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releasedYear', Sort.desc);
    });
  }
}

extension LocalGameQueryWhereDistinct
    on QueryBuilder<LocalGame, LocalGame, QDistinct> {
  QueryBuilder<LocalGame, LocalGame, QDistinct> distinctByBackgroundImage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'backgroundImage',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<LocalGame, LocalGame, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<LocalGame, LocalGame, QDistinct> distinctByRawgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawgId');
    });
  }

  QueryBuilder<LocalGame, LocalGame, QDistinct> distinctByReleasedDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'releasedDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalGame, LocalGame, QDistinct> distinctByReleasedYear({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'releasedYear', caseSensitive: caseSensitive);
    });
  }
}

extension LocalGameQueryProperty
    on QueryBuilder<LocalGame, LocalGame, QQueryProperty> {
  QueryBuilder<LocalGame, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalGame, String?, QQueryOperations> backgroundImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backgroundImage');
    });
  }

  QueryBuilder<LocalGame, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LocalGame, double, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<LocalGame, int, QQueryOperations> rawgIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawgId');
    });
  }

  QueryBuilder<LocalGame, String?, QQueryOperations> releasedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'releasedDate');
    });
  }

  QueryBuilder<LocalGame, String?, QQueryOperations> releasedYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'releasedYear');
    });
  }
}
