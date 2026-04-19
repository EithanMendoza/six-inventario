// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_merma.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetItemMermaCollection on Isar {
  IsarCollection<ItemMerma> get itemMermas => this.collection();
}

const ItemMermaSchema = CollectionSchema(
  name: r'ItemMerma',
  id: -3040383945821149760,
  properties: {
    r'cantidad': PropertySchema(
      id: 0,
      name: r'cantidad',
      type: IsarType.long,
    )
  },
  estimateSize: _itemMermaEstimateSize,
  serialize: _itemMermaSerialize,
  deserialize: _itemMermaDeserialize,
  deserializeProp: _itemMermaDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'producto': LinkSchema(
      id: -2879385497821570925,
      name: r'producto',
      target: r'Producto',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _itemMermaGetId,
  getLinks: _itemMermaGetLinks,
  attach: _itemMermaAttach,
  version: '3.1.0+1',
);

int _itemMermaEstimateSize(
  ItemMerma object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _itemMermaSerialize(
  ItemMerma object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cantidad);
}

ItemMerma _itemMermaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ItemMerma(
    cantidad: reader.readLong(offsets[0]),
  );
  object.id = id;
  return object;
}

P _itemMermaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _itemMermaGetId(ItemMerma object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _itemMermaGetLinks(ItemMerma object) {
  return [object.producto];
}

void _itemMermaAttach(IsarCollection<dynamic> col, Id id, ItemMerma object) {
  object.id = id;
  object.producto.attach(col, col.isar.collection<Producto>(), r'producto', id);
}

extension ItemMermaQueryWhereSort
    on QueryBuilder<ItemMerma, ItemMerma, QWhere> {
  QueryBuilder<ItemMerma, ItemMerma, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ItemMermaQueryWhere
    on QueryBuilder<ItemMerma, ItemMerma, QWhereClause> {
  QueryBuilder<ItemMerma, ItemMerma, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ItemMerma, ItemMerma, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterWhereClause> idBetween(
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
}

extension ItemMermaQueryFilter
    on QueryBuilder<ItemMerma, ItemMerma, QFilterCondition> {
  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> cantidadEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cantidad',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> cantidadGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cantidad',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> cantidadLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cantidad',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> cantidadBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cantidad',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> idBetween(
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

extension ItemMermaQueryObject
    on QueryBuilder<ItemMerma, ItemMerma, QFilterCondition> {}

extension ItemMermaQueryLinks
    on QueryBuilder<ItemMerma, ItemMerma, QFilterCondition> {
  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> producto(
      FilterQuery<Producto> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'producto');
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterFilterCondition> productoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'producto', 0, true, 0, true);
    });
  }
}

extension ItemMermaQuerySortBy on QueryBuilder<ItemMerma, ItemMerma, QSortBy> {
  QueryBuilder<ItemMerma, ItemMerma, QAfterSortBy> sortByCantidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidad', Sort.asc);
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterSortBy> sortByCantidadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidad', Sort.desc);
    });
  }
}

extension ItemMermaQuerySortThenBy
    on QueryBuilder<ItemMerma, ItemMerma, QSortThenBy> {
  QueryBuilder<ItemMerma, ItemMerma, QAfterSortBy> thenByCantidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidad', Sort.asc);
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterSortBy> thenByCantidadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidad', Sort.desc);
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ItemMerma, ItemMerma, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ItemMermaQueryWhereDistinct
    on QueryBuilder<ItemMerma, ItemMerma, QDistinct> {
  QueryBuilder<ItemMerma, ItemMerma, QDistinct> distinctByCantidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cantidad');
    });
  }
}

extension ItemMermaQueryProperty
    on QueryBuilder<ItemMerma, ItemMerma, QQueryProperty> {
  QueryBuilder<ItemMerma, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ItemMerma, int, QQueryOperations> cantidadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cantidad');
    });
  }
}
