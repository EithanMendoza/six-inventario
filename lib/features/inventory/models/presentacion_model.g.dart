// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentacion_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPresentacionCollection on Isar {
  IsarCollection<Presentacion> get presentacions => this.collection();
}

const PresentacionSchema = CollectionSchema(
  name: r'Presentacion',
  id: 2291059094600169492,
  properties: {
    r'tipo': PropertySchema(
      id: 0,
      name: r'tipo',
      type: IsarType.string,
    ),
    r'unidades': PropertySchema(
      id: 1,
      name: r'unidades',
      type: IsarType.long,
    )
  },
  estimateSize: _presentacionEstimateSize,
  serialize: _presentacionSerialize,
  deserialize: _presentacionDeserialize,
  deserializeProp: _presentacionDeserializeProp,
  idName: r'id',
  indexes: {
    r'tipo': IndexSchema(
      id: 3681353239984507137,
      name: r'tipo',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tipo',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _presentacionGetId,
  getLinks: _presentacionGetLinks,
  attach: _presentacionAttach,
  version: '3.1.0+1',
);

int _presentacionEstimateSize(
  Presentacion object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.tipo.length * 3;
  return bytesCount;
}

void _presentacionSerialize(
  Presentacion object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.tipo);
  writer.writeLong(offsets[1], object.unidades);
}

Presentacion _presentacionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Presentacion();
  object.id = id;
  object.tipo = reader.readString(offsets[0]);
  object.unidades = reader.readLong(offsets[1]);
  return object;
}

P _presentacionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _presentacionGetId(Presentacion object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _presentacionGetLinks(Presentacion object) {
  return [];
}

void _presentacionAttach(
    IsarCollection<dynamic> col, Id id, Presentacion object) {
  object.id = id;
}

extension PresentacionQueryWhereSort
    on QueryBuilder<Presentacion, Presentacion, QWhere> {
  QueryBuilder<Presentacion, Presentacion, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhere> anyTipo() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tipo'),
      );
    });
  }
}

extension PresentacionQueryWhere
    on QueryBuilder<Presentacion, Presentacion, QWhereClause> {
  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> tipoEqualTo(
      String tipo) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tipo',
        value: [tipo],
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> tipoNotEqualTo(
      String tipo) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tipo',
              lower: [],
              upper: [tipo],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tipo',
              lower: [tipo],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tipo',
              lower: [tipo],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tipo',
              lower: [],
              upper: [tipo],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> tipoGreaterThan(
    String tipo, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tipo',
        lower: [tipo],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> tipoLessThan(
    String tipo, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tipo',
        lower: [],
        upper: [tipo],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> tipoBetween(
    String lowerTipo,
    String upperTipo, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tipo',
        lower: [lowerTipo],
        includeLower: includeLower,
        upper: [upperTipo],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> tipoStartsWith(
      String TipoPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tipo',
        lower: [TipoPrefix],
        upper: ['$TipoPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> tipoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tipo',
        value: [''],
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterWhereClause> tipoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'tipo',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'tipo',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'tipo',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'tipo',
              upper: [''],
            ));
      }
    });
  }
}

extension PresentacionQueryFilter
    on QueryBuilder<Presentacion, Presentacion, QFilterCondition> {
  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> tipoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition>
      tipoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> tipoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> tipoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition>
      tipoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> tipoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> tipoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition> tipoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition>
      tipoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipo',
        value: '',
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition>
      tipoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipo',
        value: '',
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition>
      unidadesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unidades',
        value: value,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition>
      unidadesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unidades',
        value: value,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition>
      unidadesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unidades',
        value: value,
      ));
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterFilterCondition>
      unidadesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unidades',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PresentacionQueryObject
    on QueryBuilder<Presentacion, Presentacion, QFilterCondition> {}

extension PresentacionQueryLinks
    on QueryBuilder<Presentacion, Presentacion, QFilterCondition> {}

extension PresentacionQuerySortBy
    on QueryBuilder<Presentacion, Presentacion, QSortBy> {
  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> sortByTipo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.asc);
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> sortByTipoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.desc);
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> sortByUnidades() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unidades', Sort.asc);
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> sortByUnidadesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unidades', Sort.desc);
    });
  }
}

extension PresentacionQuerySortThenBy
    on QueryBuilder<Presentacion, Presentacion, QSortThenBy> {
  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> thenByTipo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.asc);
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> thenByTipoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.desc);
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> thenByUnidades() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unidades', Sort.asc);
    });
  }

  QueryBuilder<Presentacion, Presentacion, QAfterSortBy> thenByUnidadesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unidades', Sort.desc);
    });
  }
}

extension PresentacionQueryWhereDistinct
    on QueryBuilder<Presentacion, Presentacion, QDistinct> {
  QueryBuilder<Presentacion, Presentacion, QDistinct> distinctByTipo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Presentacion, Presentacion, QDistinct> distinctByUnidades() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unidades');
    });
  }
}

extension PresentacionQueryProperty
    on QueryBuilder<Presentacion, Presentacion, QQueryProperty> {
  QueryBuilder<Presentacion, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Presentacion, String, QQueryOperations> tipoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipo');
    });
  }

  QueryBuilder<Presentacion, int, QQueryOperations> unidadesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unidades');
    });
  }
}
