// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCategoriaCollection on Isar {
  IsarCollection<Categoria> get categorias => this.collection();
}

const CategoriaSchema = CollectionSchema(
  name: r'Categoria',
  id: 8566002696729659875,
  properties: {
    r'nombre': PropertySchema(
      id: 0,
      name: r'nombre',
      type: IsarType.string,
    )
  },
  estimateSize: _categoriaEstimateSize,
  serialize: _categoriaSerialize,
  deserialize: _categoriaDeserialize,
  deserializeProp: _categoriaDeserializeProp,
  idName: r'id',
  indexes: {
    r'nombre': IndexSchema(
      id: -8239814765453414572,
      name: r'nombre',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'nombre',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _categoriaGetId,
  getLinks: _categoriaGetLinks,
  attach: _categoriaAttach,
  version: '3.1.0+1',
);

int _categoriaEstimateSize(
  Categoria object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.nombre.length * 3;
  return bytesCount;
}

void _categoriaSerialize(
  Categoria object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.nombre);
}

Categoria _categoriaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Categoria();
  object.id = id;
  object.nombre = reader.readString(offsets[0]);
  return object;
}

P _categoriaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _categoriaGetId(Categoria object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _categoriaGetLinks(Categoria object) {
  return [];
}

void _categoriaAttach(IsarCollection<dynamic> col, Id id, Categoria object) {
  object.id = id;
}

extension CategoriaByIndex on IsarCollection<Categoria> {
  Future<Categoria?> getByNombre(String nombre) {
    return getByIndex(r'nombre', [nombre]);
  }

  Categoria? getByNombreSync(String nombre) {
    return getByIndexSync(r'nombre', [nombre]);
  }

  Future<bool> deleteByNombre(String nombre) {
    return deleteByIndex(r'nombre', [nombre]);
  }

  bool deleteByNombreSync(String nombre) {
    return deleteByIndexSync(r'nombre', [nombre]);
  }

  Future<List<Categoria?>> getAllByNombre(List<String> nombreValues) {
    final values = nombreValues.map((e) => [e]).toList();
    return getAllByIndex(r'nombre', values);
  }

  List<Categoria?> getAllByNombreSync(List<String> nombreValues) {
    final values = nombreValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'nombre', values);
  }

  Future<int> deleteAllByNombre(List<String> nombreValues) {
    final values = nombreValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'nombre', values);
  }

  int deleteAllByNombreSync(List<String> nombreValues) {
    final values = nombreValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'nombre', values);
  }

  Future<Id> putByNombre(Categoria object) {
    return putByIndex(r'nombre', object);
  }

  Id putByNombreSync(Categoria object, {bool saveLinks = true}) {
    return putByIndexSync(r'nombre', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNombre(List<Categoria> objects) {
    return putAllByIndex(r'nombre', objects);
  }

  List<Id> putAllByNombreSync(List<Categoria> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'nombre', objects, saveLinks: saveLinks);
  }
}

extension CategoriaQueryWhereSort
    on QueryBuilder<Categoria, Categoria, QWhere> {
  QueryBuilder<Categoria, Categoria, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategoriaQueryWhere
    on QueryBuilder<Categoria, Categoria, QWhereClause> {
  QueryBuilder<Categoria, Categoria, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Categoria, Categoria, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterWhereClause> idBetween(
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

  QueryBuilder<Categoria, Categoria, QAfterWhereClause> nombreEqualTo(
      String nombre) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nombre',
        value: [nombre],
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterWhereClause> nombreNotEqualTo(
      String nombre) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nombre',
              lower: [],
              upper: [nombre],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nombre',
              lower: [nombre],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nombre',
              lower: [nombre],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nombre',
              lower: [],
              upper: [nombre],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CategoriaQueryFilter
    on QueryBuilder<Categoria, Categoria, QFilterCondition> {
  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nombre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterFilterCondition> nombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nombre',
        value: '',
      ));
    });
  }
}

extension CategoriaQueryObject
    on QueryBuilder<Categoria, Categoria, QFilterCondition> {}

extension CategoriaQueryLinks
    on QueryBuilder<Categoria, Categoria, QFilterCondition> {}

extension CategoriaQuerySortBy on QueryBuilder<Categoria, Categoria, QSortBy> {
  QueryBuilder<Categoria, Categoria, QAfterSortBy> sortByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterSortBy> sortByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }
}

extension CategoriaQuerySortThenBy
    on QueryBuilder<Categoria, Categoria, QSortThenBy> {
  QueryBuilder<Categoria, Categoria, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterSortBy> thenByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<Categoria, Categoria, QAfterSortBy> thenByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }
}

extension CategoriaQueryWhereDistinct
    on QueryBuilder<Categoria, Categoria, QDistinct> {
  QueryBuilder<Categoria, Categoria, QDistinct> distinctByNombre(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nombre', caseSensitive: caseSensitive);
    });
  }
}

extension CategoriaQueryProperty
    on QueryBuilder<Categoria, Categoria, QQueryProperty> {
  QueryBuilder<Categoria, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Categoria, String, QQueryOperations> nombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nombre');
    });
  }
}
