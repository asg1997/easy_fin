// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bases_database.dart';

// ignore_for_file: type=lint
class $BasesTable extends Bases with TableInfo<$BasesTable, BaseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bases';
  @override
  VerificationContext validateIntegrity(
    Insertable<BaseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BaseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BaseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $BasesTable createAlias(String alias) {
    return $BasesTable(attachedDatabase, alias);
  }
}

class BaseRow extends DataClass implements Insertable<BaseRow> {
  final String id;
  final String name;
  const BaseRow({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  BasesCompanion toCompanion(bool nullToAbsent) {
    return BasesCompanion(id: Value(id), name: Value(name));
  }

  factory BaseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BaseRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  BaseRow copyWith({String? id, String? name}) =>
      BaseRow(id: id ?? this.id, name: name ?? this.name);
  BaseRow copyWithCompanion(BasesCompanion data) {
    return BaseRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BaseRow(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaseRow && other.id == this.id && other.name == this.name);
}

class BasesCompanion extends UpdateCompanion<BaseRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const BasesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BasesCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<BaseRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BasesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return BasesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BasesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BaseAccountNumbersTable extends BaseAccountNumbers
    with TableInfo<$BaseAccountNumbersTable, BaseAccountNumber> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BaseAccountNumbersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _baseIdMeta = const VerificationMeta('baseId');
  @override
  late final GeneratedColumn<String> baseId = GeneratedColumn<String>(
    'base_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bases (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta(
    'accountNumber',
  );
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, baseId, accountNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'base_account_numbers';
  @override
  VerificationContext validateIntegrity(
    Insertable<BaseAccountNumber> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('base_id')) {
      context.handle(
        _baseIdMeta,
        baseId.isAcceptableOrUnknown(data['base_id']!, _baseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_baseIdMeta);
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(
          data['account_number']!,
          _accountNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BaseAccountNumber map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BaseAccountNumber(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      baseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_id'],
      )!,
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      )!,
    );
  }

  @override
  $BaseAccountNumbersTable createAlias(String alias) {
    return $BaseAccountNumbersTable(attachedDatabase, alias);
  }
}

class BaseAccountNumber extends DataClass
    implements Insertable<BaseAccountNumber> {
  final int id;
  final String baseId;
  final String accountNumber;
  const BaseAccountNumber({
    required this.id,
    required this.baseId,
    required this.accountNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base_id'] = Variable<String>(baseId);
    map['account_number'] = Variable<String>(accountNumber);
    return map;
  }

  BaseAccountNumbersCompanion toCompanion(bool nullToAbsent) {
    return BaseAccountNumbersCompanion(
      id: Value(id),
      baseId: Value(baseId),
      accountNumber: Value(accountNumber),
    );
  }

  factory BaseAccountNumber.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BaseAccountNumber(
      id: serializer.fromJson<int>(json['id']),
      baseId: serializer.fromJson<String>(json['baseId']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baseId': serializer.toJson<String>(baseId),
      'accountNumber': serializer.toJson<String>(accountNumber),
    };
  }

  BaseAccountNumber copyWith({
    int? id,
    String? baseId,
    String? accountNumber,
  }) => BaseAccountNumber(
    id: id ?? this.id,
    baseId: baseId ?? this.baseId,
    accountNumber: accountNumber ?? this.accountNumber,
  );
  BaseAccountNumber copyWithCompanion(BaseAccountNumbersCompanion data) {
    return BaseAccountNumber(
      id: data.id.present ? data.id.value : this.id,
      baseId: data.baseId.present ? data.baseId.value : this.baseId,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BaseAccountNumber(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('accountNumber: $accountNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, baseId, accountNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaseAccountNumber &&
          other.id == this.id &&
          other.baseId == this.baseId &&
          other.accountNumber == this.accountNumber);
}

class BaseAccountNumbersCompanion extends UpdateCompanion<BaseAccountNumber> {
  final Value<int> id;
  final Value<String> baseId;
  final Value<String> accountNumber;
  const BaseAccountNumbersCompanion({
    this.id = const Value.absent(),
    this.baseId = const Value.absent(),
    this.accountNumber = const Value.absent(),
  });
  BaseAccountNumbersCompanion.insert({
    this.id = const Value.absent(),
    required String baseId,
    required String accountNumber,
  }) : baseId = Value(baseId),
       accountNumber = Value(accountNumber);
  static Insertable<BaseAccountNumber> custom({
    Expression<int>? id,
    Expression<String>? baseId,
    Expression<String>? accountNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseId != null) 'base_id': baseId,
      if (accountNumber != null) 'account_number': accountNumber,
    });
  }

  BaseAccountNumbersCompanion copyWith({
    Value<int>? id,
    Value<String>? baseId,
    Value<String>? accountNumber,
  }) {
    return BaseAccountNumbersCompanion(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (baseId.present) {
      map['base_id'] = Variable<String>(baseId.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BaseAccountNumbersCompanion(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('accountNumber: $accountNumber')
          ..write(')'))
        .toString();
  }
}

abstract class _$BasesDatabase extends GeneratedDatabase {
  _$BasesDatabase(QueryExecutor e) : super(e);
  $BasesDatabaseManager get managers => $BasesDatabaseManager(this);
  late final $BasesTable bases = $BasesTable(this);
  late final $BaseAccountNumbersTable baseAccountNumbers =
      $BaseAccountNumbersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bases,
    baseAccountNumbers,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('base_account_numbers', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$BasesTableCreateCompanionBuilder =
    BasesCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$BasesTableUpdateCompanionBuilder =
    BasesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

final class $$BasesTableReferences
    extends BaseReferences<_$BasesDatabase, $BasesTable, BaseRow> {
  $$BasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BaseAccountNumbersTable, List<BaseAccountNumber>>
  _baseAccountNumbersRefsTable(_$BasesDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.baseAccountNumbers,
        aliasName: $_aliasNameGenerator(
          db.bases.id,
          db.baseAccountNumbers.baseId,
        ),
      );

  $$BaseAccountNumbersTableProcessedTableManager get baseAccountNumbersRefs {
    final manager = $$BaseAccountNumbersTableTableManager(
      $_db,
      $_db.baseAccountNumbers,
    ).filter((f) => f.baseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _baseAccountNumbersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BasesTableFilterComposer
    extends Composer<_$BasesDatabase, $BasesTable> {
  $$BasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> baseAccountNumbersRefs(
    Expression<bool> Function($$BaseAccountNumbersTableFilterComposer f) f,
  ) {
    final $$BaseAccountNumbersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.baseAccountNumbers,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BaseAccountNumbersTableFilterComposer(
            $db: $db,
            $table: $db.baseAccountNumbers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BasesTableOrderingComposer
    extends Composer<_$BasesDatabase, $BasesTable> {
  $$BasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BasesTableAnnotationComposer
    extends Composer<_$BasesDatabase, $BasesTable> {
  $$BasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> baseAccountNumbersRefs<T extends Object>(
    Expression<T> Function($$BaseAccountNumbersTableAnnotationComposer a) f,
  ) {
    final $$BaseAccountNumbersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.baseAccountNumbers,
          getReferencedColumn: (t) => t.baseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BaseAccountNumbersTableAnnotationComposer(
                $db: $db,
                $table: $db.baseAccountNumbers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BasesTableTableManager
    extends
        RootTableManager<
          _$BasesDatabase,
          $BasesTable,
          BaseRow,
          $$BasesTableFilterComposer,
          $$BasesTableOrderingComposer,
          $$BasesTableAnnotationComposer,
          $$BasesTableCreateCompanionBuilder,
          $$BasesTableUpdateCompanionBuilder,
          (BaseRow, $$BasesTableReferences),
          BaseRow,
          PrefetchHooks Function({bool baseAccountNumbersRefs})
        > {
  $$BasesTableTableManager(_$BasesDatabase db, $BasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BasesCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => BasesCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BasesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({baseAccountNumbersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (baseAccountNumbersRefs) db.baseAccountNumbers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (baseAccountNumbersRefs)
                    await $_getPrefetchedData<
                      BaseRow,
                      $BasesTable,
                      BaseAccountNumber
                    >(
                      currentTable: table,
                      referencedTable: $$BasesTableReferences
                          ._baseAccountNumbersRefsTable(db),
                      managerFromTypedResult: (p0) => $$BasesTableReferences(
                        db,
                        table,
                        p0,
                      ).baseAccountNumbersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.baseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BasesTableProcessedTableManager =
    ProcessedTableManager<
      _$BasesDatabase,
      $BasesTable,
      BaseRow,
      $$BasesTableFilterComposer,
      $$BasesTableOrderingComposer,
      $$BasesTableAnnotationComposer,
      $$BasesTableCreateCompanionBuilder,
      $$BasesTableUpdateCompanionBuilder,
      (BaseRow, $$BasesTableReferences),
      BaseRow,
      PrefetchHooks Function({bool baseAccountNumbersRefs})
    >;
typedef $$BaseAccountNumbersTableCreateCompanionBuilder =
    BaseAccountNumbersCompanion Function({
      Value<int> id,
      required String baseId,
      required String accountNumber,
    });
typedef $$BaseAccountNumbersTableUpdateCompanionBuilder =
    BaseAccountNumbersCompanion Function({
      Value<int> id,
      Value<String> baseId,
      Value<String> accountNumber,
    });

final class $$BaseAccountNumbersTableReferences
    extends
        BaseReferences<
          _$BasesDatabase,
          $BaseAccountNumbersTable,
          BaseAccountNumber
        > {
  $$BaseAccountNumbersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BasesTable _baseIdTable(_$BasesDatabase db) => db.bases.createAlias(
    $_aliasNameGenerator(db.baseAccountNumbers.baseId, db.bases.id),
  );

  $$BasesTableProcessedTableManager get baseId {
    final $_column = $_itemColumn<String>('base_id')!;

    final manager = $$BasesTableTableManager(
      $_db,
      $_db.bases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BaseAccountNumbersTableFilterComposer
    extends Composer<_$BasesDatabase, $BaseAccountNumbersTable> {
  $$BaseAccountNumbersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  $$BasesTableFilterComposer get baseId {
    final $$BasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseId,
      referencedTable: $db.bases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BasesTableFilterComposer(
            $db: $db,
            $table: $db.bases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BaseAccountNumbersTableOrderingComposer
    extends Composer<_$BasesDatabase, $BaseAccountNumbersTable> {
  $$BaseAccountNumbersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  $$BasesTableOrderingComposer get baseId {
    final $$BasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseId,
      referencedTable: $db.bases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BasesTableOrderingComposer(
            $db: $db,
            $table: $db.bases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BaseAccountNumbersTableAnnotationComposer
    extends Composer<_$BasesDatabase, $BaseAccountNumbersTable> {
  $$BaseAccountNumbersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  $$BasesTableAnnotationComposer get baseId {
    final $$BasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseId,
      referencedTable: $db.bases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BasesTableAnnotationComposer(
            $db: $db,
            $table: $db.bases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BaseAccountNumbersTableTableManager
    extends
        RootTableManager<
          _$BasesDatabase,
          $BaseAccountNumbersTable,
          BaseAccountNumber,
          $$BaseAccountNumbersTableFilterComposer,
          $$BaseAccountNumbersTableOrderingComposer,
          $$BaseAccountNumbersTableAnnotationComposer,
          $$BaseAccountNumbersTableCreateCompanionBuilder,
          $$BaseAccountNumbersTableUpdateCompanionBuilder,
          (BaseAccountNumber, $$BaseAccountNumbersTableReferences),
          BaseAccountNumber,
          PrefetchHooks Function({bool baseId})
        > {
  $$BaseAccountNumbersTableTableManager(
    _$BasesDatabase db,
    $BaseAccountNumbersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BaseAccountNumbersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BaseAccountNumbersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BaseAccountNumbersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> baseId = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
              }) => BaseAccountNumbersCompanion(
                id: id,
                baseId: baseId,
                accountNumber: accountNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String baseId,
                required String accountNumber,
              }) => BaseAccountNumbersCompanion.insert(
                id: id,
                baseId: baseId,
                accountNumber: accountNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BaseAccountNumbersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({baseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (baseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.baseId,
                                referencedTable:
                                    $$BaseAccountNumbersTableReferences
                                        ._baseIdTable(db),
                                referencedColumn:
                                    $$BaseAccountNumbersTableReferences
                                        ._baseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BaseAccountNumbersTableProcessedTableManager =
    ProcessedTableManager<
      _$BasesDatabase,
      $BaseAccountNumbersTable,
      BaseAccountNumber,
      $$BaseAccountNumbersTableFilterComposer,
      $$BaseAccountNumbersTableOrderingComposer,
      $$BaseAccountNumbersTableAnnotationComposer,
      $$BaseAccountNumbersTableCreateCompanionBuilder,
      $$BaseAccountNumbersTableUpdateCompanionBuilder,
      (BaseAccountNumber, $$BaseAccountNumbersTableReferences),
      BaseAccountNumber,
      PrefetchHooks Function({bool baseId})
    >;

class $BasesDatabaseManager {
  final _$BasesDatabase _db;
  $BasesDatabaseManager(this._db);
  $$BasesTableTableManager get bases =>
      $$BasesTableTableManager(_db, _db.bases);
  $$BaseAccountNumbersTableTableManager get baseAccountNumbers =>
      $$BaseAccountNumbersTableTableManager(_db, _db.baseAccountNumbers);
}
