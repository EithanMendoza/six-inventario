// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProductoCollection on Isar {
  IsarCollection<Producto> get productos => this.collection();
}

const ProductoSchema = CollectionSchema(
  name: r'Producto',
  id: -5697193943419826423,
  properties: {
    r'agrupacion': PropertySchema(
      id: 0,
      name: r'agrupacion',
      type: IsarType.byte,
      enumMap: _ProductoagrupacionEnumValueMap,
    ),
    r'cantidadFisica': PropertySchema(
      id: 1,
      name: r'cantidadFisica',
      type: IsarType.long,
    ),
    r'codigoBarras': PropertySchema(
      id: 2,
      name: r'codigoBarras',
      type: IsarType.string,
    ),
    r'conteoSistema': PropertySchema(
      id: 3,
      name: r'conteoSistema',
      type: IsarType.long,
    ),
    r'descripcion': PropertySchema(
      id: 4,
      name: r'descripcion',
      type: IsarType.string,
    )
  },
  estimateSize: _productoEstimateSize,
  serialize: _productoSerialize,
  deserialize: _productoDeserialize,
  deserializeProp: _productoDeserializeProp,
  idName: r'id',
  indexes: {
    r'codigoBarras': IndexSchema(
      id: -3747644888679166614,
      name: r'codigoBarras',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'codigoBarras',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'descripcion': IndexSchema(
      id: 6050674522552744632,
      name: r'descripcion',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'descripcion',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'categoria': LinkSchema(
      id: 4260610537036551431,
      name: r'categoria',
      target: r'Categoria',
      single: true,
    ),
    r'presentacion': LinkSchema(
      id: -3603726618808230208,
      name: r'presentacion',
      target: r'Presentacion',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _productoGetId,
  getLinks: _productoGetLinks,
  attach: _productoAttach,
  version: '3.1.0+1',
);

int _productoEstimateSize(
  Producto object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.codigoBarras.length * 3;
  bytesCount += 3 + object.descripcion.length * 3;
  return bytesCount;
}

void _productoSerialize(
  Producto object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.agrupacion.index);
  writer.writeLong(offsets[1], object.cantidadFisica);
  writer.writeString(offsets[2], object.codigoBarras);
  writer.writeLong(offsets[3], object.conteoSistema);
  writer.writeString(offsets[4], object.descripcion);
}

Producto _productoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Producto();
  object.agrupacion =
      _ProductoagrupacionValueEnumMap[reader.readByteOrNull(offsets[0])] ??
          TipoAgrupacion.cigarros10;
  object.cantidadFisica = reader.readLong(offsets[1]);
  object.codigoBarras = reader.readString(offsets[2]);
  object.conteoSistema = reader.readLong(offsets[3]);
  object.descripcion = reader.readString(offsets[4]);
  object.id = id;
  return object;
}

P _productoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_ProductoagrupacionValueEnumMap[reader.readByteOrNull(offset)] ??
          TipoAgrupacion.cigarros10) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ProductoagrupacionEnumValueMap = {
  'cigarros10': 0,
  'plancha24': 1,
  'caja12': 2,
  'caja20': 3,
  'docena': 4,
  'desconocido': 5,
};
const _ProductoagrupacionValueEnumMap = {
  0: TipoAgrupacion.cigarros10,
  1: TipoAgrupacion.plancha24,
  2: TipoAgrupacion.caja12,
  3: TipoAgrupacion.caja20,
  4: TipoAgrupacion.docena,
  5: TipoAgrupacion.desconocido,
};

Id _productoGetId(Producto object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _productoGetLinks(Producto object) {
  return [object.categoria, object.presentacion];
}

void _productoAttach(IsarCollection<dynamic> col, Id id, Producto object) {
  object.id = id;
  object.categoria
      .attach(col, col.isar.collection<Categoria>(), r'categoria', id);
  object.presentacion
      .attach(col, col.isar.collection<Presentacion>(), r'presentacion', id);
}

extension ProductoByIndex on IsarCollection<Producto> {
  Future<Producto?> getByCodigoBarras(String codigoBarras) {
    return getByIndex(r'codigoBarras', [codigoBarras]);
  }

  Producto? getByCodigoBarrasSync(String codigoBarras) {
    return getByIndexSync(r'codigoBarras', [codigoBarras]);
  }

  Future<bool> deleteByCodigoBarras(String codigoBarras) {
    return deleteByIndex(r'codigoBarras', [codigoBarras]);
  }

  bool deleteByCodigoBarrasSync(String codigoBarras) {
    return deleteByIndexSync(r'codigoBarras', [codigoBarras]);
  }

  Future<List<Producto?>> getAllByCodigoBarras(
      List<String> codigoBarrasValues) {
    final values = codigoBarrasValues.map((e) => [e]).toList();
    return getAllByIndex(r'codigoBarras', values);
  }

  List<Producto?> getAllByCodigoBarrasSync(List<String> codigoBarrasValues) {
    final values = codigoBarrasValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'codigoBarras', values);
  }

  Future<int> deleteAllByCodigoBarras(List<String> codigoBarrasValues) {
    final values = codigoBarrasValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'codigoBarras', values);
  }

  int deleteAllByCodigoBarrasSync(List<String> codigoBarrasValues) {
    final values = codigoBarrasValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'codigoBarras', values);
  }

  Future<Id> putByCodigoBarras(Producto object) {
    return putByIndex(r'codigoBarras', object);
  }

  Id putByCodigoBarrasSync(Producto object, {bool saveLinks = true}) {
    return putByIndexSync(r'codigoBarras', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCodigoBarras(List<Producto> objects) {
    return putAllByIndex(r'codigoBarras', objects);
  }

  List<Id> putAllByCodigoBarrasSync(List<Producto> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'codigoBarras', objects, saveLinks: saveLinks);
  }
}

extension ProductoQueryWhereSort on QueryBuilder<Producto, Producto, QWhere> {
  QueryBuilder<Producto, Producto, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProductoQueryWhere on QueryBuilder<Producto, Producto, QWhereClause> {
  QueryBuilder<Producto, Producto, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Producto, Producto, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Producto, Producto, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Producto, Producto, QAfterWhereClause> idBetween(
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

  QueryBuilder<Producto, Producto, QAfterWhereClause> codigoBarrasEqualTo(
      String codigoBarras) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'codigoBarras',
        value: [codigoBarras],
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterWhereClause> codigoBarrasNotEqualTo(
      String codigoBarras) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigoBarras',
              lower: [],
              upper: [codigoBarras],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigoBarras',
              lower: [codigoBarras],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigoBarras',
              lower: [codigoBarras],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigoBarras',
              lower: [],
              upper: [codigoBarras],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Producto, Producto, QAfterWhereClause> descripcionEqualTo(
      String descripcion) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'descripcion',
        value: [descripcion],
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterWhereClause> descripcionNotEqualTo(
      String descripcion) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'descripcion',
              lower: [],
              upper: [descripcion],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'descripcion',
              lower: [descripcion],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'descripcion',
              lower: [descripcion],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'descripcion',
              lower: [],
              upper: [descripcion],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ProductoQueryFilter
    on QueryBuilder<Producto, Producto, QFilterCondition> {
  QueryBuilder<Producto, Producto, QAfterFilterCondition> agrupacionEqualTo(
      TipoAgrupacion value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'agrupacion',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> agrupacionGreaterThan(
    TipoAgrupacion value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'agrupacion',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> agrupacionLessThan(
    TipoAgrupacion value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'agrupacion',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> agrupacionBetween(
    TipoAgrupacion lower,
    TipoAgrupacion upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'agrupacion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> cantidadFisicaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cantidadFisica',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition>
      cantidadFisicaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cantidadFisica',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition>
      cantidadFisicaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cantidadFisica',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> cantidadFisicaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cantidadFisica',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> codigoBarrasEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'codigoBarras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition>
      codigoBarrasGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'codigoBarras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> codigoBarrasLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'codigoBarras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> codigoBarrasBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'codigoBarras',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition>
      codigoBarrasStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'codigoBarras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> codigoBarrasEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'codigoBarras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> codigoBarrasContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'codigoBarras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> codigoBarrasMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'codigoBarras',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition>
      codigoBarrasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'codigoBarras',
        value: '',
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition>
      codigoBarrasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'codigoBarras',
        value: '',
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> conteoSistemaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'conteoSistema',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition>
      conteoSistemaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'conteoSistema',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> conteoSistemaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'conteoSistema',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> conteoSistemaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'conteoSistema',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> descripcionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descripcion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition>
      descripcionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descripcion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> descripcionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descripcion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> descripcionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descripcion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> descripcionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descripcion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> descripcionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descripcion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> descripcionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descripcion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> descripcionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descripcion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> descripcionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descripcion',
        value: '',
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition>
      descripcionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descripcion',
        value: '',
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Producto, Producto, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Producto, Producto, QAfterFilterCondition> idBetween(
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
}

extension ProductoQueryObject
    on QueryBuilder<Producto, Producto, QFilterCondition> {}

extension ProductoQueryLinks
    on QueryBuilder<Producto, Producto, QFilterCondition> {
  QueryBuilder<Producto, Producto, QAfterFilterCondition> categoria(
      FilterQuery<Categoria> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'categoria');
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> categoriaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'categoria', 0, true, 0, true);
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> presentacion(
      FilterQuery<Presentacion> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentacion');
    });
  }

  QueryBuilder<Producto, Producto, QAfterFilterCondition> presentacionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentacion', 0, true, 0, true);
    });
  }
}

extension ProductoQuerySortBy on QueryBuilder<Producto, Producto, QSortBy> {
  QueryBuilder<Producto, Producto, QAfterSortBy> sortByAgrupacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agrupacion', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> sortByAgrupacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agrupacion', Sort.desc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> sortByCantidadFisica() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidadFisica', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> sortByCantidadFisicaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidadFisica', Sort.desc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> sortByCodigoBarras() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigoBarras', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> sortByCodigoBarrasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigoBarras', Sort.desc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> sortByConteoSistema() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conteoSistema', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> sortByConteoSistemaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conteoSistema', Sort.desc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> sortByDescripcion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descripcion', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> sortByDescripcionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descripcion', Sort.desc);
    });
  }
}

extension ProductoQuerySortThenBy
    on QueryBuilder<Producto, Producto, QSortThenBy> {
  QueryBuilder<Producto, Producto, QAfterSortBy> thenByAgrupacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agrupacion', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByAgrupacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agrupacion', Sort.desc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByCantidadFisica() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidadFisica', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByCantidadFisicaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidadFisica', Sort.desc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByCodigoBarras() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigoBarras', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByCodigoBarrasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigoBarras', Sort.desc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByConteoSistema() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conteoSistema', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByConteoSistemaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conteoSistema', Sort.desc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByDescripcion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descripcion', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByDescripcionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descripcion', Sort.desc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Producto, Producto, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ProductoQueryWhereDistinct
    on QueryBuilder<Producto, Producto, QDistinct> {
  QueryBuilder<Producto, Producto, QDistinct> distinctByAgrupacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'agrupacion');
    });
  }

  QueryBuilder<Producto, Producto, QDistinct> distinctByCantidadFisica() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cantidadFisica');
    });
  }

  QueryBuilder<Producto, Producto, QDistinct> distinctByCodigoBarras(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'codigoBarras', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Producto, Producto, QDistinct> distinctByConteoSistema() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'conteoSistema');
    });
  }

  QueryBuilder<Producto, Producto, QDistinct> distinctByDescripcion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descripcion', caseSensitive: caseSensitive);
    });
  }
}

extension ProductoQueryProperty
    on QueryBuilder<Producto, Producto, QQueryProperty> {
  QueryBuilder<Producto, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Producto, TipoAgrupacion, QQueryOperations>
      agrupacionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'agrupacion');
    });
  }

  QueryBuilder<Producto, int, QQueryOperations> cantidadFisicaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cantidadFisica');
    });
  }

  QueryBuilder<Producto, String, QQueryOperations> codigoBarrasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'codigoBarras');
    });
  }

  QueryBuilder<Producto, int, QQueryOperations> conteoSistemaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'conteoSistema');
    });
  }

  QueryBuilder<Producto, String, QQueryOperations> descripcionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descripcion');
    });
  }
}
