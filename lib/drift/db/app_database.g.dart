// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

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

class $BankStatementsTable extends BankStatements
    with TableInfo<$BankStatementsTable, BankStatementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BankStatementsTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES base_account_numbers (account_number) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialBalanceMinorMeta =
      const VerificationMeta('initialBalanceMinor');
  @override
  late final GeneratedColumn<int> initialBalanceMinor = GeneratedColumn<int>(
    'initial_balance_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalBalanceMinorMeta = const VerificationMeta(
    'finalBalanceMinor',
  );
  @override
  late final GeneratedColumn<int> finalBalanceMinor = GeneratedColumn<int>(
    'final_balance_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseId,
    accountNumber,
    startDate,
    endDate,
    initialBalanceMinor,
    finalBalanceMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_statements';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankStatementRow> instance, {
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
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('initial_balance_minor')) {
      context.handle(
        _initialBalanceMinorMeta,
        initialBalanceMinor.isAcceptableOrUnknown(
          data['initial_balance_minor']!,
          _initialBalanceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialBalanceMinorMeta);
    }
    if (data.containsKey('final_balance_minor')) {
      context.handle(
        _finalBalanceMinorMeta,
        finalBalanceMinor.isAcceptableOrUnknown(
          data['final_balance_minor']!,
          _finalBalanceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_finalBalanceMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankStatementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankStatementRow(
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
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      initialBalanceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_balance_minor'],
      )!,
      finalBalanceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}final_balance_minor'],
      )!,
    );
  }

  @override
  $BankStatementsTable createAlias(String alias) {
    return $BankStatementsTable(attachedDatabase, alias);
  }
}

class BankStatementRow extends DataClass
    implements Insertable<BankStatementRow> {
  final int id;
  final String baseId;
  final String accountNumber;
  final DateTime startDate;
  final DateTime endDate;
  final int initialBalanceMinor;
  final int finalBalanceMinor;
  const BankStatementRow({
    required this.id,
    required this.baseId,
    required this.accountNumber,
    required this.startDate,
    required this.endDate,
    required this.initialBalanceMinor,
    required this.finalBalanceMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base_id'] = Variable<String>(baseId);
    map['account_number'] = Variable<String>(accountNumber);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['initial_balance_minor'] = Variable<int>(initialBalanceMinor);
    map['final_balance_minor'] = Variable<int>(finalBalanceMinor);
    return map;
  }

  BankStatementsCompanion toCompanion(bool nullToAbsent) {
    return BankStatementsCompanion(
      id: Value(id),
      baseId: Value(baseId),
      accountNumber: Value(accountNumber),
      startDate: Value(startDate),
      endDate: Value(endDate),
      initialBalanceMinor: Value(initialBalanceMinor),
      finalBalanceMinor: Value(finalBalanceMinor),
    );
  }

  factory BankStatementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankStatementRow(
      id: serializer.fromJson<int>(json['id']),
      baseId: serializer.fromJson<String>(json['baseId']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      initialBalanceMinor: serializer.fromJson<int>(
        json['initialBalanceMinor'],
      ),
      finalBalanceMinor: serializer.fromJson<int>(json['finalBalanceMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baseId': serializer.toJson<String>(baseId),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'initialBalanceMinor': serializer.toJson<int>(initialBalanceMinor),
      'finalBalanceMinor': serializer.toJson<int>(finalBalanceMinor),
    };
  }

  BankStatementRow copyWith({
    int? id,
    String? baseId,
    String? accountNumber,
    DateTime? startDate,
    DateTime? endDate,
    int? initialBalanceMinor,
    int? finalBalanceMinor,
  }) => BankStatementRow(
    id: id ?? this.id,
    baseId: baseId ?? this.baseId,
    accountNumber: accountNumber ?? this.accountNumber,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    initialBalanceMinor: initialBalanceMinor ?? this.initialBalanceMinor,
    finalBalanceMinor: finalBalanceMinor ?? this.finalBalanceMinor,
  );
  BankStatementRow copyWithCompanion(BankStatementsCompanion data) {
    return BankStatementRow(
      id: data.id.present ? data.id.value : this.id,
      baseId: data.baseId.present ? data.baseId.value : this.baseId,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      initialBalanceMinor: data.initialBalanceMinor.present
          ? data.initialBalanceMinor.value
          : this.initialBalanceMinor,
      finalBalanceMinor: data.finalBalanceMinor.present
          ? data.finalBalanceMinor.value
          : this.finalBalanceMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankStatementRow(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('initialBalanceMinor: $initialBalanceMinor, ')
          ..write('finalBalanceMinor: $finalBalanceMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baseId,
    accountNumber,
    startDate,
    endDate,
    initialBalanceMinor,
    finalBalanceMinor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankStatementRow &&
          other.id == this.id &&
          other.baseId == this.baseId &&
          other.accountNumber == this.accountNumber &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.initialBalanceMinor == this.initialBalanceMinor &&
          other.finalBalanceMinor == this.finalBalanceMinor);
}

class BankStatementsCompanion extends UpdateCompanion<BankStatementRow> {
  final Value<int> id;
  final Value<String> baseId;
  final Value<String> accountNumber;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> initialBalanceMinor;
  final Value<int> finalBalanceMinor;
  const BankStatementsCompanion({
    this.id = const Value.absent(),
    this.baseId = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.initialBalanceMinor = const Value.absent(),
    this.finalBalanceMinor = const Value.absent(),
  });
  BankStatementsCompanion.insert({
    this.id = const Value.absent(),
    required String baseId,
    required String accountNumber,
    required DateTime startDate,
    required DateTime endDate,
    required int initialBalanceMinor,
    required int finalBalanceMinor,
  }) : baseId = Value(baseId),
       accountNumber = Value(accountNumber),
       startDate = Value(startDate),
       endDate = Value(endDate),
       initialBalanceMinor = Value(initialBalanceMinor),
       finalBalanceMinor = Value(finalBalanceMinor);
  static Insertable<BankStatementRow> custom({
    Expression<int>? id,
    Expression<String>? baseId,
    Expression<String>? accountNumber,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? initialBalanceMinor,
    Expression<int>? finalBalanceMinor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseId != null) 'base_id': baseId,
      if (accountNumber != null) 'account_number': accountNumber,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (initialBalanceMinor != null)
        'initial_balance_minor': initialBalanceMinor,
      if (finalBalanceMinor != null) 'final_balance_minor': finalBalanceMinor,
    });
  }

  BankStatementsCompanion copyWith({
    Value<int>? id,
    Value<String>? baseId,
    Value<String>? accountNumber,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? initialBalanceMinor,
    Value<int>? finalBalanceMinor,
  }) {
    return BankStatementsCompanion(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      accountNumber: accountNumber ?? this.accountNumber,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      initialBalanceMinor: initialBalanceMinor ?? this.initialBalanceMinor,
      finalBalanceMinor: finalBalanceMinor ?? this.finalBalanceMinor,
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
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (initialBalanceMinor.present) {
      map['initial_balance_minor'] = Variable<int>(initialBalanceMinor.value);
    }
    if (finalBalanceMinor.present) {
      map['final_balance_minor'] = Variable<int>(finalBalanceMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BankStatementsCompanion(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('initialBalanceMinor: $initialBalanceMinor, ')
          ..write('finalBalanceMinor: $finalBalanceMinor')
          ..write(')'))
        .toString();
  }
}

class $BankStatementOperationsTable extends BankStatementOperations
    with TableInfo<$BankStatementOperationsTable, BankStatementOperationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BankStatementOperationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _statementIdMeta = const VerificationMeta(
    'statementId',
  );
  @override
  late final GeneratedColumn<int> statementId = GeneratedColumn<int>(
    'statement_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bank_statements (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debitInnMeta = const VerificationMeta(
    'debitInn',
  );
  @override
  late final GeneratedColumn<String> debitInn = GeneratedColumn<String>(
    'debit_inn',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debitBankAccountMeta = const VerificationMeta(
    'debitBankAccount',
  );
  @override
  late final GeneratedColumn<String> debitBankAccount = GeneratedColumn<String>(
    'debit_bank_account',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditInnMeta = const VerificationMeta(
    'creditInn',
  );
  @override
  late final GeneratedColumn<String> creditInn = GeneratedColumn<String>(
    'credit_inn',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditBankAccountMeta = const VerificationMeta(
    'creditBankAccount',
  );
  @override
  late final GeneratedColumn<String> creditBankAccount =
      GeneratedColumn<String>(
        'credit_bank_account',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _debitMinorMeta = const VerificationMeta(
    'debitMinor',
  );
  @override
  late final GeneratedColumn<int> debitMinor = GeneratedColumn<int>(
    'debit_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creditMinorMeta = const VerificationMeta(
    'creditMinor',
  );
  @override
  late final GeneratedColumn<int> creditMinor = GeneratedColumn<int>(
    'credit_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    statementId,
    date,
    debitInn,
    debitBankAccount,
    creditInn,
    creditBankAccount,
    debitMinor,
    creditMinor,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_statement_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankStatementOperationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('statement_id')) {
      context.handle(
        _statementIdMeta,
        statementId.isAcceptableOrUnknown(
          data['statement_id']!,
          _statementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statementIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('debit_inn')) {
      context.handle(
        _debitInnMeta,
        debitInn.isAcceptableOrUnknown(data['debit_inn']!, _debitInnMeta),
      );
    } else if (isInserting) {
      context.missing(_debitInnMeta);
    }
    if (data.containsKey('debit_bank_account')) {
      context.handle(
        _debitBankAccountMeta,
        debitBankAccount.isAcceptableOrUnknown(
          data['debit_bank_account']!,
          _debitBankAccountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_debitBankAccountMeta);
    }
    if (data.containsKey('credit_inn')) {
      context.handle(
        _creditInnMeta,
        creditInn.isAcceptableOrUnknown(data['credit_inn']!, _creditInnMeta),
      );
    } else if (isInserting) {
      context.missing(_creditInnMeta);
    }
    if (data.containsKey('credit_bank_account')) {
      context.handle(
        _creditBankAccountMeta,
        creditBankAccount.isAcceptableOrUnknown(
          data['credit_bank_account']!,
          _creditBankAccountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditBankAccountMeta);
    }
    if (data.containsKey('debit_minor')) {
      context.handle(
        _debitMinorMeta,
        debitMinor.isAcceptableOrUnknown(data['debit_minor']!, _debitMinorMeta),
      );
    }
    if (data.containsKey('credit_minor')) {
      context.handle(
        _creditMinorMeta,
        creditMinor.isAcceptableOrUnknown(
          data['credit_minor']!,
          _creditMinorMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankStatementOperationRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankStatementOperationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      statementId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}statement_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      debitInn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}debit_inn'],
      )!,
      debitBankAccount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}debit_bank_account'],
      )!,
      creditInn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}credit_inn'],
      )!,
      creditBankAccount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}credit_bank_account'],
      )!,
      debitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debit_minor'],
      ),
      creditMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_minor'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $BankStatementOperationsTable createAlias(String alias) {
    return $BankStatementOperationsTable(attachedDatabase, alias);
  }
}

class BankStatementOperationRow extends DataClass
    implements Insertable<BankStatementOperationRow> {
  final int id;
  final int statementId;
  final DateTime date;
  final String debitInn;
  final String debitBankAccount;
  final String creditInn;
  final String creditBankAccount;
  final int? debitMinor;
  final int? creditMinor;
  final String note;
  const BankStatementOperationRow({
    required this.id,
    required this.statementId,
    required this.date,
    required this.debitInn,
    required this.debitBankAccount,
    required this.creditInn,
    required this.creditBankAccount,
    this.debitMinor,
    this.creditMinor,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['statement_id'] = Variable<int>(statementId);
    map['date'] = Variable<DateTime>(date);
    map['debit_inn'] = Variable<String>(debitInn);
    map['debit_bank_account'] = Variable<String>(debitBankAccount);
    map['credit_inn'] = Variable<String>(creditInn);
    map['credit_bank_account'] = Variable<String>(creditBankAccount);
    if (!nullToAbsent || debitMinor != null) {
      map['debit_minor'] = Variable<int>(debitMinor);
    }
    if (!nullToAbsent || creditMinor != null) {
      map['credit_minor'] = Variable<int>(creditMinor);
    }
    map['note'] = Variable<String>(note);
    return map;
  }

  BankStatementOperationsCompanion toCompanion(bool nullToAbsent) {
    return BankStatementOperationsCompanion(
      id: Value(id),
      statementId: Value(statementId),
      date: Value(date),
      debitInn: Value(debitInn),
      debitBankAccount: Value(debitBankAccount),
      creditInn: Value(creditInn),
      creditBankAccount: Value(creditBankAccount),
      debitMinor: debitMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(debitMinor),
      creditMinor: creditMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(creditMinor),
      note: Value(note),
    );
  }

  factory BankStatementOperationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankStatementOperationRow(
      id: serializer.fromJson<int>(json['id']),
      statementId: serializer.fromJson<int>(json['statementId']),
      date: serializer.fromJson<DateTime>(json['date']),
      debitInn: serializer.fromJson<String>(json['debitInn']),
      debitBankAccount: serializer.fromJson<String>(json['debitBankAccount']),
      creditInn: serializer.fromJson<String>(json['creditInn']),
      creditBankAccount: serializer.fromJson<String>(json['creditBankAccount']),
      debitMinor: serializer.fromJson<int?>(json['debitMinor']),
      creditMinor: serializer.fromJson<int?>(json['creditMinor']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'statementId': serializer.toJson<int>(statementId),
      'date': serializer.toJson<DateTime>(date),
      'debitInn': serializer.toJson<String>(debitInn),
      'debitBankAccount': serializer.toJson<String>(debitBankAccount),
      'creditInn': serializer.toJson<String>(creditInn),
      'creditBankAccount': serializer.toJson<String>(creditBankAccount),
      'debitMinor': serializer.toJson<int?>(debitMinor),
      'creditMinor': serializer.toJson<int?>(creditMinor),
      'note': serializer.toJson<String>(note),
    };
  }

  BankStatementOperationRow copyWith({
    int? id,
    int? statementId,
    DateTime? date,
    String? debitInn,
    String? debitBankAccount,
    String? creditInn,
    String? creditBankAccount,
    Value<int?> debitMinor = const Value.absent(),
    Value<int?> creditMinor = const Value.absent(),
    String? note,
  }) => BankStatementOperationRow(
    id: id ?? this.id,
    statementId: statementId ?? this.statementId,
    date: date ?? this.date,
    debitInn: debitInn ?? this.debitInn,
    debitBankAccount: debitBankAccount ?? this.debitBankAccount,
    creditInn: creditInn ?? this.creditInn,
    creditBankAccount: creditBankAccount ?? this.creditBankAccount,
    debitMinor: debitMinor.present ? debitMinor.value : this.debitMinor,
    creditMinor: creditMinor.present ? creditMinor.value : this.creditMinor,
    note: note ?? this.note,
  );
  BankStatementOperationRow copyWithCompanion(
    BankStatementOperationsCompanion data,
  ) {
    return BankStatementOperationRow(
      id: data.id.present ? data.id.value : this.id,
      statementId: data.statementId.present
          ? data.statementId.value
          : this.statementId,
      date: data.date.present ? data.date.value : this.date,
      debitInn: data.debitInn.present ? data.debitInn.value : this.debitInn,
      debitBankAccount: data.debitBankAccount.present
          ? data.debitBankAccount.value
          : this.debitBankAccount,
      creditInn: data.creditInn.present ? data.creditInn.value : this.creditInn,
      creditBankAccount: data.creditBankAccount.present
          ? data.creditBankAccount.value
          : this.creditBankAccount,
      debitMinor: data.debitMinor.present
          ? data.debitMinor.value
          : this.debitMinor,
      creditMinor: data.creditMinor.present
          ? data.creditMinor.value
          : this.creditMinor,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankStatementOperationRow(')
          ..write('id: $id, ')
          ..write('statementId: $statementId, ')
          ..write('date: $date, ')
          ..write('debitInn: $debitInn, ')
          ..write('debitBankAccount: $debitBankAccount, ')
          ..write('creditInn: $creditInn, ')
          ..write('creditBankAccount: $creditBankAccount, ')
          ..write('debitMinor: $debitMinor, ')
          ..write('creditMinor: $creditMinor, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    statementId,
    date,
    debitInn,
    debitBankAccount,
    creditInn,
    creditBankAccount,
    debitMinor,
    creditMinor,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankStatementOperationRow &&
          other.id == this.id &&
          other.statementId == this.statementId &&
          other.date == this.date &&
          other.debitInn == this.debitInn &&
          other.debitBankAccount == this.debitBankAccount &&
          other.creditInn == this.creditInn &&
          other.creditBankAccount == this.creditBankAccount &&
          other.debitMinor == this.debitMinor &&
          other.creditMinor == this.creditMinor &&
          other.note == this.note);
}

class BankStatementOperationsCompanion
    extends UpdateCompanion<BankStatementOperationRow> {
  final Value<int> id;
  final Value<int> statementId;
  final Value<DateTime> date;
  final Value<String> debitInn;
  final Value<String> debitBankAccount;
  final Value<String> creditInn;
  final Value<String> creditBankAccount;
  final Value<int?> debitMinor;
  final Value<int?> creditMinor;
  final Value<String> note;
  const BankStatementOperationsCompanion({
    this.id = const Value.absent(),
    this.statementId = const Value.absent(),
    this.date = const Value.absent(),
    this.debitInn = const Value.absent(),
    this.debitBankAccount = const Value.absent(),
    this.creditInn = const Value.absent(),
    this.creditBankAccount = const Value.absent(),
    this.debitMinor = const Value.absent(),
    this.creditMinor = const Value.absent(),
    this.note = const Value.absent(),
  });
  BankStatementOperationsCompanion.insert({
    this.id = const Value.absent(),
    required int statementId,
    required DateTime date,
    required String debitInn,
    required String debitBankAccount,
    required String creditInn,
    required String creditBankAccount,
    this.debitMinor = const Value.absent(),
    this.creditMinor = const Value.absent(),
    required String note,
  }) : statementId = Value(statementId),
       date = Value(date),
       debitInn = Value(debitInn),
       debitBankAccount = Value(debitBankAccount),
       creditInn = Value(creditInn),
       creditBankAccount = Value(creditBankAccount),
       note = Value(note);
  static Insertable<BankStatementOperationRow> custom({
    Expression<int>? id,
    Expression<int>? statementId,
    Expression<DateTime>? date,
    Expression<String>? debitInn,
    Expression<String>? debitBankAccount,
    Expression<String>? creditInn,
    Expression<String>? creditBankAccount,
    Expression<int>? debitMinor,
    Expression<int>? creditMinor,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (statementId != null) 'statement_id': statementId,
      if (date != null) 'date': date,
      if (debitInn != null) 'debit_inn': debitInn,
      if (debitBankAccount != null) 'debit_bank_account': debitBankAccount,
      if (creditInn != null) 'credit_inn': creditInn,
      if (creditBankAccount != null) 'credit_bank_account': creditBankAccount,
      if (debitMinor != null) 'debit_minor': debitMinor,
      if (creditMinor != null) 'credit_minor': creditMinor,
      if (note != null) 'note': note,
    });
  }

  BankStatementOperationsCompanion copyWith({
    Value<int>? id,
    Value<int>? statementId,
    Value<DateTime>? date,
    Value<String>? debitInn,
    Value<String>? debitBankAccount,
    Value<String>? creditInn,
    Value<String>? creditBankAccount,
    Value<int?>? debitMinor,
    Value<int?>? creditMinor,
    Value<String>? note,
  }) {
    return BankStatementOperationsCompanion(
      id: id ?? this.id,
      statementId: statementId ?? this.statementId,
      date: date ?? this.date,
      debitInn: debitInn ?? this.debitInn,
      debitBankAccount: debitBankAccount ?? this.debitBankAccount,
      creditInn: creditInn ?? this.creditInn,
      creditBankAccount: creditBankAccount ?? this.creditBankAccount,
      debitMinor: debitMinor ?? this.debitMinor,
      creditMinor: creditMinor ?? this.creditMinor,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (statementId.present) {
      map['statement_id'] = Variable<int>(statementId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (debitInn.present) {
      map['debit_inn'] = Variable<String>(debitInn.value);
    }
    if (debitBankAccount.present) {
      map['debit_bank_account'] = Variable<String>(debitBankAccount.value);
    }
    if (creditInn.present) {
      map['credit_inn'] = Variable<String>(creditInn.value);
    }
    if (creditBankAccount.present) {
      map['credit_bank_account'] = Variable<String>(creditBankAccount.value);
    }
    if (debitMinor.present) {
      map['debit_minor'] = Variable<int>(debitMinor.value);
    }
    if (creditMinor.present) {
      map['credit_minor'] = Variable<int>(creditMinor.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BankStatementOperationsCompanion(')
          ..write('id: $id, ')
          ..write('statementId: $statementId, ')
          ..write('date: $date, ')
          ..write('debitInn: $debitInn, ')
          ..write('debitBankAccount: $debitBankAccount, ')
          ..write('creditInn: $creditInn, ')
          ..write('creditBankAccount: $creditBankAccount, ')
          ..write('debitMinor: $debitMinor, ')
          ..write('creditMinor: $creditMinor, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BasesTable bases = $BasesTable(this);
  late final $BaseAccountNumbersTable baseAccountNumbers =
      $BaseAccountNumbersTable(this);
  late final $BankStatementsTable bankStatements = $BankStatementsTable(this);
  late final $BankStatementOperationsTable bankStatementOperations =
      $BankStatementOperationsTable(this);
  late final Index bankStatementsAccountPeriod = Index(
    'bank_statements_account_period',
    'CREATE UNIQUE INDEX bank_statements_account_period ON bank_statements (account_number, start_date, end_date)',
  );
  late final Index bankStatementsBaseStartDate = Index(
    'bank_statements_base_start_date',
    'CREATE INDEX bank_statements_base_start_date ON bank_statements (base_id, start_date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bases,
    baseAccountNumbers,
    bankStatements,
    bankStatementOperations,
    bankStatementsAccountPeriod,
    bankStatementsBaseStartDate,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bank_statements', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bank_statements',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('bank_statement_operations', kind: UpdateKind.delete),
      ],
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
    extends BaseReferences<_$AppDatabase, $BasesTable, BaseRow> {
  $$BasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BaseAccountNumbersTable, List<BaseAccountNumber>>
  _baseAccountNumbersRefsTable(_$AppDatabase db) =>
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

  static MultiTypedResultKey<$BankStatementsTable, List<BankStatementRow>>
  _bankStatementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bankStatements,
    aliasName: $_aliasNameGenerator(db.bases.id, db.bankStatements.baseId),
  );

  $$BankStatementsTableProcessedTableManager get bankStatementsRefs {
    final manager = $$BankStatementsTableTableManager(
      $_db,
      $_db.bankStatements,
    ).filter((f) => f.baseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bankStatementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BasesTableFilterComposer extends Composer<_$AppDatabase, $BasesTable> {
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

  Expression<bool> bankStatementsRefs(
    Expression<bool> Function($$BankStatementsTableFilterComposer f) f,
  ) {
    final $$BankStatementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankStatements,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankStatementsTableFilterComposer(
            $db: $db,
            $table: $db.bankStatements,
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
    extends Composer<_$AppDatabase, $BasesTable> {
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
    extends Composer<_$AppDatabase, $BasesTable> {
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

  Expression<T> bankStatementsRefs<T extends Object>(
    Expression<T> Function($$BankStatementsTableAnnotationComposer a) f,
  ) {
    final $$BankStatementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankStatements,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankStatementsTableAnnotationComposer(
            $db: $db,
            $table: $db.bankStatements,
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
          _$AppDatabase,
          $BasesTable,
          BaseRow,
          $$BasesTableFilterComposer,
          $$BasesTableOrderingComposer,
          $$BasesTableAnnotationComposer,
          $$BasesTableCreateCompanionBuilder,
          $$BasesTableUpdateCompanionBuilder,
          (BaseRow, $$BasesTableReferences),
          BaseRow,
          PrefetchHooks Function({
            bool baseAccountNumbersRefs,
            bool bankStatementsRefs,
          })
        > {
  $$BasesTableTableManager(_$AppDatabase db, $BasesTable table)
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
          prefetchHooksCallback:
              ({baseAccountNumbersRefs = false, bankStatementsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (baseAccountNumbersRefs) db.baseAccountNumbers,
                    if (bankStatementsRefs) db.bankStatements,
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
                          managerFromTypedResult: (p0) =>
                              $$BasesTableReferences(
                                db,
                                table,
                                p0,
                              ).baseAccountNumbersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.baseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bankStatementsRefs)
                        await $_getPrefetchedData<
                          BaseRow,
                          $BasesTable,
                          BankStatementRow
                        >(
                          currentTable: table,
                          referencedTable: $$BasesTableReferences
                              ._bankStatementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BasesTableReferences(
                                db,
                                table,
                                p0,
                              ).bankStatementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.baseId == item.id,
                              ),
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
      _$AppDatabase,
      $BasesTable,
      BaseRow,
      $$BasesTableFilterComposer,
      $$BasesTableOrderingComposer,
      $$BasesTableAnnotationComposer,
      $$BasesTableCreateCompanionBuilder,
      $$BasesTableUpdateCompanionBuilder,
      (BaseRow, $$BasesTableReferences),
      BaseRow,
      PrefetchHooks Function({
        bool baseAccountNumbersRefs,
        bool bankStatementsRefs,
      })
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
          _$AppDatabase,
          $BaseAccountNumbersTable,
          BaseAccountNumber
        > {
  $$BaseAccountNumbersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BasesTable _baseIdTable(_$AppDatabase db) => db.bases.createAlias(
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

  static MultiTypedResultKey<$BankStatementsTable, List<BankStatementRow>>
  _bankStatementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bankStatements,
    aliasName: $_aliasNameGenerator(
      db.baseAccountNumbers.accountNumber,
      db.bankStatements.accountNumber,
    ),
  );

  $$BankStatementsTableProcessedTableManager get bankStatementsRefs {
    final manager = $$BankStatementsTableTableManager($_db, $_db.bankStatements)
        .filter(
          (f) => f.accountNumber.accountNumber.sqlEquals(
            $_itemColumn<String>('account_number')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_bankStatementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BaseAccountNumbersTableFilterComposer
    extends Composer<_$AppDatabase, $BaseAccountNumbersTable> {
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

  Expression<bool> bankStatementsRefs(
    Expression<bool> Function($$BankStatementsTableFilterComposer f) f,
  ) {
    final $$BankStatementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountNumber,
      referencedTable: $db.bankStatements,
      getReferencedColumn: (t) => t.accountNumber,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankStatementsTableFilterComposer(
            $db: $db,
            $table: $db.bankStatements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BaseAccountNumbersTableOrderingComposer
    extends Composer<_$AppDatabase, $BaseAccountNumbersTable> {
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
    extends Composer<_$AppDatabase, $BaseAccountNumbersTable> {
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

  Expression<T> bankStatementsRefs<T extends Object>(
    Expression<T> Function($$BankStatementsTableAnnotationComposer a) f,
  ) {
    final $$BankStatementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountNumber,
      referencedTable: $db.bankStatements,
      getReferencedColumn: (t) => t.accountNumber,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankStatementsTableAnnotationComposer(
            $db: $db,
            $table: $db.bankStatements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BaseAccountNumbersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BaseAccountNumbersTable,
          BaseAccountNumber,
          $$BaseAccountNumbersTableFilterComposer,
          $$BaseAccountNumbersTableOrderingComposer,
          $$BaseAccountNumbersTableAnnotationComposer,
          $$BaseAccountNumbersTableCreateCompanionBuilder,
          $$BaseAccountNumbersTableUpdateCompanionBuilder,
          (BaseAccountNumber, $$BaseAccountNumbersTableReferences),
          BaseAccountNumber,
          PrefetchHooks Function({bool baseId, bool bankStatementsRefs})
        > {
  $$BaseAccountNumbersTableTableManager(
    _$AppDatabase db,
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
          prefetchHooksCallback:
              ({baseId = false, bankStatementsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bankStatementsRefs) db.bankStatements,
                  ],
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
                    return [
                      if (bankStatementsRefs)
                        await $_getPrefetchedData<
                          BaseAccountNumber,
                          $BaseAccountNumbersTable,
                          BankStatementRow
                        >(
                          currentTable: table,
                          referencedTable: $$BaseAccountNumbersTableReferences
                              ._bankStatementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BaseAccountNumbersTableReferences(
                                db,
                                table,
                                p0,
                              ).bankStatementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountNumber == item.accountNumber,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BaseAccountNumbersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BaseAccountNumbersTable,
      BaseAccountNumber,
      $$BaseAccountNumbersTableFilterComposer,
      $$BaseAccountNumbersTableOrderingComposer,
      $$BaseAccountNumbersTableAnnotationComposer,
      $$BaseAccountNumbersTableCreateCompanionBuilder,
      $$BaseAccountNumbersTableUpdateCompanionBuilder,
      (BaseAccountNumber, $$BaseAccountNumbersTableReferences),
      BaseAccountNumber,
      PrefetchHooks Function({bool baseId, bool bankStatementsRefs})
    >;
typedef $$BankStatementsTableCreateCompanionBuilder =
    BankStatementsCompanion Function({
      Value<int> id,
      required String baseId,
      required String accountNumber,
      required DateTime startDate,
      required DateTime endDate,
      required int initialBalanceMinor,
      required int finalBalanceMinor,
    });
typedef $$BankStatementsTableUpdateCompanionBuilder =
    BankStatementsCompanion Function({
      Value<int> id,
      Value<String> baseId,
      Value<String> accountNumber,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> initialBalanceMinor,
      Value<int> finalBalanceMinor,
    });

final class $$BankStatementsTableReferences
    extends
        BaseReferences<_$AppDatabase, $BankStatementsTable, BankStatementRow> {
  $$BankStatementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BasesTable _baseIdTable(_$AppDatabase db) => db.bases.createAlias(
    $_aliasNameGenerator(db.bankStatements.baseId, db.bases.id),
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

  static $BaseAccountNumbersTable _accountNumberTable(_$AppDatabase db) =>
      db.baseAccountNumbers.createAlias(
        $_aliasNameGenerator(
          db.bankStatements.accountNumber,
          db.baseAccountNumbers.accountNumber,
        ),
      );

  $$BaseAccountNumbersTableProcessedTableManager get accountNumber {
    final $_column = $_itemColumn<String>('account_number')!;

    final manager = $$BaseAccountNumbersTableTableManager(
      $_db,
      $_db.baseAccountNumbers,
    ).filter((f) => f.accountNumber.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountNumberTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $BankStatementOperationsTable,
    List<BankStatementOperationRow>
  >
  _bankStatementOperationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.bankStatementOperations,
        aliasName: $_aliasNameGenerator(
          db.bankStatements.id,
          db.bankStatementOperations.statementId,
        ),
      );

  $$BankStatementOperationsTableProcessedTableManager
  get bankStatementOperationsRefs {
    final manager = $$BankStatementOperationsTableTableManager(
      $_db,
      $_db.bankStatementOperations,
    ).filter((f) => f.statementId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bankStatementOperationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BankStatementsTableFilterComposer
    extends Composer<_$AppDatabase, $BankStatementsTable> {
  $$BankStatementsTableFilterComposer({
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

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialBalanceMinor => $composableBuilder(
    column: $table.initialBalanceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get finalBalanceMinor => $composableBuilder(
    column: $table.finalBalanceMinor,
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

  $$BaseAccountNumbersTableFilterComposer get accountNumber {
    final $$BaseAccountNumbersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountNumber,
      referencedTable: $db.baseAccountNumbers,
      getReferencedColumn: (t) => t.accountNumber,
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
    return composer;
  }

  Expression<bool> bankStatementOperationsRefs(
    Expression<bool> Function($$BankStatementOperationsTableFilterComposer f) f,
  ) {
    final $$BankStatementOperationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bankStatementOperations,
          getReferencedColumn: (t) => t.statementId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BankStatementOperationsTableFilterComposer(
                $db: $db,
                $table: $db.bankStatementOperations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BankStatementsTableOrderingComposer
    extends Composer<_$AppDatabase, $BankStatementsTable> {
  $$BankStatementsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialBalanceMinor => $composableBuilder(
    column: $table.initialBalanceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get finalBalanceMinor => $composableBuilder(
    column: $table.finalBalanceMinor,
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

  $$BaseAccountNumbersTableOrderingComposer get accountNumber {
    final $$BaseAccountNumbersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountNumber,
      referencedTable: $db.baseAccountNumbers,
      getReferencedColumn: (t) => t.accountNumber,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BaseAccountNumbersTableOrderingComposer(
            $db: $db,
            $table: $db.baseAccountNumbers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankStatementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BankStatementsTable> {
  $$BankStatementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get initialBalanceMinor => $composableBuilder(
    column: $table.initialBalanceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get finalBalanceMinor => $composableBuilder(
    column: $table.finalBalanceMinor,
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

  $$BaseAccountNumbersTableAnnotationComposer get accountNumber {
    final $$BaseAccountNumbersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.accountNumber,
          referencedTable: $db.baseAccountNumbers,
          getReferencedColumn: (t) => t.accountNumber,
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
    return composer;
  }

  Expression<T> bankStatementOperationsRefs<T extends Object>(
    Expression<T> Function($$BankStatementOperationsTableAnnotationComposer a)
    f,
  ) {
    final $$BankStatementOperationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bankStatementOperations,
          getReferencedColumn: (t) => t.statementId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BankStatementOperationsTableAnnotationComposer(
                $db: $db,
                $table: $db.bankStatementOperations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BankStatementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BankStatementsTable,
          BankStatementRow,
          $$BankStatementsTableFilterComposer,
          $$BankStatementsTableOrderingComposer,
          $$BankStatementsTableAnnotationComposer,
          $$BankStatementsTableCreateCompanionBuilder,
          $$BankStatementsTableUpdateCompanionBuilder,
          (BankStatementRow, $$BankStatementsTableReferences),
          BankStatementRow,
          PrefetchHooks Function({
            bool baseId,
            bool accountNumber,
            bool bankStatementOperationsRefs,
          })
        > {
  $$BankStatementsTableTableManager(
    _$AppDatabase db,
    $BankStatementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BankStatementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BankStatementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BankStatementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> baseId = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> initialBalanceMinor = const Value.absent(),
                Value<int> finalBalanceMinor = const Value.absent(),
              }) => BankStatementsCompanion(
                id: id,
                baseId: baseId,
                accountNumber: accountNumber,
                startDate: startDate,
                endDate: endDate,
                initialBalanceMinor: initialBalanceMinor,
                finalBalanceMinor: finalBalanceMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String baseId,
                required String accountNumber,
                required DateTime startDate,
                required DateTime endDate,
                required int initialBalanceMinor,
                required int finalBalanceMinor,
              }) => BankStatementsCompanion.insert(
                id: id,
                baseId: baseId,
                accountNumber: accountNumber,
                startDate: startDate,
                endDate: endDate,
                initialBalanceMinor: initialBalanceMinor,
                finalBalanceMinor: finalBalanceMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BankStatementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                baseId = false,
                accountNumber = false,
                bankStatementOperationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bankStatementOperationsRefs) db.bankStatementOperations,
                  ],
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
                                        $$BankStatementsTableReferences
                                            ._baseIdTable(db),
                                    referencedColumn:
                                        $$BankStatementsTableReferences
                                            ._baseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (accountNumber) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountNumber,
                                    referencedTable:
                                        $$BankStatementsTableReferences
                                            ._accountNumberTable(db),
                                    referencedColumn:
                                        $$BankStatementsTableReferences
                                            ._accountNumberTable(db)
                                            .accountNumber,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bankStatementOperationsRefs)
                        await $_getPrefetchedData<
                          BankStatementRow,
                          $BankStatementsTable,
                          BankStatementOperationRow
                        >(
                          currentTable: table,
                          referencedTable: $$BankStatementsTableReferences
                              ._bankStatementOperationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BankStatementsTableReferences(
                                db,
                                table,
                                p0,
                              ).bankStatementOperationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.statementId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BankStatementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BankStatementsTable,
      BankStatementRow,
      $$BankStatementsTableFilterComposer,
      $$BankStatementsTableOrderingComposer,
      $$BankStatementsTableAnnotationComposer,
      $$BankStatementsTableCreateCompanionBuilder,
      $$BankStatementsTableUpdateCompanionBuilder,
      (BankStatementRow, $$BankStatementsTableReferences),
      BankStatementRow,
      PrefetchHooks Function({
        bool baseId,
        bool accountNumber,
        bool bankStatementOperationsRefs,
      })
    >;
typedef $$BankStatementOperationsTableCreateCompanionBuilder =
    BankStatementOperationsCompanion Function({
      Value<int> id,
      required int statementId,
      required DateTime date,
      required String debitInn,
      required String debitBankAccount,
      required String creditInn,
      required String creditBankAccount,
      Value<int?> debitMinor,
      Value<int?> creditMinor,
      required String note,
    });
typedef $$BankStatementOperationsTableUpdateCompanionBuilder =
    BankStatementOperationsCompanion Function({
      Value<int> id,
      Value<int> statementId,
      Value<DateTime> date,
      Value<String> debitInn,
      Value<String> debitBankAccount,
      Value<String> creditInn,
      Value<String> creditBankAccount,
      Value<int?> debitMinor,
      Value<int?> creditMinor,
      Value<String> note,
    });

final class $$BankStatementOperationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BankStatementOperationsTable,
          BankStatementOperationRow
        > {
  $$BankStatementOperationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BankStatementsTable _statementIdTable(_$AppDatabase db) =>
      db.bankStatements.createAlias(
        $_aliasNameGenerator(
          db.bankStatementOperations.statementId,
          db.bankStatements.id,
        ),
      );

  $$BankStatementsTableProcessedTableManager get statementId {
    final $_column = $_itemColumn<int>('statement_id')!;

    final manager = $$BankStatementsTableTableManager(
      $_db,
      $_db.bankStatements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_statementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BankStatementOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $BankStatementOperationsTable> {
  $$BankStatementOperationsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get debitInn => $composableBuilder(
    column: $table.debitInn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get debitBankAccount => $composableBuilder(
    column: $table.debitBankAccount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creditInn => $composableBuilder(
    column: $table.creditInn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creditBankAccount => $composableBuilder(
    column: $table.creditBankAccount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get debitMinor => $composableBuilder(
    column: $table.debitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditMinor => $composableBuilder(
    column: $table.creditMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$BankStatementsTableFilterComposer get statementId {
    final $$BankStatementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.statementId,
      referencedTable: $db.bankStatements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankStatementsTableFilterComposer(
            $db: $db,
            $table: $db.bankStatements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankStatementOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $BankStatementOperationsTable> {
  $$BankStatementOperationsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get debitInn => $composableBuilder(
    column: $table.debitInn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get debitBankAccount => $composableBuilder(
    column: $table.debitBankAccount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creditInn => $composableBuilder(
    column: $table.creditInn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creditBankAccount => $composableBuilder(
    column: $table.creditBankAccount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get debitMinor => $composableBuilder(
    column: $table.debitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditMinor => $composableBuilder(
    column: $table.creditMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$BankStatementsTableOrderingComposer get statementId {
    final $$BankStatementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.statementId,
      referencedTable: $db.bankStatements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankStatementsTableOrderingComposer(
            $db: $db,
            $table: $db.bankStatements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankStatementOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BankStatementOperationsTable> {
  $$BankStatementOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get debitInn =>
      $composableBuilder(column: $table.debitInn, builder: (column) => column);

  GeneratedColumn<String> get debitBankAccount => $composableBuilder(
    column: $table.debitBankAccount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creditInn =>
      $composableBuilder(column: $table.creditInn, builder: (column) => column);

  GeneratedColumn<String> get creditBankAccount => $composableBuilder(
    column: $table.creditBankAccount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get debitMinor => $composableBuilder(
    column: $table.debitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditMinor => $composableBuilder(
    column: $table.creditMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$BankStatementsTableAnnotationComposer get statementId {
    final $$BankStatementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.statementId,
      referencedTable: $db.bankStatements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankStatementsTableAnnotationComposer(
            $db: $db,
            $table: $db.bankStatements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankStatementOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BankStatementOperationsTable,
          BankStatementOperationRow,
          $$BankStatementOperationsTableFilterComposer,
          $$BankStatementOperationsTableOrderingComposer,
          $$BankStatementOperationsTableAnnotationComposer,
          $$BankStatementOperationsTableCreateCompanionBuilder,
          $$BankStatementOperationsTableUpdateCompanionBuilder,
          (BankStatementOperationRow, $$BankStatementOperationsTableReferences),
          BankStatementOperationRow,
          PrefetchHooks Function({bool statementId})
        > {
  $$BankStatementOperationsTableTableManager(
    _$AppDatabase db,
    $BankStatementOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BankStatementOperationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BankStatementOperationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BankStatementOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> statementId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> debitInn = const Value.absent(),
                Value<String> debitBankAccount = const Value.absent(),
                Value<String> creditInn = const Value.absent(),
                Value<String> creditBankAccount = const Value.absent(),
                Value<int?> debitMinor = const Value.absent(),
                Value<int?> creditMinor = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => BankStatementOperationsCompanion(
                id: id,
                statementId: statementId,
                date: date,
                debitInn: debitInn,
                debitBankAccount: debitBankAccount,
                creditInn: creditInn,
                creditBankAccount: creditBankAccount,
                debitMinor: debitMinor,
                creditMinor: creditMinor,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int statementId,
                required DateTime date,
                required String debitInn,
                required String debitBankAccount,
                required String creditInn,
                required String creditBankAccount,
                Value<int?> debitMinor = const Value.absent(),
                Value<int?> creditMinor = const Value.absent(),
                required String note,
              }) => BankStatementOperationsCompanion.insert(
                id: id,
                statementId: statementId,
                date: date,
                debitInn: debitInn,
                debitBankAccount: debitBankAccount,
                creditInn: creditInn,
                creditBankAccount: creditBankAccount,
                debitMinor: debitMinor,
                creditMinor: creditMinor,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BankStatementOperationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({statementId = false}) {
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
                    if (statementId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.statementId,
                                referencedTable:
                                    $$BankStatementOperationsTableReferences
                                        ._statementIdTable(db),
                                referencedColumn:
                                    $$BankStatementOperationsTableReferences
                                        ._statementIdTable(db)
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

typedef $$BankStatementOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BankStatementOperationsTable,
      BankStatementOperationRow,
      $$BankStatementOperationsTableFilterComposer,
      $$BankStatementOperationsTableOrderingComposer,
      $$BankStatementOperationsTableAnnotationComposer,
      $$BankStatementOperationsTableCreateCompanionBuilder,
      $$BankStatementOperationsTableUpdateCompanionBuilder,
      (BankStatementOperationRow, $$BankStatementOperationsTableReferences),
      BankStatementOperationRow,
      PrefetchHooks Function({bool statementId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BasesTableTableManager get bases =>
      $$BasesTableTableManager(_db, _db.bases);
  $$BaseAccountNumbersTableTableManager get baseAccountNumbers =>
      $$BaseAccountNumbersTableTableManager(_db, _db.baseAccountNumbers);
  $$BankStatementsTableTableManager get bankStatements =>
      $$BankStatementsTableTableManager(_db, _db.bankStatements);
  $$BankStatementOperationsTableTableManager get bankStatementOperations =>
      $$BankStatementOperationsTableTableManager(
        _db,
        _db.bankStatementOperations,
      );
}
