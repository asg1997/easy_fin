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
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, baseId, accountNumber, bankName];
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
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
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
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
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
  final String bankName;
  const BaseAccountNumber({
    required this.id,
    required this.baseId,
    required this.accountNumber,
    required this.bankName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base_id'] = Variable<String>(baseId);
    map['account_number'] = Variable<String>(accountNumber);
    map['bank_name'] = Variable<String>(bankName);
    return map;
  }

  BaseAccountNumbersCompanion toCompanion(bool nullToAbsent) {
    return BaseAccountNumbersCompanion(
      id: Value(id),
      baseId: Value(baseId),
      accountNumber: Value(accountNumber),
      bankName: Value(bankName),
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
      bankName: serializer.fromJson<String>(json['bankName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baseId': serializer.toJson<String>(baseId),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'bankName': serializer.toJson<String>(bankName),
    };
  }

  BaseAccountNumber copyWith({
    int? id,
    String? baseId,
    String? accountNumber,
    String? bankName,
  }) => BaseAccountNumber(
    id: id ?? this.id,
    baseId: baseId ?? this.baseId,
    accountNumber: accountNumber ?? this.accountNumber,
    bankName: bankName ?? this.bankName,
  );
  BaseAccountNumber copyWithCompanion(BaseAccountNumbersCompanion data) {
    return BaseAccountNumber(
      id: data.id.present ? data.id.value : this.id,
      baseId: data.baseId.present ? data.baseId.value : this.baseId,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BaseAccountNumber(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('bankName: $bankName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, baseId, accountNumber, bankName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaseAccountNumber &&
          other.id == this.id &&
          other.baseId == this.baseId &&
          other.accountNumber == this.accountNumber &&
          other.bankName == this.bankName);
}

class BaseAccountNumbersCompanion extends UpdateCompanion<BaseAccountNumber> {
  final Value<int> id;
  final Value<String> baseId;
  final Value<String> accountNumber;
  final Value<String> bankName;
  const BaseAccountNumbersCompanion({
    this.id = const Value.absent(),
    this.baseId = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.bankName = const Value.absent(),
  });
  BaseAccountNumbersCompanion.insert({
    this.id = const Value.absent(),
    required String baseId,
    required String accountNumber,
    this.bankName = const Value.absent(),
  }) : baseId = Value(baseId),
       accountNumber = Value(accountNumber);
  static Insertable<BaseAccountNumber> custom({
    Expression<int>? id,
    Expression<String>? baseId,
    Expression<String>? accountNumber,
    Expression<String>? bankName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseId != null) 'base_id': baseId,
      if (accountNumber != null) 'account_number': accountNumber,
      if (bankName != null) 'bank_name': bankName,
    });
  }

  BaseAccountNumbersCompanion copyWith({
    Value<int>? id,
    Value<String>? baseId,
    Value<String>? accountNumber,
    Value<String>? bankName,
  }) {
    return BaseAccountNumbersCompanion(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
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
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BaseAccountNumbersCompanion(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('bankName: $bankName')
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

class $RentersTable extends Renters with TableInfo<$RentersTable, RenterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RentersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, baseId, name, isArchived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'renters';
  @override
  VerificationContext validateIntegrity(
    Insertable<RenterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_id')) {
      context.handle(
        _baseIdMeta,
        baseId.isAcceptableOrUnknown(data['base_id']!, _baseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_baseIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RenterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RenterRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      baseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $RentersTable createAlias(String alias) {
    return $RentersTable(attachedDatabase, alias);
  }
}

class RenterRow extends DataClass implements Insertable<RenterRow> {
  final String id;
  final String baseId;
  final String name;
  final bool isArchived;
  const RenterRow({
    required this.id,
    required this.baseId,
    required this.name,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_id'] = Variable<String>(baseId);
    map['name'] = Variable<String>(name);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  RentersCompanion toCompanion(bool nullToAbsent) {
    return RentersCompanion(
      id: Value(id),
      baseId: Value(baseId),
      name: Value(name),
      isArchived: Value(isArchived),
    );
  }

  factory RenterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RenterRow(
      id: serializer.fromJson<String>(json['id']),
      baseId: serializer.fromJson<String>(json['baseId']),
      name: serializer.fromJson<String>(json['name']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseId': serializer.toJson<String>(baseId),
      'name': serializer.toJson<String>(name),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  RenterRow copyWith({
    String? id,
    String? baseId,
    String? name,
    bool? isArchived,
  }) => RenterRow(
    id: id ?? this.id,
    baseId: baseId ?? this.baseId,
    name: name ?? this.name,
    isArchived: isArchived ?? this.isArchived,
  );
  RenterRow copyWithCompanion(RentersCompanion data) {
    return RenterRow(
      id: data.id.present ? data.id.value : this.id,
      baseId: data.baseId.present ? data.baseId.value : this.baseId,
      name: data.name.present ? data.name.value : this.name,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RenterRow(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('name: $name, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, baseId, name, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RenterRow &&
          other.id == this.id &&
          other.baseId == this.baseId &&
          other.name == this.name &&
          other.isArchived == this.isArchived);
}

class RentersCompanion extends UpdateCompanion<RenterRow> {
  final Value<String> id;
  final Value<String> baseId;
  final Value<String> name;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const RentersCompanion({
    this.id = const Value.absent(),
    this.baseId = const Value.absent(),
    this.name = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RentersCompanion.insert({
    required String id,
    required String baseId,
    required String name,
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       baseId = Value(baseId),
       name = Value(name);
  static Insertable<RenterRow> custom({
    Expression<String>? id,
    Expression<String>? baseId,
    Expression<String>? name,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseId != null) 'base_id': baseId,
      if (name != null) 'name': name,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RentersCompanion copyWith({
    Value<String>? id,
    Value<String>? baseId,
    Value<String>? name,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return RentersCompanion(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      name: name ?? this.name,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseId.present) {
      map['base_id'] = Variable<String>(baseId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RentersCompanion(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('name: $name, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeCategoriesTable extends IncomeCategories
    with TableInfo<$IncomeCategoriesTable, IncomeCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeCategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isArchived,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeCategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $IncomeCategoriesTable createAlias(String alias) {
    return $IncomeCategoriesTable(attachedDatabase, alias);
  }
}

class IncomeCategoryRow extends DataClass
    implements Insertable<IncomeCategoryRow> {
  final int id;
  final String name;
  final bool isArchived;
  final int sortOrder;
  final DateTime createdAt;
  const IncomeCategoryRow({
    required this.id,
    required this.name,
    required this.isArchived,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_archived'] = Variable<bool>(isArchived);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IncomeCategoriesCompanion toCompanion(bool nullToAbsent) {
    return IncomeCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      isArchived: Value(isArchived),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory IncomeCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeCategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isArchived': serializer.toJson<bool>(isArchived),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  IncomeCategoryRow copyWith({
    int? id,
    String? name,
    bool? isArchived,
    int? sortOrder,
    DateTime? createdAt,
  }) => IncomeCategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    isArchived: isArchived ?? this.isArchived,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  IncomeCategoryRow copyWithCompanion(IncomeCategoriesCompanion data) {
    return IncomeCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeCategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isArchived, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeCategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.isArchived == this.isArchived &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class IncomeCategoriesCompanion extends UpdateCompanion<IncomeCategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isArchived;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const IncomeCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  IncomeCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<IncomeCategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isArchived,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isArchived != null) 'is_archived': isArchived,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  IncomeCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isArchived,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return IncomeCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isArchived: isArchived ?? this.isArchived,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isArchived,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategoryRow extends DataClass
    implements Insertable<ExpenseCategoryRow> {
  final int id;
  final String name;
  final bool isArchived;
  final int sortOrder;
  final DateTime createdAt;
  const ExpenseCategoryRow({
    required this.id,
    required this.name,
    required this.isArchived,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_archived'] = Variable<bool>(isArchived);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      isArchived: Value(isArchived),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isArchived': serializer.toJson<bool>(isArchived),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseCategoryRow copyWith({
    int? id,
    String? name,
    bool? isArchived,
    int? sortOrder,
    DateTime? createdAt,
  }) => ExpenseCategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    isArchived: isArchived ?? this.isArchived,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  ExpenseCategoryRow copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isArchived, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.isArchived == this.isArchived &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isArchived;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<ExpenseCategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isArchived,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isArchived != null) 'is_archived': isArchived,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpenseCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isArchived,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isArchived: isArchived ?? this.isArchived,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
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
  static const VerificationMeta _renterIdMeta = const VerificationMeta(
    'renterId',
  );
  @override
  late final GeneratedColumn<String> renterId = GeneratedColumn<String>(
    'renter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES renters (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _incomeCategoryIdMeta = const VerificationMeta(
    'incomeCategoryId',
  );
  @override
  late final GeneratedColumn<int> incomeCategoryId = GeneratedColumn<int>(
    'income_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES income_categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _expenseCategoryIdMeta = const VerificationMeta(
    'expenseCategoryId',
  );
  @override
  late final GeneratedColumn<int> expenseCategoryId = GeneratedColumn<int>(
    'expense_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expense_categories (id) ON DELETE SET NULL',
    ),
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
    renterId,
    incomeCategoryId,
    expenseCategoryId,
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
    if (data.containsKey('renter_id')) {
      context.handle(
        _renterIdMeta,
        renterId.isAcceptableOrUnknown(data['renter_id']!, _renterIdMeta),
      );
    }
    if (data.containsKey('income_category_id')) {
      context.handle(
        _incomeCategoryIdMeta,
        incomeCategoryId.isAcceptableOrUnknown(
          data['income_category_id']!,
          _incomeCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('expense_category_id')) {
      context.handle(
        _expenseCategoryIdMeta,
        expenseCategoryId.isAcceptableOrUnknown(
          data['expense_category_id']!,
          _expenseCategoryIdMeta,
        ),
      );
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
      renterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}renter_id'],
      ),
      incomeCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}income_category_id'],
      ),
      expenseCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expense_category_id'],
      ),
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
  final String? renterId;
  final int? incomeCategoryId;
  final int? expenseCategoryId;
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
    this.renterId,
    this.incomeCategoryId,
    this.expenseCategoryId,
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
    if (!nullToAbsent || renterId != null) {
      map['renter_id'] = Variable<String>(renterId);
    }
    if (!nullToAbsent || incomeCategoryId != null) {
      map['income_category_id'] = Variable<int>(incomeCategoryId);
    }
    if (!nullToAbsent || expenseCategoryId != null) {
      map['expense_category_id'] = Variable<int>(expenseCategoryId);
    }
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
      renterId: renterId == null && nullToAbsent
          ? const Value.absent()
          : Value(renterId),
      incomeCategoryId: incomeCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(incomeCategoryId),
      expenseCategoryId: expenseCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseCategoryId),
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
      renterId: serializer.fromJson<String?>(json['renterId']),
      incomeCategoryId: serializer.fromJson<int?>(json['incomeCategoryId']),
      expenseCategoryId: serializer.fromJson<int?>(json['expenseCategoryId']),
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
      'renterId': serializer.toJson<String?>(renterId),
      'incomeCategoryId': serializer.toJson<int?>(incomeCategoryId),
      'expenseCategoryId': serializer.toJson<int?>(expenseCategoryId),
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
    Value<String?> renterId = const Value.absent(),
    Value<int?> incomeCategoryId = const Value.absent(),
    Value<int?> expenseCategoryId = const Value.absent(),
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
    renterId: renterId.present ? renterId.value : this.renterId,
    incomeCategoryId: incomeCategoryId.present
        ? incomeCategoryId.value
        : this.incomeCategoryId,
    expenseCategoryId: expenseCategoryId.present
        ? expenseCategoryId.value
        : this.expenseCategoryId,
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
      renterId: data.renterId.present ? data.renterId.value : this.renterId,
      incomeCategoryId: data.incomeCategoryId.present
          ? data.incomeCategoryId.value
          : this.incomeCategoryId,
      expenseCategoryId: data.expenseCategoryId.present
          ? data.expenseCategoryId.value
          : this.expenseCategoryId,
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
          ..write('note: $note, ')
          ..write('renterId: $renterId, ')
          ..write('incomeCategoryId: $incomeCategoryId, ')
          ..write('expenseCategoryId: $expenseCategoryId')
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
    renterId,
    incomeCategoryId,
    expenseCategoryId,
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
          other.note == this.note &&
          other.renterId == this.renterId &&
          other.incomeCategoryId == this.incomeCategoryId &&
          other.expenseCategoryId == this.expenseCategoryId);
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
  final Value<String?> renterId;
  final Value<int?> incomeCategoryId;
  final Value<int?> expenseCategoryId;
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
    this.renterId = const Value.absent(),
    this.incomeCategoryId = const Value.absent(),
    this.expenseCategoryId = const Value.absent(),
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
    this.renterId = const Value.absent(),
    this.incomeCategoryId = const Value.absent(),
    this.expenseCategoryId = const Value.absent(),
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
    Expression<String>? renterId,
    Expression<int>? incomeCategoryId,
    Expression<int>? expenseCategoryId,
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
      if (renterId != null) 'renter_id': renterId,
      if (incomeCategoryId != null) 'income_category_id': incomeCategoryId,
      if (expenseCategoryId != null) 'expense_category_id': expenseCategoryId,
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
    Value<String?>? renterId,
    Value<int?>? incomeCategoryId,
    Value<int?>? expenseCategoryId,
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
      renterId: renterId ?? this.renterId,
      incomeCategoryId: incomeCategoryId ?? this.incomeCategoryId,
      expenseCategoryId: expenseCategoryId ?? this.expenseCategoryId,
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
    if (renterId.present) {
      map['renter_id'] = Variable<String>(renterId.value);
    }
    if (incomeCategoryId.present) {
      map['income_category_id'] = Variable<int>(incomeCategoryId.value);
    }
    if (expenseCategoryId.present) {
      map['expense_category_id'] = Variable<int>(expenseCategoryId.value);
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
          ..write('note: $note, ')
          ..write('renterId: $renterId, ')
          ..write('incomeCategoryId: $incomeCategoryId, ')
          ..write('expenseCategoryId: $expenseCategoryId')
          ..write(')'))
        .toString();
  }
}

class $RenterAccountNumbersTable extends RenterAccountNumbers
    with TableInfo<$RenterAccountNumbersTable, RenterAccountNumber> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RenterAccountNumbersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _renterIdMeta = const VerificationMeta(
    'renterId',
  );
  @override
  late final GeneratedColumn<String> renterId = GeneratedColumn<String>(
    'renter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES renters (id) ON DELETE CASCADE',
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
  List<GeneratedColumn> get $columns => [id, renterId, accountNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'renter_account_numbers';
  @override
  VerificationContext validateIntegrity(
    Insertable<RenterAccountNumber> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('renter_id')) {
      context.handle(
        _renterIdMeta,
        renterId.isAcceptableOrUnknown(data['renter_id']!, _renterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_renterIdMeta);
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
  RenterAccountNumber map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RenterAccountNumber(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      renterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}renter_id'],
      )!,
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      )!,
    );
  }

  @override
  $RenterAccountNumbersTable createAlias(String alias) {
    return $RenterAccountNumbersTable(attachedDatabase, alias);
  }
}

class RenterAccountNumber extends DataClass
    implements Insertable<RenterAccountNumber> {
  final int id;
  final String renterId;
  final String accountNumber;
  const RenterAccountNumber({
    required this.id,
    required this.renterId,
    required this.accountNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['renter_id'] = Variable<String>(renterId);
    map['account_number'] = Variable<String>(accountNumber);
    return map;
  }

  RenterAccountNumbersCompanion toCompanion(bool nullToAbsent) {
    return RenterAccountNumbersCompanion(
      id: Value(id),
      renterId: Value(renterId),
      accountNumber: Value(accountNumber),
    );
  }

  factory RenterAccountNumber.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RenterAccountNumber(
      id: serializer.fromJson<int>(json['id']),
      renterId: serializer.fromJson<String>(json['renterId']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'renterId': serializer.toJson<String>(renterId),
      'accountNumber': serializer.toJson<String>(accountNumber),
    };
  }

  RenterAccountNumber copyWith({
    int? id,
    String? renterId,
    String? accountNumber,
  }) => RenterAccountNumber(
    id: id ?? this.id,
    renterId: renterId ?? this.renterId,
    accountNumber: accountNumber ?? this.accountNumber,
  );
  RenterAccountNumber copyWithCompanion(RenterAccountNumbersCompanion data) {
    return RenterAccountNumber(
      id: data.id.present ? data.id.value : this.id,
      renterId: data.renterId.present ? data.renterId.value : this.renterId,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RenterAccountNumber(')
          ..write('id: $id, ')
          ..write('renterId: $renterId, ')
          ..write('accountNumber: $accountNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, renterId, accountNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RenterAccountNumber &&
          other.id == this.id &&
          other.renterId == this.renterId &&
          other.accountNumber == this.accountNumber);
}

class RenterAccountNumbersCompanion
    extends UpdateCompanion<RenterAccountNumber> {
  final Value<int> id;
  final Value<String> renterId;
  final Value<String> accountNumber;
  const RenterAccountNumbersCompanion({
    this.id = const Value.absent(),
    this.renterId = const Value.absent(),
    this.accountNumber = const Value.absent(),
  });
  RenterAccountNumbersCompanion.insert({
    this.id = const Value.absent(),
    required String renterId,
    required String accountNumber,
  }) : renterId = Value(renterId),
       accountNumber = Value(accountNumber);
  static Insertable<RenterAccountNumber> custom({
    Expression<int>? id,
    Expression<String>? renterId,
    Expression<String>? accountNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (renterId != null) 'renter_id': renterId,
      if (accountNumber != null) 'account_number': accountNumber,
    });
  }

  RenterAccountNumbersCompanion copyWith({
    Value<int>? id,
    Value<String>? renterId,
    Value<String>? accountNumber,
  }) {
    return RenterAccountNumbersCompanion(
      id: id ?? this.id,
      renterId: renterId ?? this.renterId,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (renterId.present) {
      map['renter_id'] = Variable<String>(renterId.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RenterAccountNumbersCompanion(')
          ..write('id: $id, ')
          ..write('renterId: $renterId, ')
          ..write('accountNumber: $accountNumber')
          ..write(')'))
        .toString();
  }
}

class $RenterAssignmentsTable extends RenterAssignments
    with TableInfo<$RenterAssignmentsTable, RenterAssignmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RenterAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _renterIdMeta = const VerificationMeta(
    'renterId',
  );
  @override
  late final GeneratedColumn<String> renterId = GeneratedColumn<String>(
    'renter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES renters (id) ON DELETE CASCADE',
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
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseId,
    renterId,
    accountNumber,
    date,
    amountMinor,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'renter_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<RenterAssignmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_id')) {
      context.handle(
        _baseIdMeta,
        baseId.isAcceptableOrUnknown(data['base_id']!, _baseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_baseIdMeta);
    }
    if (data.containsKey('renter_id')) {
      context.handle(
        _renterIdMeta,
        renterId.isAcceptableOrUnknown(data['renter_id']!, _renterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_renterIdMeta);
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
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RenterAssignmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RenterAssignmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      baseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_id'],
      )!,
      renterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}renter_id'],
      )!,
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RenterAssignmentsTable createAlias(String alias) {
    return $RenterAssignmentsTable(attachedDatabase, alias);
  }
}

class RenterAssignmentRow extends DataClass
    implements Insertable<RenterAssignmentRow> {
  final String id;
  final String baseId;
  final String renterId;
  final String accountNumber;
  final DateTime date;
  final int amountMinor;
  final DateTime createdAt;
  const RenterAssignmentRow({
    required this.id,
    required this.baseId,
    required this.renterId,
    required this.accountNumber,
    required this.date,
    required this.amountMinor,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_id'] = Variable<String>(baseId);
    map['renter_id'] = Variable<String>(renterId);
    map['account_number'] = Variable<String>(accountNumber);
    map['date'] = Variable<DateTime>(date);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RenterAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return RenterAssignmentsCompanion(
      id: Value(id),
      baseId: Value(baseId),
      renterId: Value(renterId),
      accountNumber: Value(accountNumber),
      date: Value(date),
      amountMinor: Value(amountMinor),
      createdAt: Value(createdAt),
    );
  }

  factory RenterAssignmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RenterAssignmentRow(
      id: serializer.fromJson<String>(json['id']),
      baseId: serializer.fromJson<String>(json['baseId']),
      renterId: serializer.fromJson<String>(json['renterId']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
      date: serializer.fromJson<DateTime>(json['date']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseId': serializer.toJson<String>(baseId),
      'renterId': serializer.toJson<String>(renterId),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'date': serializer.toJson<DateTime>(date),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RenterAssignmentRow copyWith({
    String? id,
    String? baseId,
    String? renterId,
    String? accountNumber,
    DateTime? date,
    int? amountMinor,
    DateTime? createdAt,
  }) => RenterAssignmentRow(
    id: id ?? this.id,
    baseId: baseId ?? this.baseId,
    renterId: renterId ?? this.renterId,
    accountNumber: accountNumber ?? this.accountNumber,
    date: date ?? this.date,
    amountMinor: amountMinor ?? this.amountMinor,
    createdAt: createdAt ?? this.createdAt,
  );
  RenterAssignmentRow copyWithCompanion(RenterAssignmentsCompanion data) {
    return RenterAssignmentRow(
      id: data.id.present ? data.id.value : this.id,
      baseId: data.baseId.present ? data.baseId.value : this.baseId,
      renterId: data.renterId.present ? data.renterId.value : this.renterId,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      date: data.date.present ? data.date.value : this.date,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RenterAssignmentRow(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('renterId: $renterId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('date: $date, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baseId,
    renterId,
    accountNumber,
    date,
    amountMinor,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RenterAssignmentRow &&
          other.id == this.id &&
          other.baseId == this.baseId &&
          other.renterId == this.renterId &&
          other.accountNumber == this.accountNumber &&
          other.date == this.date &&
          other.amountMinor == this.amountMinor &&
          other.createdAt == this.createdAt);
}

class RenterAssignmentsCompanion extends UpdateCompanion<RenterAssignmentRow> {
  final Value<String> id;
  final Value<String> baseId;
  final Value<String> renterId;
  final Value<String> accountNumber;
  final Value<DateTime> date;
  final Value<int> amountMinor;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RenterAssignmentsCompanion({
    this.id = const Value.absent(),
    this.baseId = const Value.absent(),
    this.renterId = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RenterAssignmentsCompanion.insert({
    required String id,
    required String baseId,
    required String renterId,
    required String accountNumber,
    required DateTime date,
    required int amountMinor,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       baseId = Value(baseId),
       renterId = Value(renterId),
       accountNumber = Value(accountNumber),
       date = Value(date),
       amountMinor = Value(amountMinor),
       createdAt = Value(createdAt);
  static Insertable<RenterAssignmentRow> custom({
    Expression<String>? id,
    Expression<String>? baseId,
    Expression<String>? renterId,
    Expression<String>? accountNumber,
    Expression<DateTime>? date,
    Expression<int>? amountMinor,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseId != null) 'base_id': baseId,
      if (renterId != null) 'renter_id': renterId,
      if (accountNumber != null) 'account_number': accountNumber,
      if (date != null) 'date': date,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RenterAssignmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? baseId,
    Value<String>? renterId,
    Value<String>? accountNumber,
    Value<DateTime>? date,
    Value<int>? amountMinor,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RenterAssignmentsCompanion(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      renterId: renterId ?? this.renterId,
      accountNumber: accountNumber ?? this.accountNumber,
      date: date ?? this.date,
      amountMinor: amountMinor ?? this.amountMinor,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseId.present) {
      map['base_id'] = Variable<String>(baseId.value);
    }
    if (renterId.present) {
      map['renter_id'] = Variable<String>(renterId.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RenterAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('renterId: $renterId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('date: $date, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoryAccountNumbersTable extends ExpenseCategoryAccountNumbers
    with
        TableInfo<
          $ExpenseCategoryAccountNumbersTable,
          ExpenseCategoryAccountNumber
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoryAccountNumbersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _expenseCategoryIdMeta = const VerificationMeta(
    'expenseCategoryId',
  );
  @override
  late final GeneratedColumn<int> expenseCategoryId = GeneratedColumn<int>(
    'expense_category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expense_categories (id) ON DELETE CASCADE',
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
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseId,
    expenseCategoryId,
    accountNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_category_account_numbers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseCategoryAccountNumber> instance, {
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
    if (data.containsKey('expense_category_id')) {
      context.handle(
        _expenseCategoryIdMeta,
        expenseCategoryId.isAcceptableOrUnknown(
          data['expense_category_id']!,
          _expenseCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expenseCategoryIdMeta);
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {baseId, accountNumber},
  ];
  @override
  ExpenseCategoryAccountNumber map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategoryAccountNumber(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      baseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_id'],
      )!,
      expenseCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expense_category_id'],
      )!,
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      )!,
    );
  }

  @override
  $ExpenseCategoryAccountNumbersTable createAlias(String alias) {
    return $ExpenseCategoryAccountNumbersTable(attachedDatabase, alias);
  }
}

class ExpenseCategoryAccountNumber extends DataClass
    implements Insertable<ExpenseCategoryAccountNumber> {
  final int id;
  final String baseId;
  final int expenseCategoryId;
  final String accountNumber;
  const ExpenseCategoryAccountNumber({
    required this.id,
    required this.baseId,
    required this.expenseCategoryId,
    required this.accountNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base_id'] = Variable<String>(baseId);
    map['expense_category_id'] = Variable<int>(expenseCategoryId);
    map['account_number'] = Variable<String>(accountNumber);
    return map;
  }

  ExpenseCategoryAccountNumbersCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoryAccountNumbersCompanion(
      id: Value(id),
      baseId: Value(baseId),
      expenseCategoryId: Value(expenseCategoryId),
      accountNumber: Value(accountNumber),
    );
  }

  factory ExpenseCategoryAccountNumber.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategoryAccountNumber(
      id: serializer.fromJson<int>(json['id']),
      baseId: serializer.fromJson<String>(json['baseId']),
      expenseCategoryId: serializer.fromJson<int>(json['expenseCategoryId']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baseId': serializer.toJson<String>(baseId),
      'expenseCategoryId': serializer.toJson<int>(expenseCategoryId),
      'accountNumber': serializer.toJson<String>(accountNumber),
    };
  }

  ExpenseCategoryAccountNumber copyWith({
    int? id,
    String? baseId,
    int? expenseCategoryId,
    String? accountNumber,
  }) => ExpenseCategoryAccountNumber(
    id: id ?? this.id,
    baseId: baseId ?? this.baseId,
    expenseCategoryId: expenseCategoryId ?? this.expenseCategoryId,
    accountNumber: accountNumber ?? this.accountNumber,
  );
  ExpenseCategoryAccountNumber copyWithCompanion(
    ExpenseCategoryAccountNumbersCompanion data,
  ) {
    return ExpenseCategoryAccountNumber(
      id: data.id.present ? data.id.value : this.id,
      baseId: data.baseId.present ? data.baseId.value : this.baseId,
      expenseCategoryId: data.expenseCategoryId.present
          ? data.expenseCategoryId.value
          : this.expenseCategoryId,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoryAccountNumber(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('expenseCategoryId: $expenseCategoryId, ')
          ..write('accountNumber: $accountNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, baseId, expenseCategoryId, accountNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategoryAccountNumber &&
          other.id == this.id &&
          other.baseId == this.baseId &&
          other.expenseCategoryId == this.expenseCategoryId &&
          other.accountNumber == this.accountNumber);
}

class ExpenseCategoryAccountNumbersCompanion
    extends UpdateCompanion<ExpenseCategoryAccountNumber> {
  final Value<int> id;
  final Value<String> baseId;
  final Value<int> expenseCategoryId;
  final Value<String> accountNumber;
  const ExpenseCategoryAccountNumbersCompanion({
    this.id = const Value.absent(),
    this.baseId = const Value.absent(),
    this.expenseCategoryId = const Value.absent(),
    this.accountNumber = const Value.absent(),
  });
  ExpenseCategoryAccountNumbersCompanion.insert({
    this.id = const Value.absent(),
    required String baseId,
    required int expenseCategoryId,
    required String accountNumber,
  }) : baseId = Value(baseId),
       expenseCategoryId = Value(expenseCategoryId),
       accountNumber = Value(accountNumber);
  static Insertable<ExpenseCategoryAccountNumber> custom({
    Expression<int>? id,
    Expression<String>? baseId,
    Expression<int>? expenseCategoryId,
    Expression<String>? accountNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseId != null) 'base_id': baseId,
      if (expenseCategoryId != null) 'expense_category_id': expenseCategoryId,
      if (accountNumber != null) 'account_number': accountNumber,
    });
  }

  ExpenseCategoryAccountNumbersCompanion copyWith({
    Value<int>? id,
    Value<String>? baseId,
    Value<int>? expenseCategoryId,
    Value<String>? accountNumber,
  }) {
    return ExpenseCategoryAccountNumbersCompanion(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      expenseCategoryId: expenseCategoryId ?? this.expenseCategoryId,
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
    if (expenseCategoryId.present) {
      map['expense_category_id'] = Variable<int>(expenseCategoryId.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoryAccountNumbersCompanion(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('expenseCategoryId: $expenseCategoryId, ')
          ..write('accountNumber: $accountNumber')
          ..write(')'))
        .toString();
  }
}

class $IncomeDocumentsTable extends IncomeDocuments
    with TableInfo<$IncomeDocumentsTable, IncomeDocumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountRefMeta = const VerificationMeta(
    'accountRef',
  );
  @override
  late final GeneratedColumn<String> accountRef = GeneratedColumn<String>(
    'account_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseId,
    date,
    accountType,
    accountRef,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeDocumentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_id')) {
      context.handle(
        _baseIdMeta,
        baseId.isAcceptableOrUnknown(data['base_id']!, _baseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_baseIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('account_ref')) {
      context.handle(
        _accountRefMeta,
        accountRef.isAcceptableOrUnknown(data['account_ref']!, _accountRefMeta),
      );
    } else if (isInserting) {
      context.missing(_accountRefMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeDocumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeDocumentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      baseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      accountRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_ref'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $IncomeDocumentsTable createAlias(String alias) {
    return $IncomeDocumentsTable(attachedDatabase, alias);
  }
}

class IncomeDocumentRow extends DataClass
    implements Insertable<IncomeDocumentRow> {
  final String id;
  final String baseId;
  final DateTime date;
  final String accountType;
  final String accountRef;
  final DateTime createdAt;
  const IncomeDocumentRow({
    required this.id,
    required this.baseId,
    required this.date,
    required this.accountType,
    required this.accountRef,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_id'] = Variable<String>(baseId);
    map['date'] = Variable<DateTime>(date);
    map['account_type'] = Variable<String>(accountType);
    map['account_ref'] = Variable<String>(accountRef);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IncomeDocumentsCompanion toCompanion(bool nullToAbsent) {
    return IncomeDocumentsCompanion(
      id: Value(id),
      baseId: Value(baseId),
      date: Value(date),
      accountType: Value(accountType),
      accountRef: Value(accountRef),
      createdAt: Value(createdAt),
    );
  }

  factory IncomeDocumentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeDocumentRow(
      id: serializer.fromJson<String>(json['id']),
      baseId: serializer.fromJson<String>(json['baseId']),
      date: serializer.fromJson<DateTime>(json['date']),
      accountType: serializer.fromJson<String>(json['accountType']),
      accountRef: serializer.fromJson<String>(json['accountRef']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseId': serializer.toJson<String>(baseId),
      'date': serializer.toJson<DateTime>(date),
      'accountType': serializer.toJson<String>(accountType),
      'accountRef': serializer.toJson<String>(accountRef),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  IncomeDocumentRow copyWith({
    String? id,
    String? baseId,
    DateTime? date,
    String? accountType,
    String? accountRef,
    DateTime? createdAt,
  }) => IncomeDocumentRow(
    id: id ?? this.id,
    baseId: baseId ?? this.baseId,
    date: date ?? this.date,
    accountType: accountType ?? this.accountType,
    accountRef: accountRef ?? this.accountRef,
    createdAt: createdAt ?? this.createdAt,
  );
  IncomeDocumentRow copyWithCompanion(IncomeDocumentsCompanion data) {
    return IncomeDocumentRow(
      id: data.id.present ? data.id.value : this.id,
      baseId: data.baseId.present ? data.baseId.value : this.baseId,
      date: data.date.present ? data.date.value : this.date,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      accountRef: data.accountRef.present
          ? data.accountRef.value
          : this.accountRef,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeDocumentRow(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('date: $date, ')
          ..write('accountType: $accountType, ')
          ..write('accountRef: $accountRef, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, baseId, date, accountType, accountRef, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeDocumentRow &&
          other.id == this.id &&
          other.baseId == this.baseId &&
          other.date == this.date &&
          other.accountType == this.accountType &&
          other.accountRef == this.accountRef &&
          other.createdAt == this.createdAt);
}

class IncomeDocumentsCompanion extends UpdateCompanion<IncomeDocumentRow> {
  final Value<String> id;
  final Value<String> baseId;
  final Value<DateTime> date;
  final Value<String> accountType;
  final Value<String> accountRef;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const IncomeDocumentsCompanion({
    this.id = const Value.absent(),
    this.baseId = const Value.absent(),
    this.date = const Value.absent(),
    this.accountType = const Value.absent(),
    this.accountRef = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeDocumentsCompanion.insert({
    required String id,
    required String baseId,
    required DateTime date,
    required String accountType,
    required String accountRef,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       baseId = Value(baseId),
       date = Value(date),
       accountType = Value(accountType),
       accountRef = Value(accountRef),
       createdAt = Value(createdAt);
  static Insertable<IncomeDocumentRow> custom({
    Expression<String>? id,
    Expression<String>? baseId,
    Expression<DateTime>? date,
    Expression<String>? accountType,
    Expression<String>? accountRef,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseId != null) 'base_id': baseId,
      if (date != null) 'date': date,
      if (accountType != null) 'account_type': accountType,
      if (accountRef != null) 'account_ref': accountRef,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? baseId,
    Value<DateTime>? date,
    Value<String>? accountType,
    Value<String>? accountRef,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return IncomeDocumentsCompanion(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      date: date ?? this.date,
      accountType: accountType ?? this.accountType,
      accountRef: accountRef ?? this.accountRef,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseId.present) {
      map['base_id'] = Variable<String>(baseId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (accountRef.present) {
      map['account_ref'] = Variable<String>(accountRef.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('date: $date, ')
          ..write('accountType: $accountType, ')
          ..write('accountRef: $accountRef, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeLinesTable extends IncomeLines
    with TableInfo<$IncomeLinesTable, IncomeLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES income_documents (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _renterIdMeta = const VerificationMeta(
    'renterId',
  );
  @override
  late final GeneratedColumn<String> renterId = GeneratedColumn<String>(
    'renter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES renters (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta(
    'accountNumber',
  );
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES income_categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    amountMinor,
    sourceType,
    renterId,
    accountNumber,
    categoryId,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('renter_id')) {
      context.handle(
        _renterIdMeta,
        renterId.isAcceptableOrUnknown(data['renter_id']!, _renterIdMeta),
      );
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(
          data['account_number']!,
          _accountNumberMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      renterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}renter_id'],
      ),
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $IncomeLinesTable createAlias(String alias) {
    return $IncomeLinesTable(attachedDatabase, alias);
  }
}

class IncomeLineRow extends DataClass implements Insertable<IncomeLineRow> {
  final String id;
  final String documentId;
  final int amountMinor;
  final String sourceType;
  final String? renterId;
  final String? accountNumber;
  final int? categoryId;
  final String note;
  final DateTime createdAt;
  const IncomeLineRow({
    required this.id,
    required this.documentId,
    required this.amountMinor,
    required this.sourceType,
    this.renterId,
    this.accountNumber,
    this.categoryId,
    required this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['document_id'] = Variable<String>(documentId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || renterId != null) {
      map['renter_id'] = Variable<String>(renterId);
    }
    if (!nullToAbsent || accountNumber != null) {
      map['account_number'] = Variable<String>(accountNumber);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IncomeLinesCompanion toCompanion(bool nullToAbsent) {
    return IncomeLinesCompanion(
      id: Value(id),
      documentId: Value(documentId),
      amountMinor: Value(amountMinor),
      sourceType: Value(sourceType),
      renterId: renterId == null && nullToAbsent
          ? const Value.absent()
          : Value(renterId),
      accountNumber: accountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumber),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      note: Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory IncomeLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeLineRow(
      id: serializer.fromJson<String>(json['id']),
      documentId: serializer.fromJson<String>(json['documentId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      renterId: serializer.fromJson<String?>(json['renterId']),
      accountNumber: serializer.fromJson<String?>(json['accountNumber']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'documentId': serializer.toJson<String>(documentId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'sourceType': serializer.toJson<String>(sourceType),
      'renterId': serializer.toJson<String?>(renterId),
      'accountNumber': serializer.toJson<String?>(accountNumber),
      'categoryId': serializer.toJson<int?>(categoryId),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  IncomeLineRow copyWith({
    String? id,
    String? documentId,
    int? amountMinor,
    String? sourceType,
    Value<String?> renterId = const Value.absent(),
    Value<String?> accountNumber = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    String? note,
    DateTime? createdAt,
  }) => IncomeLineRow(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    amountMinor: amountMinor ?? this.amountMinor,
    sourceType: sourceType ?? this.sourceType,
    renterId: renterId.present ? renterId.value : this.renterId,
    accountNumber: accountNumber.present
        ? accountNumber.value
        : this.accountNumber,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  IncomeLineRow copyWithCompanion(IncomeLinesCompanion data) {
    return IncomeLineRow(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      renterId: data.renterId.present ? data.renterId.value : this.renterId,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeLineRow(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('sourceType: $sourceType, ')
          ..write('renterId: $renterId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentId,
    amountMinor,
    sourceType,
    renterId,
    accountNumber,
    categoryId,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeLineRow &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.amountMinor == this.amountMinor &&
          other.sourceType == this.sourceType &&
          other.renterId == this.renterId &&
          other.accountNumber == this.accountNumber &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class IncomeLinesCompanion extends UpdateCompanion<IncomeLineRow> {
  final Value<String> id;
  final Value<String> documentId;
  final Value<int> amountMinor;
  final Value<String> sourceType;
  final Value<String?> renterId;
  final Value<String?> accountNumber;
  final Value<int?> categoryId;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const IncomeLinesCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.renterId = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeLinesCompanion.insert({
    required String id,
    required String documentId,
    required int amountMinor,
    required String sourceType,
    this.renterId = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       documentId = Value(documentId),
       amountMinor = Value(amountMinor),
       sourceType = Value(sourceType),
       createdAt = Value(createdAt);
  static Insertable<IncomeLineRow> custom({
    Expression<String>? id,
    Expression<String>? documentId,
    Expression<int>? amountMinor,
    Expression<String>? sourceType,
    Expression<String>? renterId,
    Expression<String>? accountNumber,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (sourceType != null) 'source_type': sourceType,
      if (renterId != null) 'renter_id': renterId,
      if (accountNumber != null) 'account_number': accountNumber,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? documentId,
    Value<int>? amountMinor,
    Value<String>? sourceType,
    Value<String?>? renterId,
    Value<String?>? accountNumber,
    Value<int?>? categoryId,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return IncomeLinesCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      amountMinor: amountMinor ?? this.amountMinor,
      sourceType: sourceType ?? this.sourceType,
      renterId: renterId ?? this.renterId,
      accountNumber: accountNumber ?? this.accountNumber,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (renterId.present) {
      map['renter_id'] = Variable<String>(renterId.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeLinesCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('sourceType: $sourceType, ')
          ..write('renterId: $renterId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseDocumentsTable extends ExpenseDocuments
    with TableInfo<$ExpenseDocumentsTable, ExpenseDocumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountRefMeta = const VerificationMeta(
    'accountRef',
  );
  @override
  late final GeneratedColumn<String> accountRef = GeneratedColumn<String>(
    'account_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseId,
    date,
    accountType,
    accountRef,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseDocumentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_id')) {
      context.handle(
        _baseIdMeta,
        baseId.isAcceptableOrUnknown(data['base_id']!, _baseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_baseIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('account_ref')) {
      context.handle(
        _accountRefMeta,
        accountRef.isAcceptableOrUnknown(data['account_ref']!, _accountRefMeta),
      );
    } else if (isInserting) {
      context.missing(_accountRefMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseDocumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseDocumentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      baseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      accountRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_ref'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExpenseDocumentsTable createAlias(String alias) {
    return $ExpenseDocumentsTable(attachedDatabase, alias);
  }
}

class ExpenseDocumentRow extends DataClass
    implements Insertable<ExpenseDocumentRow> {
  final String id;
  final String baseId;
  final DateTime date;
  final String accountType;
  final String accountRef;
  final DateTime createdAt;
  const ExpenseDocumentRow({
    required this.id,
    required this.baseId,
    required this.date,
    required this.accountType,
    required this.accountRef,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_id'] = Variable<String>(baseId);
    map['date'] = Variable<DateTime>(date);
    map['account_type'] = Variable<String>(accountType);
    map['account_ref'] = Variable<String>(accountRef);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseDocumentsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseDocumentsCompanion(
      id: Value(id),
      baseId: Value(baseId),
      date: Value(date),
      accountType: Value(accountType),
      accountRef: Value(accountRef),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseDocumentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseDocumentRow(
      id: serializer.fromJson<String>(json['id']),
      baseId: serializer.fromJson<String>(json['baseId']),
      date: serializer.fromJson<DateTime>(json['date']),
      accountType: serializer.fromJson<String>(json['accountType']),
      accountRef: serializer.fromJson<String>(json['accountRef']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseId': serializer.toJson<String>(baseId),
      'date': serializer.toJson<DateTime>(date),
      'accountType': serializer.toJson<String>(accountType),
      'accountRef': serializer.toJson<String>(accountRef),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseDocumentRow copyWith({
    String? id,
    String? baseId,
    DateTime? date,
    String? accountType,
    String? accountRef,
    DateTime? createdAt,
  }) => ExpenseDocumentRow(
    id: id ?? this.id,
    baseId: baseId ?? this.baseId,
    date: date ?? this.date,
    accountType: accountType ?? this.accountType,
    accountRef: accountRef ?? this.accountRef,
    createdAt: createdAt ?? this.createdAt,
  );
  ExpenseDocumentRow copyWithCompanion(ExpenseDocumentsCompanion data) {
    return ExpenseDocumentRow(
      id: data.id.present ? data.id.value : this.id,
      baseId: data.baseId.present ? data.baseId.value : this.baseId,
      date: data.date.present ? data.date.value : this.date,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      accountRef: data.accountRef.present
          ? data.accountRef.value
          : this.accountRef,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseDocumentRow(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('date: $date, ')
          ..write('accountType: $accountType, ')
          ..write('accountRef: $accountRef, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, baseId, date, accountType, accountRef, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseDocumentRow &&
          other.id == this.id &&
          other.baseId == this.baseId &&
          other.date == this.date &&
          other.accountType == this.accountType &&
          other.accountRef == this.accountRef &&
          other.createdAt == this.createdAt);
}

class ExpenseDocumentsCompanion extends UpdateCompanion<ExpenseDocumentRow> {
  final Value<String> id;
  final Value<String> baseId;
  final Value<DateTime> date;
  final Value<String> accountType;
  final Value<String> accountRef;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseDocumentsCompanion({
    this.id = const Value.absent(),
    this.baseId = const Value.absent(),
    this.date = const Value.absent(),
    this.accountType = const Value.absent(),
    this.accountRef = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseDocumentsCompanion.insert({
    required String id,
    required String baseId,
    required DateTime date,
    required String accountType,
    required String accountRef,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       baseId = Value(baseId),
       date = Value(date),
       accountType = Value(accountType),
       accountRef = Value(accountRef),
       createdAt = Value(createdAt);
  static Insertable<ExpenseDocumentRow> custom({
    Expression<String>? id,
    Expression<String>? baseId,
    Expression<DateTime>? date,
    Expression<String>? accountType,
    Expression<String>? accountRef,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseId != null) 'base_id': baseId,
      if (date != null) 'date': date,
      if (accountType != null) 'account_type': accountType,
      if (accountRef != null) 'account_ref': accountRef,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? baseId,
    Value<DateTime>? date,
    Value<String>? accountType,
    Value<String>? accountRef,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ExpenseDocumentsCompanion(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      date: date ?? this.date,
      accountType: accountType ?? this.accountType,
      accountRef: accountRef ?? this.accountRef,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseId.present) {
      map['base_id'] = Variable<String>(baseId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (accountRef.present) {
      map['account_ref'] = Variable<String>(accountRef.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('baseId: $baseId, ')
          ..write('date: $date, ')
          ..write('accountType: $accountType, ')
          ..write('accountRef: $accountRef, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseLinesTable extends ExpenseLines
    with TableInfo<$ExpenseLinesTable, ExpenseLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expense_documents (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expense_categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    amountMinor,
    categoryId,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExpenseLinesTable createAlias(String alias) {
    return $ExpenseLinesTable(attachedDatabase, alias);
  }
}

class ExpenseLineRow extends DataClass implements Insertable<ExpenseLineRow> {
  final String id;
  final String documentId;
  final int amountMinor;
  final int categoryId;
  final String note;
  final DateTime createdAt;
  const ExpenseLineRow({
    required this.id,
    required this.documentId,
    required this.amountMinor,
    required this.categoryId,
    required this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['document_id'] = Variable<String>(documentId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['category_id'] = Variable<int>(categoryId);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseLinesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseLinesCompanion(
      id: Value(id),
      documentId: Value(documentId),
      amountMinor: Value(amountMinor),
      categoryId: Value(categoryId),
      note: Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseLineRow(
      id: serializer.fromJson<String>(json['id']),
      documentId: serializer.fromJson<String>(json['documentId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'documentId': serializer.toJson<String>(documentId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'categoryId': serializer.toJson<int>(categoryId),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseLineRow copyWith({
    String? id,
    String? documentId,
    int? amountMinor,
    int? categoryId,
    String? note,
    DateTime? createdAt,
  }) => ExpenseLineRow(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    amountMinor: amountMinor ?? this.amountMinor,
    categoryId: categoryId ?? this.categoryId,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  ExpenseLineRow copyWithCompanion(ExpenseLinesCompanion data) {
    return ExpenseLineRow(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseLineRow(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, documentId, amountMinor, categoryId, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseLineRow &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.amountMinor == this.amountMinor &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class ExpenseLinesCompanion extends UpdateCompanion<ExpenseLineRow> {
  final Value<String> id;
  final Value<String> documentId;
  final Value<int> amountMinor;
  final Value<int> categoryId;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseLinesCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseLinesCompanion.insert({
    required String id,
    required String documentId,
    required int amountMinor,
    required int categoryId,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       documentId = Value(documentId),
       amountMinor = Value(amountMinor),
       categoryId = Value(categoryId),
       createdAt = Value(createdAt);
  static Insertable<ExpenseLineRow> custom({
    Expression<String>? id,
    Expression<String>? documentId,
    Expression<int>? amountMinor,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? documentId,
    Value<int>? amountMinor,
    Value<int>? categoryId,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ExpenseLinesCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      amountMinor: amountMinor ?? this.amountMinor,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseLinesCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
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
  late final $RentersTable renters = $RentersTable(this);
  late final $IncomeCategoriesTable incomeCategories = $IncomeCategoriesTable(
    this,
  );
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $BankStatementOperationsTable bankStatementOperations =
      $BankStatementOperationsTable(this);
  late final $RenterAccountNumbersTable renterAccountNumbers =
      $RenterAccountNumbersTable(this);
  late final $RenterAssignmentsTable renterAssignments =
      $RenterAssignmentsTable(this);
  late final $ExpenseCategoryAccountNumbersTable expenseCategoryAccountNumbers =
      $ExpenseCategoryAccountNumbersTable(this);
  late final $IncomeDocumentsTable incomeDocuments = $IncomeDocumentsTable(
    this,
  );
  late final $IncomeLinesTable incomeLines = $IncomeLinesTable(this);
  late final $ExpenseDocumentsTable expenseDocuments = $ExpenseDocumentsTable(
    this,
  );
  late final $ExpenseLinesTable expenseLines = $ExpenseLinesTable(this);
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
    renters,
    incomeCategories,
    expenseCategories,
    bankStatementOperations,
    renterAccountNumbers,
    renterAssignments,
    expenseCategoryAccountNumbers,
    incomeDocuments,
    incomeLines,
    expenseDocuments,
    expenseLines,
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
        'bases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('renters', kind: UpdateKind.delete)],
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'renters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('bank_statement_operations', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'income_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('bank_statement_operations', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'expense_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('bank_statement_operations', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'renters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('renter_account_numbers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('renter_assignments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'renters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('renter_assignments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate(
          'expense_category_account_numbers',
          kind: UpdateKind.delete,
        ),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'expense_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate(
          'expense_category_account_numbers',
          kind: UpdateKind.delete,
        ),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('income_documents', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'income_documents',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('income_lines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expense_documents', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'expense_documents',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expense_lines', kind: UpdateKind.delete)],
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

  static MultiTypedResultKey<$RentersTable, List<RenterRow>> _rentersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.renters,
    aliasName: $_aliasNameGenerator(db.bases.id, db.renters.baseId),
  );

  $$RentersTableProcessedTableManager get rentersRefs {
    final manager = $$RentersTableTableManager(
      $_db,
      $_db.renters,
    ).filter((f) => f.baseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rentersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RenterAssignmentsTable, List<RenterAssignmentRow>>
  _renterAssignmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.renterAssignments,
        aliasName: $_aliasNameGenerator(
          db.bases.id,
          db.renterAssignments.baseId,
        ),
      );

  $$RenterAssignmentsTableProcessedTableManager get renterAssignmentsRefs {
    final manager = $$RenterAssignmentsTableTableManager(
      $_db,
      $_db.renterAssignments,
    ).filter((f) => f.baseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _renterAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ExpenseCategoryAccountNumbersTable,
    List<ExpenseCategoryAccountNumber>
  >
  _expenseCategoryAccountNumbersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.expenseCategoryAccountNumbers,
        aliasName: $_aliasNameGenerator(
          db.bases.id,
          db.expenseCategoryAccountNumbers.baseId,
        ),
      );

  $$ExpenseCategoryAccountNumbersTableProcessedTableManager
  get expenseCategoryAccountNumbersRefs {
    final manager = $$ExpenseCategoryAccountNumbersTableTableManager(
      $_db,
      $_db.expenseCategoryAccountNumbers,
    ).filter((f) => f.baseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _expenseCategoryAccountNumbersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IncomeDocumentsTable, List<IncomeDocumentRow>>
  _incomeDocumentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeDocuments,
    aliasName: $_aliasNameGenerator(db.bases.id, db.incomeDocuments.baseId),
  );

  $$IncomeDocumentsTableProcessedTableManager get incomeDocumentsRefs {
    final manager = $$IncomeDocumentsTableTableManager(
      $_db,
      $_db.incomeDocuments,
    ).filter((f) => f.baseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _incomeDocumentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpenseDocumentsTable, List<ExpenseDocumentRow>>
  _expenseDocumentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenseDocuments,
    aliasName: $_aliasNameGenerator(db.bases.id, db.expenseDocuments.baseId),
  );

  $$ExpenseDocumentsTableProcessedTableManager get expenseDocumentsRefs {
    final manager = $$ExpenseDocumentsTableTableManager(
      $_db,
      $_db.expenseDocuments,
    ).filter((f) => f.baseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _expenseDocumentsRefsTable($_db),
    );
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

  Expression<bool> rentersRefs(
    Expression<bool> Function($$RentersTableFilterComposer f) f,
  ) {
    final $$RentersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableFilterComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> renterAssignmentsRefs(
    Expression<bool> Function($$RenterAssignmentsTableFilterComposer f) f,
  ) {
    final $$RenterAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.renterAssignments,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RenterAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.renterAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expenseCategoryAccountNumbersRefs(
    Expression<bool> Function(
      $$ExpenseCategoryAccountNumbersTableFilterComposer f,
    )
    f,
  ) {
    final $$ExpenseCategoryAccountNumbersTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.expenseCategoryAccountNumbers,
          getReferencedColumn: (t) => t.baseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoryAccountNumbersTableFilterComposer(
                $db: $db,
                $table: $db.expenseCategoryAccountNumbers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> incomeDocumentsRefs(
    Expression<bool> Function($$IncomeDocumentsTableFilterComposer f) f,
  ) {
    final $$IncomeDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeDocuments,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.incomeDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expenseDocumentsRefs(
    Expression<bool> Function($$ExpenseDocumentsTableFilterComposer f) f,
  ) {
    final $$ExpenseDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseDocuments,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.expenseDocuments,
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

  Expression<T> rentersRefs<T extends Object>(
    Expression<T> Function($$RentersTableAnnotationComposer a) f,
  ) {
    final $$RentersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableAnnotationComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> renterAssignmentsRefs<T extends Object>(
    Expression<T> Function($$RenterAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$RenterAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.renterAssignments,
          getReferencedColumn: (t) => t.baseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RenterAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.renterAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> expenseCategoryAccountNumbersRefs<T extends Object>(
    Expression<T> Function(
      $$ExpenseCategoryAccountNumbersTableAnnotationComposer a,
    )
    f,
  ) {
    final $$ExpenseCategoryAccountNumbersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.expenseCategoryAccountNumbers,
          getReferencedColumn: (t) => t.baseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoryAccountNumbersTableAnnotationComposer(
                $db: $db,
                $table: $db.expenseCategoryAccountNumbers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> incomeDocumentsRefs<T extends Object>(
    Expression<T> Function($$IncomeDocumentsTableAnnotationComposer a) f,
  ) {
    final $$IncomeDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeDocuments,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expenseDocumentsRefs<T extends Object>(
    Expression<T> Function($$ExpenseDocumentsTableAnnotationComposer a) f,
  ) {
    final $$ExpenseDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseDocuments,
      getReferencedColumn: (t) => t.baseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.expenseDocuments,
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
            bool rentersRefs,
            bool renterAssignmentsRefs,
            bool expenseCategoryAccountNumbersRefs,
            bool incomeDocumentsRefs,
            bool expenseDocumentsRefs,
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
              ({
                baseAccountNumbersRefs = false,
                bankStatementsRefs = false,
                rentersRefs = false,
                renterAssignmentsRefs = false,
                expenseCategoryAccountNumbersRefs = false,
                incomeDocumentsRefs = false,
                expenseDocumentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (baseAccountNumbersRefs) db.baseAccountNumbers,
                    if (bankStatementsRefs) db.bankStatements,
                    if (rentersRefs) db.renters,
                    if (renterAssignmentsRefs) db.renterAssignments,
                    if (expenseCategoryAccountNumbersRefs)
                      db.expenseCategoryAccountNumbers,
                    if (incomeDocumentsRefs) db.incomeDocuments,
                    if (expenseDocumentsRefs) db.expenseDocuments,
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
                      if (rentersRefs)
                        await $_getPrefetchedData<
                          BaseRow,
                          $BasesTable,
                          RenterRow
                        >(
                          currentTable: table,
                          referencedTable: $$BasesTableReferences
                              ._rentersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BasesTableReferences(db, table, p0).rentersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.baseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (renterAssignmentsRefs)
                        await $_getPrefetchedData<
                          BaseRow,
                          $BasesTable,
                          RenterAssignmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$BasesTableReferences
                              ._renterAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BasesTableReferences(
                                db,
                                table,
                                p0,
                              ).renterAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.baseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expenseCategoryAccountNumbersRefs)
                        await $_getPrefetchedData<
                          BaseRow,
                          $BasesTable,
                          ExpenseCategoryAccountNumber
                        >(
                          currentTable: table,
                          referencedTable: $$BasesTableReferences
                              ._expenseCategoryAccountNumbersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BasesTableReferences(
                                db,
                                table,
                                p0,
                              ).expenseCategoryAccountNumbersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.baseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomeDocumentsRefs)
                        await $_getPrefetchedData<
                          BaseRow,
                          $BasesTable,
                          IncomeDocumentRow
                        >(
                          currentTable: table,
                          referencedTable: $$BasesTableReferences
                              ._incomeDocumentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BasesTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeDocumentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.baseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expenseDocumentsRefs)
                        await $_getPrefetchedData<
                          BaseRow,
                          $BasesTable,
                          ExpenseDocumentRow
                        >(
                          currentTable: table,
                          referencedTable: $$BasesTableReferences
                              ._expenseDocumentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BasesTableReferences(
                                db,
                                table,
                                p0,
                              ).expenseDocumentsRefs,
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
        bool rentersRefs,
        bool renterAssignmentsRefs,
        bool expenseCategoryAccountNumbersRefs,
        bool incomeDocumentsRefs,
        bool expenseDocumentsRefs,
      })
    >;
typedef $$BaseAccountNumbersTableCreateCompanionBuilder =
    BaseAccountNumbersCompanion Function({
      Value<int> id,
      required String baseId,
      required String accountNumber,
      Value<String> bankName,
    });
typedef $$BaseAccountNumbersTableUpdateCompanionBuilder =
    BaseAccountNumbersCompanion Function({
      Value<int> id,
      Value<String> baseId,
      Value<String> accountNumber,
      Value<String> bankName,
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

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
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

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
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

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

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
                Value<String> bankName = const Value.absent(),
              }) => BaseAccountNumbersCompanion(
                id: id,
                baseId: baseId,
                accountNumber: accountNumber,
                bankName: bankName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String baseId,
                required String accountNumber,
                Value<String> bankName = const Value.absent(),
              }) => BaseAccountNumbersCompanion.insert(
                id: id,
                baseId: baseId,
                accountNumber: accountNumber,
                bankName: bankName,
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
typedef $$RentersTableCreateCompanionBuilder =
    RentersCompanion Function({
      required String id,
      required String baseId,
      required String name,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$RentersTableUpdateCompanionBuilder =
    RentersCompanion Function({
      Value<String> id,
      Value<String> baseId,
      Value<String> name,
      Value<bool> isArchived,
      Value<int> rowid,
    });

final class $$RentersTableReferences
    extends BaseReferences<_$AppDatabase, $RentersTable, RenterRow> {
  $$RentersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BasesTable _baseIdTable(_$AppDatabase db) => db.bases.createAlias(
    $_aliasNameGenerator(db.renters.baseId, db.bases.id),
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

  static MultiTypedResultKey<
    $BankStatementOperationsTable,
    List<BankStatementOperationRow>
  >
  _bankStatementOperationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.bankStatementOperations,
        aliasName: $_aliasNameGenerator(
          db.renters.id,
          db.bankStatementOperations.renterId,
        ),
      );

  $$BankStatementOperationsTableProcessedTableManager
  get bankStatementOperationsRefs {
    final manager = $$BankStatementOperationsTableTableManager(
      $_db,
      $_db.bankStatementOperations,
    ).filter((f) => f.renterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bankStatementOperationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RenterAccountNumbersTable,
    List<RenterAccountNumber>
  >
  _renterAccountNumbersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.renterAccountNumbers,
        aliasName: $_aliasNameGenerator(
          db.renters.id,
          db.renterAccountNumbers.renterId,
        ),
      );

  $$RenterAccountNumbersTableProcessedTableManager
  get renterAccountNumbersRefs {
    final manager = $$RenterAccountNumbersTableTableManager(
      $_db,
      $_db.renterAccountNumbers,
    ).filter((f) => f.renterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _renterAccountNumbersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RenterAssignmentsTable, List<RenterAssignmentRow>>
  _renterAssignmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.renterAssignments,
        aliasName: $_aliasNameGenerator(
          db.renters.id,
          db.renterAssignments.renterId,
        ),
      );

  $$RenterAssignmentsTableProcessedTableManager get renterAssignmentsRefs {
    final manager = $$RenterAssignmentsTableTableManager(
      $_db,
      $_db.renterAssignments,
    ).filter((f) => f.renterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _renterAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IncomeLinesTable, List<IncomeLineRow>>
  _incomeLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeLines,
    aliasName: $_aliasNameGenerator(db.renters.id, db.incomeLines.renterId),
  );

  $$IncomeLinesTableProcessedTableManager get incomeLinesRefs {
    final manager = $$IncomeLinesTableTableManager(
      $_db,
      $_db.incomeLines,
    ).filter((f) => f.renterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomeLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RentersTableFilterComposer
    extends Composer<_$AppDatabase, $RentersTable> {
  $$RentersTableFilterComposer({
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

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  Expression<bool> bankStatementOperationsRefs(
    Expression<bool> Function($$BankStatementOperationsTableFilterComposer f) f,
  ) {
    final $$BankStatementOperationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bankStatementOperations,
          getReferencedColumn: (t) => t.renterId,
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

  Expression<bool> renterAccountNumbersRefs(
    Expression<bool> Function($$RenterAccountNumbersTableFilterComposer f) f,
  ) {
    final $$RenterAccountNumbersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.renterAccountNumbers,
      getReferencedColumn: (t) => t.renterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RenterAccountNumbersTableFilterComposer(
            $db: $db,
            $table: $db.renterAccountNumbers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> renterAssignmentsRefs(
    Expression<bool> Function($$RenterAssignmentsTableFilterComposer f) f,
  ) {
    final $$RenterAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.renterAssignments,
      getReferencedColumn: (t) => t.renterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RenterAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.renterAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomeLinesRefs(
    Expression<bool> Function($$IncomeLinesTableFilterComposer f) f,
  ) {
    final $$IncomeLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeLines,
      getReferencedColumn: (t) => t.renterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeLinesTableFilterComposer(
            $db: $db,
            $table: $db.incomeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RentersTableOrderingComposer
    extends Composer<_$AppDatabase, $RentersTable> {
  $$RentersTableOrderingComposer({
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

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

class $$RentersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RentersTable> {
  $$RentersTableAnnotationComposer({
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

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  Expression<T> bankStatementOperationsRefs<T extends Object>(
    Expression<T> Function($$BankStatementOperationsTableAnnotationComposer a)
    f,
  ) {
    final $$BankStatementOperationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bankStatementOperations,
          getReferencedColumn: (t) => t.renterId,
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

  Expression<T> renterAccountNumbersRefs<T extends Object>(
    Expression<T> Function($$RenterAccountNumbersTableAnnotationComposer a) f,
  ) {
    final $$RenterAccountNumbersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.renterAccountNumbers,
          getReferencedColumn: (t) => t.renterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RenterAccountNumbersTableAnnotationComposer(
                $db: $db,
                $table: $db.renterAccountNumbers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> renterAssignmentsRefs<T extends Object>(
    Expression<T> Function($$RenterAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$RenterAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.renterAssignments,
          getReferencedColumn: (t) => t.renterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RenterAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.renterAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> incomeLinesRefs<T extends Object>(
    Expression<T> Function($$IncomeLinesTableAnnotationComposer a) f,
  ) {
    final $$IncomeLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeLines,
      getReferencedColumn: (t) => t.renterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RentersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RentersTable,
          RenterRow,
          $$RentersTableFilterComposer,
          $$RentersTableOrderingComposer,
          $$RentersTableAnnotationComposer,
          $$RentersTableCreateCompanionBuilder,
          $$RentersTableUpdateCompanionBuilder,
          (RenterRow, $$RentersTableReferences),
          RenterRow,
          PrefetchHooks Function({
            bool baseId,
            bool bankStatementOperationsRefs,
            bool renterAccountNumbersRefs,
            bool renterAssignmentsRefs,
            bool incomeLinesRefs,
          })
        > {
  $$RentersTableTableManager(_$AppDatabase db, $RentersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RentersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RentersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RentersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> baseId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RentersCompanion(
                id: id,
                baseId: baseId,
                name: name,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String baseId,
                required String name,
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RentersCompanion.insert(
                id: id,
                baseId: baseId,
                name: name,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RentersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                baseId = false,
                bankStatementOperationsRefs = false,
                renterAccountNumbersRefs = false,
                renterAssignmentsRefs = false,
                incomeLinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bankStatementOperationsRefs) db.bankStatementOperations,
                    if (renterAccountNumbersRefs) db.renterAccountNumbers,
                    if (renterAssignmentsRefs) db.renterAssignments,
                    if (incomeLinesRefs) db.incomeLines,
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
                                    referencedTable: $$RentersTableReferences
                                        ._baseIdTable(db),
                                    referencedColumn: $$RentersTableReferences
                                        ._baseIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bankStatementOperationsRefs)
                        await $_getPrefetchedData<
                          RenterRow,
                          $RentersTable,
                          BankStatementOperationRow
                        >(
                          currentTable: table,
                          referencedTable: $$RentersTableReferences
                              ._bankStatementOperationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RentersTableReferences(
                                db,
                                table,
                                p0,
                              ).bankStatementOperationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.renterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (renterAccountNumbersRefs)
                        await $_getPrefetchedData<
                          RenterRow,
                          $RentersTable,
                          RenterAccountNumber
                        >(
                          currentTable: table,
                          referencedTable: $$RentersTableReferences
                              ._renterAccountNumbersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RentersTableReferences(
                                db,
                                table,
                                p0,
                              ).renterAccountNumbersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.renterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (renterAssignmentsRefs)
                        await $_getPrefetchedData<
                          RenterRow,
                          $RentersTable,
                          RenterAssignmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$RentersTableReferences
                              ._renterAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RentersTableReferences(
                                db,
                                table,
                                p0,
                              ).renterAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.renterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomeLinesRefs)
                        await $_getPrefetchedData<
                          RenterRow,
                          $RentersTable,
                          IncomeLineRow
                        >(
                          currentTable: table,
                          referencedTable: $$RentersTableReferences
                              ._incomeLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RentersTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.renterId == item.id,
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

typedef $$RentersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RentersTable,
      RenterRow,
      $$RentersTableFilterComposer,
      $$RentersTableOrderingComposer,
      $$RentersTableAnnotationComposer,
      $$RentersTableCreateCompanionBuilder,
      $$RentersTableUpdateCompanionBuilder,
      (RenterRow, $$RentersTableReferences),
      RenterRow,
      PrefetchHooks Function({
        bool baseId,
        bool bankStatementOperationsRefs,
        bool renterAccountNumbersRefs,
        bool renterAssignmentsRefs,
        bool incomeLinesRefs,
      })
    >;
typedef $$IncomeCategoriesTableCreateCompanionBuilder =
    IncomeCategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isArchived,
      Value<int> sortOrder,
      required DateTime createdAt,
    });
typedef $$IncomeCategoriesTableUpdateCompanionBuilder =
    IncomeCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isArchived,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });

final class $$IncomeCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IncomeCategoriesTable,
          IncomeCategoryRow
        > {
  $$IncomeCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $BankStatementOperationsTable,
    List<BankStatementOperationRow>
  >
  _bankStatementOperationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.bankStatementOperations,
        aliasName: $_aliasNameGenerator(
          db.incomeCategories.id,
          db.bankStatementOperations.incomeCategoryId,
        ),
      );

  $$BankStatementOperationsTableProcessedTableManager
  get bankStatementOperationsRefs {
    final manager = $$BankStatementOperationsTableTableManager(
      $_db,
      $_db.bankStatementOperations,
    ).filter((f) => f.incomeCategoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bankStatementOperationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IncomeLinesTable, List<IncomeLineRow>>
  _incomeLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeLines,
    aliasName: $_aliasNameGenerator(
      db.incomeCategories.id,
      db.incomeLines.categoryId,
    ),
  );

  $$IncomeLinesTableProcessedTableManager get incomeLinesRefs {
    final manager = $$IncomeLinesTableTableManager(
      $_db,
      $_db.incomeLines,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomeLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IncomeCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeCategoriesTable> {
  $$IncomeCategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bankStatementOperationsRefs(
    Expression<bool> Function($$BankStatementOperationsTableFilterComposer f) f,
  ) {
    final $$BankStatementOperationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bankStatementOperations,
          getReferencedColumn: (t) => t.incomeCategoryId,
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

  Expression<bool> incomeLinesRefs(
    Expression<bool> Function($$IncomeLinesTableFilterComposer f) f,
  ) {
    final $$IncomeLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeLines,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeLinesTableFilterComposer(
            $db: $db,
            $table: $db.incomeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeCategoriesTable> {
  $$IncomeCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IncomeCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeCategoriesTable> {
  $$IncomeCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> bankStatementOperationsRefs<T extends Object>(
    Expression<T> Function($$BankStatementOperationsTableAnnotationComposer a)
    f,
  ) {
    final $$BankStatementOperationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bankStatementOperations,
          getReferencedColumn: (t) => t.incomeCategoryId,
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

  Expression<T> incomeLinesRefs<T extends Object>(
    Expression<T> Function($$IncomeLinesTableAnnotationComposer a) f,
  ) {
    final $$IncomeLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeLines,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeCategoriesTable,
          IncomeCategoryRow,
          $$IncomeCategoriesTableFilterComposer,
          $$IncomeCategoriesTableOrderingComposer,
          $$IncomeCategoriesTableAnnotationComposer,
          $$IncomeCategoriesTableCreateCompanionBuilder,
          $$IncomeCategoriesTableUpdateCompanionBuilder,
          (IncomeCategoryRow, $$IncomeCategoriesTableReferences),
          IncomeCategoryRow,
          PrefetchHooks Function({
            bool bankStatementOperationsRefs,
            bool incomeLinesRefs,
          })
        > {
  $$IncomeCategoriesTableTableManager(
    _$AppDatabase db,
    $IncomeCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => IncomeCategoriesCompanion(
                id: id,
                name: name,
                isArchived: isArchived,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isArchived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
              }) => IncomeCategoriesCompanion.insert(
                id: id,
                name: name,
                isArchived: isArchived,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncomeCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bankStatementOperationsRefs = false, incomeLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bankStatementOperationsRefs) db.bankStatementOperations,
                    if (incomeLinesRefs) db.incomeLines,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bankStatementOperationsRefs)
                        await $_getPrefetchedData<
                          IncomeCategoryRow,
                          $IncomeCategoriesTable,
                          BankStatementOperationRow
                        >(
                          currentTable: table,
                          referencedTable: $$IncomeCategoriesTableReferences
                              ._bankStatementOperationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncomeCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).bankStatementOperationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.incomeCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomeLinesRefs)
                        await $_getPrefetchedData<
                          IncomeCategoryRow,
                          $IncomeCategoriesTable,
                          IncomeLineRow
                        >(
                          currentTable: table,
                          referencedTable: $$IncomeCategoriesTableReferences
                              ._incomeLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncomeCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
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

typedef $$IncomeCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeCategoriesTable,
      IncomeCategoryRow,
      $$IncomeCategoriesTableFilterComposer,
      $$IncomeCategoriesTableOrderingComposer,
      $$IncomeCategoriesTableAnnotationComposer,
      $$IncomeCategoriesTableCreateCompanionBuilder,
      $$IncomeCategoriesTableUpdateCompanionBuilder,
      (IncomeCategoryRow, $$IncomeCategoriesTableReferences),
      IncomeCategoryRow,
      PrefetchHooks Function({
        bool bankStatementOperationsRefs,
        bool incomeLinesRefs,
      })
    >;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder =
    ExpenseCategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isArchived,
      Value<int> sortOrder,
      required DateTime createdAt,
    });
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder =
    ExpenseCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isArchived,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });

final class $$ExpenseCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExpenseCategoriesTable,
          ExpenseCategoryRow
        > {
  $$ExpenseCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $BankStatementOperationsTable,
    List<BankStatementOperationRow>
  >
  _bankStatementOperationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.bankStatementOperations,
        aliasName: $_aliasNameGenerator(
          db.expenseCategories.id,
          db.bankStatementOperations.expenseCategoryId,
        ),
      );

  $$BankStatementOperationsTableProcessedTableManager
  get bankStatementOperationsRefs {
    final manager = $$BankStatementOperationsTableTableManager(
      $_db,
      $_db.bankStatementOperations,
    ).filter((f) => f.expenseCategoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bankStatementOperationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ExpenseCategoryAccountNumbersTable,
    List<ExpenseCategoryAccountNumber>
  >
  _expenseCategoryAccountNumbersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.expenseCategoryAccountNumbers,
        aliasName: $_aliasNameGenerator(
          db.expenseCategories.id,
          db.expenseCategoryAccountNumbers.expenseCategoryId,
        ),
      );

  $$ExpenseCategoryAccountNumbersTableProcessedTableManager
  get expenseCategoryAccountNumbersRefs {
    final manager = $$ExpenseCategoryAccountNumbersTableTableManager(
      $_db,
      $_db.expenseCategoryAccountNumbers,
    ).filter((f) => f.expenseCategoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _expenseCategoryAccountNumbersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpenseLinesTable, List<ExpenseLineRow>>
  _expenseLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenseLines,
    aliasName: $_aliasNameGenerator(
      db.expenseCategories.id,
      db.expenseLines.categoryId,
    ),
  );

  $$ExpenseLinesTableProcessedTableManager get expenseLinesRefs {
    final manager = $$ExpenseLinesTableTableManager(
      $_db,
      $_db.expenseLines,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expenseLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bankStatementOperationsRefs(
    Expression<bool> Function($$BankStatementOperationsTableFilterComposer f) f,
  ) {
    final $$BankStatementOperationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bankStatementOperations,
          getReferencedColumn: (t) => t.expenseCategoryId,
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

  Expression<bool> expenseCategoryAccountNumbersRefs(
    Expression<bool> Function(
      $$ExpenseCategoryAccountNumbersTableFilterComposer f,
    )
    f,
  ) {
    final $$ExpenseCategoryAccountNumbersTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.expenseCategoryAccountNumbers,
          getReferencedColumn: (t) => t.expenseCategoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoryAccountNumbersTableFilterComposer(
                $db: $db,
                $table: $db.expenseCategoryAccountNumbers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> expenseLinesRefs(
    Expression<bool> Function($$ExpenseLinesTableFilterComposer f) f,
  ) {
    final $$ExpenseLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseLines,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseLinesTableFilterComposer(
            $db: $db,
            $table: $db.expenseLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> bankStatementOperationsRefs<T extends Object>(
    Expression<T> Function($$BankStatementOperationsTableAnnotationComposer a)
    f,
  ) {
    final $$BankStatementOperationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bankStatementOperations,
          getReferencedColumn: (t) => t.expenseCategoryId,
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

  Expression<T> expenseCategoryAccountNumbersRefs<T extends Object>(
    Expression<T> Function(
      $$ExpenseCategoryAccountNumbersTableAnnotationComposer a,
    )
    f,
  ) {
    final $$ExpenseCategoryAccountNumbersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.expenseCategoryAccountNumbers,
          getReferencedColumn: (t) => t.expenseCategoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoryAccountNumbersTableAnnotationComposer(
                $db: $db,
                $table: $db.expenseCategoryAccountNumbers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> expenseLinesRefs<T extends Object>(
    Expression<T> Function($$ExpenseLinesTableAnnotationComposer a) f,
  ) {
    final $$ExpenseLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseLines,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenseLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpenseCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseCategoriesTable,
          ExpenseCategoryRow,
          $$ExpenseCategoriesTableFilterComposer,
          $$ExpenseCategoriesTableOrderingComposer,
          $$ExpenseCategoriesTableAnnotationComposer,
          $$ExpenseCategoriesTableCreateCompanionBuilder,
          $$ExpenseCategoriesTableUpdateCompanionBuilder,
          (ExpenseCategoryRow, $$ExpenseCategoriesTableReferences),
          ExpenseCategoryRow,
          PrefetchHooks Function({
            bool bankStatementOperationsRefs,
            bool expenseCategoryAccountNumbersRefs,
            bool expenseLinesRefs,
          })
        > {
  $$ExpenseCategoriesTableTableManager(
    _$AppDatabase db,
    $ExpenseCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpenseCategoriesCompanion(
                id: id,
                name: name,
                isArchived: isArchived,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isArchived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
              }) => ExpenseCategoriesCompanion.insert(
                id: id,
                name: name,
                isArchived: isArchived,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpenseCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bankStatementOperationsRefs = false,
                expenseCategoryAccountNumbersRefs = false,
                expenseLinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bankStatementOperationsRefs) db.bankStatementOperations,
                    if (expenseCategoryAccountNumbersRefs)
                      db.expenseCategoryAccountNumbers,
                    if (expenseLinesRefs) db.expenseLines,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bankStatementOperationsRefs)
                        await $_getPrefetchedData<
                          ExpenseCategoryRow,
                          $ExpenseCategoriesTable,
                          BankStatementOperationRow
                        >(
                          currentTable: table,
                          referencedTable: $$ExpenseCategoriesTableReferences
                              ._bankStatementOperationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpenseCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).bankStatementOperationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expenseCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expenseCategoryAccountNumbersRefs)
                        await $_getPrefetchedData<
                          ExpenseCategoryRow,
                          $ExpenseCategoriesTable,
                          ExpenseCategoryAccountNumber
                        >(
                          currentTable: table,
                          referencedTable: $$ExpenseCategoriesTableReferences
                              ._expenseCategoryAccountNumbersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpenseCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).expenseCategoryAccountNumbersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expenseCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expenseLinesRefs)
                        await $_getPrefetchedData<
                          ExpenseCategoryRow,
                          $ExpenseCategoriesTable,
                          ExpenseLineRow
                        >(
                          currentTable: table,
                          referencedTable: $$ExpenseCategoriesTableReferences
                              ._expenseLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpenseCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).expenseLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
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

typedef $$ExpenseCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseCategoriesTable,
      ExpenseCategoryRow,
      $$ExpenseCategoriesTableFilterComposer,
      $$ExpenseCategoriesTableOrderingComposer,
      $$ExpenseCategoriesTableAnnotationComposer,
      $$ExpenseCategoriesTableCreateCompanionBuilder,
      $$ExpenseCategoriesTableUpdateCompanionBuilder,
      (ExpenseCategoryRow, $$ExpenseCategoriesTableReferences),
      ExpenseCategoryRow,
      PrefetchHooks Function({
        bool bankStatementOperationsRefs,
        bool expenseCategoryAccountNumbersRefs,
        bool expenseLinesRefs,
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
      Value<String?> renterId,
      Value<int?> incomeCategoryId,
      Value<int?> expenseCategoryId,
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
      Value<String?> renterId,
      Value<int?> incomeCategoryId,
      Value<int?> expenseCategoryId,
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

  static $RentersTable _renterIdTable(_$AppDatabase db) =>
      db.renters.createAlias(
        $_aliasNameGenerator(
          db.bankStatementOperations.renterId,
          db.renters.id,
        ),
      );

  $$RentersTableProcessedTableManager? get renterId {
    final $_column = $_itemColumn<String>('renter_id');
    if ($_column == null) return null;
    final manager = $$RentersTableTableManager(
      $_db,
      $_db.renters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_renterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IncomeCategoriesTable _incomeCategoryIdTable(_$AppDatabase db) =>
      db.incomeCategories.createAlias(
        $_aliasNameGenerator(
          db.bankStatementOperations.incomeCategoryId,
          db.incomeCategories.id,
        ),
      );

  $$IncomeCategoriesTableProcessedTableManager? get incomeCategoryId {
    final $_column = $_itemColumn<int>('income_category_id');
    if ($_column == null) return null;
    final manager = $$IncomeCategoriesTableTableManager(
      $_db,
      $_db.incomeCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_incomeCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExpenseCategoriesTable _expenseCategoryIdTable(_$AppDatabase db) =>
      db.expenseCategories.createAlias(
        $_aliasNameGenerator(
          db.bankStatementOperations.expenseCategoryId,
          db.expenseCategories.id,
        ),
      );

  $$ExpenseCategoriesTableProcessedTableManager? get expenseCategoryId {
    final $_column = $_itemColumn<int>('expense_category_id');
    if ($_column == null) return null;
    final manager = $$ExpenseCategoriesTableTableManager(
      $_db,
      $_db.expenseCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseCategoryIdTable($_db));
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

  $$RentersTableFilterComposer get renterId {
    final $$RentersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableFilterComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeCategoriesTableFilterComposer get incomeCategoryId {
    final $$IncomeCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeCategoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpenseCategoriesTableFilterComposer get expenseCategoryId {
    final $$ExpenseCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseCategoryId,
      referencedTable: $db.expenseCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.expenseCategories,
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

  $$RentersTableOrderingComposer get renterId {
    final $$RentersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableOrderingComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeCategoriesTableOrderingComposer get incomeCategoryId {
    final $$IncomeCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeCategoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpenseCategoriesTableOrderingComposer get expenseCategoryId {
    final $$ExpenseCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseCategoryId,
      referencedTable: $db.expenseCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.expenseCategories,
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

  $$RentersTableAnnotationComposer get renterId {
    final $$RentersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableAnnotationComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeCategoriesTableAnnotationComposer get incomeCategoryId {
    final $$IncomeCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeCategoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpenseCategoriesTableAnnotationComposer get expenseCategoryId {
    final $$ExpenseCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.expenseCategoryId,
          referencedTable: $db.expenseCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.expenseCategories,
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
          PrefetchHooks Function({
            bool statementId,
            bool renterId,
            bool incomeCategoryId,
            bool expenseCategoryId,
          })
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
                Value<String?> renterId = const Value.absent(),
                Value<int?> incomeCategoryId = const Value.absent(),
                Value<int?> expenseCategoryId = const Value.absent(),
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
                renterId: renterId,
                incomeCategoryId: incomeCategoryId,
                expenseCategoryId: expenseCategoryId,
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
                Value<String?> renterId = const Value.absent(),
                Value<int?> incomeCategoryId = const Value.absent(),
                Value<int?> expenseCategoryId = const Value.absent(),
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
                renterId: renterId,
                incomeCategoryId: incomeCategoryId,
                expenseCategoryId: expenseCategoryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BankStatementOperationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                statementId = false,
                renterId = false,
                incomeCategoryId = false,
                expenseCategoryId = false,
              }) {
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
                        if (renterId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.renterId,
                                    referencedTable:
                                        $$BankStatementOperationsTableReferences
                                            ._renterIdTable(db),
                                    referencedColumn:
                                        $$BankStatementOperationsTableReferences
                                            ._renterIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (incomeCategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.incomeCategoryId,
                                    referencedTable:
                                        $$BankStatementOperationsTableReferences
                                            ._incomeCategoryIdTable(db),
                                    referencedColumn:
                                        $$BankStatementOperationsTableReferences
                                            ._incomeCategoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (expenseCategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.expenseCategoryId,
                                    referencedTable:
                                        $$BankStatementOperationsTableReferences
                                            ._expenseCategoryIdTable(db),
                                    referencedColumn:
                                        $$BankStatementOperationsTableReferences
                                            ._expenseCategoryIdTable(db)
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
      PrefetchHooks Function({
        bool statementId,
        bool renterId,
        bool incomeCategoryId,
        bool expenseCategoryId,
      })
    >;
typedef $$RenterAccountNumbersTableCreateCompanionBuilder =
    RenterAccountNumbersCompanion Function({
      Value<int> id,
      required String renterId,
      required String accountNumber,
    });
typedef $$RenterAccountNumbersTableUpdateCompanionBuilder =
    RenterAccountNumbersCompanion Function({
      Value<int> id,
      Value<String> renterId,
      Value<String> accountNumber,
    });

final class $$RenterAccountNumbersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RenterAccountNumbersTable,
          RenterAccountNumber
        > {
  $$RenterAccountNumbersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RentersTable _renterIdTable(_$AppDatabase db) =>
      db.renters.createAlias(
        $_aliasNameGenerator(db.renterAccountNumbers.renterId, db.renters.id),
      );

  $$RentersTableProcessedTableManager get renterId {
    final $_column = $_itemColumn<String>('renter_id')!;

    final manager = $$RentersTableTableManager(
      $_db,
      $_db.renters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_renterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RenterAccountNumbersTableFilterComposer
    extends Composer<_$AppDatabase, $RenterAccountNumbersTable> {
  $$RenterAccountNumbersTableFilterComposer({
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

  $$RentersTableFilterComposer get renterId {
    final $$RentersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableFilterComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RenterAccountNumbersTableOrderingComposer
    extends Composer<_$AppDatabase, $RenterAccountNumbersTable> {
  $$RenterAccountNumbersTableOrderingComposer({
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

  $$RentersTableOrderingComposer get renterId {
    final $$RentersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableOrderingComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RenterAccountNumbersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RenterAccountNumbersTable> {
  $$RenterAccountNumbersTableAnnotationComposer({
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

  $$RentersTableAnnotationComposer get renterId {
    final $$RentersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableAnnotationComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RenterAccountNumbersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RenterAccountNumbersTable,
          RenterAccountNumber,
          $$RenterAccountNumbersTableFilterComposer,
          $$RenterAccountNumbersTableOrderingComposer,
          $$RenterAccountNumbersTableAnnotationComposer,
          $$RenterAccountNumbersTableCreateCompanionBuilder,
          $$RenterAccountNumbersTableUpdateCompanionBuilder,
          (RenterAccountNumber, $$RenterAccountNumbersTableReferences),
          RenterAccountNumber,
          PrefetchHooks Function({bool renterId})
        > {
  $$RenterAccountNumbersTableTableManager(
    _$AppDatabase db,
    $RenterAccountNumbersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RenterAccountNumbersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RenterAccountNumbersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RenterAccountNumbersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> renterId = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
              }) => RenterAccountNumbersCompanion(
                id: id,
                renterId: renterId,
                accountNumber: accountNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String renterId,
                required String accountNumber,
              }) => RenterAccountNumbersCompanion.insert(
                id: id,
                renterId: renterId,
                accountNumber: accountNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RenterAccountNumbersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({renterId = false}) {
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
                    if (renterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.renterId,
                                referencedTable:
                                    $$RenterAccountNumbersTableReferences
                                        ._renterIdTable(db),
                                referencedColumn:
                                    $$RenterAccountNumbersTableReferences
                                        ._renterIdTable(db)
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

typedef $$RenterAccountNumbersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RenterAccountNumbersTable,
      RenterAccountNumber,
      $$RenterAccountNumbersTableFilterComposer,
      $$RenterAccountNumbersTableOrderingComposer,
      $$RenterAccountNumbersTableAnnotationComposer,
      $$RenterAccountNumbersTableCreateCompanionBuilder,
      $$RenterAccountNumbersTableUpdateCompanionBuilder,
      (RenterAccountNumber, $$RenterAccountNumbersTableReferences),
      RenterAccountNumber,
      PrefetchHooks Function({bool renterId})
    >;
typedef $$RenterAssignmentsTableCreateCompanionBuilder =
    RenterAssignmentsCompanion Function({
      required String id,
      required String baseId,
      required String renterId,
      required String accountNumber,
      required DateTime date,
      required int amountMinor,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RenterAssignmentsTableUpdateCompanionBuilder =
    RenterAssignmentsCompanion Function({
      Value<String> id,
      Value<String> baseId,
      Value<String> renterId,
      Value<String> accountNumber,
      Value<DateTime> date,
      Value<int> amountMinor,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RenterAssignmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RenterAssignmentsTable,
          RenterAssignmentRow
        > {
  $$RenterAssignmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BasesTable _baseIdTable(_$AppDatabase db) => db.bases.createAlias(
    $_aliasNameGenerator(db.renterAssignments.baseId, db.bases.id),
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

  static $RentersTable _renterIdTable(_$AppDatabase db) =>
      db.renters.createAlias(
        $_aliasNameGenerator(db.renterAssignments.renterId, db.renters.id),
      );

  $$RentersTableProcessedTableManager get renterId {
    final $_column = $_itemColumn<String>('renter_id')!;

    final manager = $$RentersTableTableManager(
      $_db,
      $_db.renters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_renterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RenterAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $RenterAssignmentsTable> {
  $$RenterAssignmentsTableFilterComposer({
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

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  $$RentersTableFilterComposer get renterId {
    final $$RentersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableFilterComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RenterAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $RenterAssignmentsTable> {
  $$RenterAssignmentsTableOrderingComposer({
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

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  $$RentersTableOrderingComposer get renterId {
    final $$RentersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableOrderingComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RenterAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RenterAssignmentsTable> {
  $$RenterAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

  $$RentersTableAnnotationComposer get renterId {
    final $$RentersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableAnnotationComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RenterAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RenterAssignmentsTable,
          RenterAssignmentRow,
          $$RenterAssignmentsTableFilterComposer,
          $$RenterAssignmentsTableOrderingComposer,
          $$RenterAssignmentsTableAnnotationComposer,
          $$RenterAssignmentsTableCreateCompanionBuilder,
          $$RenterAssignmentsTableUpdateCompanionBuilder,
          (RenterAssignmentRow, $$RenterAssignmentsTableReferences),
          RenterAssignmentRow,
          PrefetchHooks Function({bool baseId, bool renterId})
        > {
  $$RenterAssignmentsTableTableManager(
    _$AppDatabase db,
    $RenterAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RenterAssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RenterAssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RenterAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> baseId = const Value.absent(),
                Value<String> renterId = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RenterAssignmentsCompanion(
                id: id,
                baseId: baseId,
                renterId: renterId,
                accountNumber: accountNumber,
                date: date,
                amountMinor: amountMinor,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String baseId,
                required String renterId,
                required String accountNumber,
                required DateTime date,
                required int amountMinor,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RenterAssignmentsCompanion.insert(
                id: id,
                baseId: baseId,
                renterId: renterId,
                accountNumber: accountNumber,
                date: date,
                amountMinor: amountMinor,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RenterAssignmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({baseId = false, renterId = false}) {
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
                                    $$RenterAssignmentsTableReferences
                                        ._baseIdTable(db),
                                referencedColumn:
                                    $$RenterAssignmentsTableReferences
                                        ._baseIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (renterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.renterId,
                                referencedTable:
                                    $$RenterAssignmentsTableReferences
                                        ._renterIdTable(db),
                                referencedColumn:
                                    $$RenterAssignmentsTableReferences
                                        ._renterIdTable(db)
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

typedef $$RenterAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RenterAssignmentsTable,
      RenterAssignmentRow,
      $$RenterAssignmentsTableFilterComposer,
      $$RenterAssignmentsTableOrderingComposer,
      $$RenterAssignmentsTableAnnotationComposer,
      $$RenterAssignmentsTableCreateCompanionBuilder,
      $$RenterAssignmentsTableUpdateCompanionBuilder,
      (RenterAssignmentRow, $$RenterAssignmentsTableReferences),
      RenterAssignmentRow,
      PrefetchHooks Function({bool baseId, bool renterId})
    >;
typedef $$ExpenseCategoryAccountNumbersTableCreateCompanionBuilder =
    ExpenseCategoryAccountNumbersCompanion Function({
      Value<int> id,
      required String baseId,
      required int expenseCategoryId,
      required String accountNumber,
    });
typedef $$ExpenseCategoryAccountNumbersTableUpdateCompanionBuilder =
    ExpenseCategoryAccountNumbersCompanion Function({
      Value<int> id,
      Value<String> baseId,
      Value<int> expenseCategoryId,
      Value<String> accountNumber,
    });

final class $$ExpenseCategoryAccountNumbersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExpenseCategoryAccountNumbersTable,
          ExpenseCategoryAccountNumber
        > {
  $$ExpenseCategoryAccountNumbersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BasesTable _baseIdTable(_$AppDatabase db) => db.bases.createAlias(
    $_aliasNameGenerator(db.expenseCategoryAccountNumbers.baseId, db.bases.id),
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

  static $ExpenseCategoriesTable _expenseCategoryIdTable(_$AppDatabase db) =>
      db.expenseCategories.createAlias(
        $_aliasNameGenerator(
          db.expenseCategoryAccountNumbers.expenseCategoryId,
          db.expenseCategories.id,
        ),
      );

  $$ExpenseCategoriesTableProcessedTableManager get expenseCategoryId {
    final $_column = $_itemColumn<int>('expense_category_id')!;

    final manager = $$ExpenseCategoriesTableTableManager(
      $_db,
      $_db.expenseCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpenseCategoryAccountNumbersTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoryAccountNumbersTable> {
  $$ExpenseCategoryAccountNumbersTableFilterComposer({
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

  $$ExpenseCategoriesTableFilterComposer get expenseCategoryId {
    final $$ExpenseCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseCategoryId,
      referencedTable: $db.expenseCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.expenseCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseCategoryAccountNumbersTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoryAccountNumbersTable> {
  $$ExpenseCategoryAccountNumbersTableOrderingComposer({
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

  $$ExpenseCategoriesTableOrderingComposer get expenseCategoryId {
    final $$ExpenseCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseCategoryId,
      referencedTable: $db.expenseCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.expenseCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseCategoryAccountNumbersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoryAccountNumbersTable> {
  $$ExpenseCategoryAccountNumbersTableAnnotationComposer({
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

  $$ExpenseCategoriesTableAnnotationComposer get expenseCategoryId {
    final $$ExpenseCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.expenseCategoryId,
          referencedTable: $db.expenseCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.expenseCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ExpenseCategoryAccountNumbersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseCategoryAccountNumbersTable,
          ExpenseCategoryAccountNumber,
          $$ExpenseCategoryAccountNumbersTableFilterComposer,
          $$ExpenseCategoryAccountNumbersTableOrderingComposer,
          $$ExpenseCategoryAccountNumbersTableAnnotationComposer,
          $$ExpenseCategoryAccountNumbersTableCreateCompanionBuilder,
          $$ExpenseCategoryAccountNumbersTableUpdateCompanionBuilder,
          (
            ExpenseCategoryAccountNumber,
            $$ExpenseCategoryAccountNumbersTableReferences,
          ),
          ExpenseCategoryAccountNumber,
          PrefetchHooks Function({bool baseId, bool expenseCategoryId})
        > {
  $$ExpenseCategoryAccountNumbersTableTableManager(
    _$AppDatabase db,
    $ExpenseCategoryAccountNumbersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoryAccountNumbersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ExpenseCategoryAccountNumbersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExpenseCategoryAccountNumbersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> baseId = const Value.absent(),
                Value<int> expenseCategoryId = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
              }) => ExpenseCategoryAccountNumbersCompanion(
                id: id,
                baseId: baseId,
                expenseCategoryId: expenseCategoryId,
                accountNumber: accountNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String baseId,
                required int expenseCategoryId,
                required String accountNumber,
              }) => ExpenseCategoryAccountNumbersCompanion.insert(
                id: id,
                baseId: baseId,
                expenseCategoryId: expenseCategoryId,
                accountNumber: accountNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpenseCategoryAccountNumbersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({baseId = false, expenseCategoryId = false}) {
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
                                    $$ExpenseCategoryAccountNumbersTableReferences
                                        ._baseIdTable(db),
                                referencedColumn:
                                    $$ExpenseCategoryAccountNumbersTableReferences
                                        ._baseIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (expenseCategoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.expenseCategoryId,
                                referencedTable:
                                    $$ExpenseCategoryAccountNumbersTableReferences
                                        ._expenseCategoryIdTable(db),
                                referencedColumn:
                                    $$ExpenseCategoryAccountNumbersTableReferences
                                        ._expenseCategoryIdTable(db)
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

typedef $$ExpenseCategoryAccountNumbersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseCategoryAccountNumbersTable,
      ExpenseCategoryAccountNumber,
      $$ExpenseCategoryAccountNumbersTableFilterComposer,
      $$ExpenseCategoryAccountNumbersTableOrderingComposer,
      $$ExpenseCategoryAccountNumbersTableAnnotationComposer,
      $$ExpenseCategoryAccountNumbersTableCreateCompanionBuilder,
      $$ExpenseCategoryAccountNumbersTableUpdateCompanionBuilder,
      (
        ExpenseCategoryAccountNumber,
        $$ExpenseCategoryAccountNumbersTableReferences,
      ),
      ExpenseCategoryAccountNumber,
      PrefetchHooks Function({bool baseId, bool expenseCategoryId})
    >;
typedef $$IncomeDocumentsTableCreateCompanionBuilder =
    IncomeDocumentsCompanion Function({
      required String id,
      required String baseId,
      required DateTime date,
      required String accountType,
      required String accountRef,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$IncomeDocumentsTableUpdateCompanionBuilder =
    IncomeDocumentsCompanion Function({
      Value<String> id,
      Value<String> baseId,
      Value<DateTime> date,
      Value<String> accountType,
      Value<String> accountRef,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$IncomeDocumentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IncomeDocumentsTable,
          IncomeDocumentRow
        > {
  $$IncomeDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BasesTable _baseIdTable(_$AppDatabase db) => db.bases.createAlias(
    $_aliasNameGenerator(db.incomeDocuments.baseId, db.bases.id),
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

  static MultiTypedResultKey<$IncomeLinesTable, List<IncomeLineRow>>
  _incomeLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeLines,
    aliasName: $_aliasNameGenerator(
      db.incomeDocuments.id,
      db.incomeLines.documentId,
    ),
  );

  $$IncomeLinesTableProcessedTableManager get incomeLinesRefs {
    final manager = $$IncomeLinesTableTableManager(
      $_db,
      $_db.incomeLines,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomeLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IncomeDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeDocumentsTable> {
  $$IncomeDocumentsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountRef => $composableBuilder(
    column: $table.accountRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  Expression<bool> incomeLinesRefs(
    Expression<bool> Function($$IncomeLinesTableFilterComposer f) f,
  ) {
    final $$IncomeLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeLines,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeLinesTableFilterComposer(
            $db: $db,
            $table: $db.incomeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeDocumentsTable> {
  $$IncomeDocumentsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountRef => $composableBuilder(
    column: $table.accountRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$IncomeDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeDocumentsTable> {
  $$IncomeDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountRef => $composableBuilder(
    column: $table.accountRef,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

  Expression<T> incomeLinesRefs<T extends Object>(
    Expression<T> Function($$IncomeLinesTableAnnotationComposer a) f,
  ) {
    final $$IncomeLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeLines,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeDocumentsTable,
          IncomeDocumentRow,
          $$IncomeDocumentsTableFilterComposer,
          $$IncomeDocumentsTableOrderingComposer,
          $$IncomeDocumentsTableAnnotationComposer,
          $$IncomeDocumentsTableCreateCompanionBuilder,
          $$IncomeDocumentsTableUpdateCompanionBuilder,
          (IncomeDocumentRow, $$IncomeDocumentsTableReferences),
          IncomeDocumentRow,
          PrefetchHooks Function({bool baseId, bool incomeLinesRefs})
        > {
  $$IncomeDocumentsTableTableManager(
    _$AppDatabase db,
    $IncomeDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> baseId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<String> accountRef = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeDocumentsCompanion(
                id: id,
                baseId: baseId,
                date: date,
                accountType: accountType,
                accountRef: accountRef,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String baseId,
                required DateTime date,
                required String accountType,
                required String accountRef,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => IncomeDocumentsCompanion.insert(
                id: id,
                baseId: baseId,
                date: date,
                accountType: accountType,
                accountRef: accountRef,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncomeDocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({baseId = false, incomeLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (incomeLinesRefs) db.incomeLines],
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
                                    $$IncomeDocumentsTableReferences
                                        ._baseIdTable(db),
                                referencedColumn:
                                    $$IncomeDocumentsTableReferences
                                        ._baseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (incomeLinesRefs)
                    await $_getPrefetchedData<
                      IncomeDocumentRow,
                      $IncomeDocumentsTable,
                      IncomeLineRow
                    >(
                      currentTable: table,
                      referencedTable: $$IncomeDocumentsTableReferences
                          ._incomeLinesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$IncomeDocumentsTableReferences(
                            db,
                            table,
                            p0,
                          ).incomeLinesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.documentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$IncomeDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeDocumentsTable,
      IncomeDocumentRow,
      $$IncomeDocumentsTableFilterComposer,
      $$IncomeDocumentsTableOrderingComposer,
      $$IncomeDocumentsTableAnnotationComposer,
      $$IncomeDocumentsTableCreateCompanionBuilder,
      $$IncomeDocumentsTableUpdateCompanionBuilder,
      (IncomeDocumentRow, $$IncomeDocumentsTableReferences),
      IncomeDocumentRow,
      PrefetchHooks Function({bool baseId, bool incomeLinesRefs})
    >;
typedef $$IncomeLinesTableCreateCompanionBuilder =
    IncomeLinesCompanion Function({
      required String id,
      required String documentId,
      required int amountMinor,
      required String sourceType,
      Value<String?> renterId,
      Value<String?> accountNumber,
      Value<int?> categoryId,
      Value<String> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$IncomeLinesTableUpdateCompanionBuilder =
    IncomeLinesCompanion Function({
      Value<String> id,
      Value<String> documentId,
      Value<int> amountMinor,
      Value<String> sourceType,
      Value<String?> renterId,
      Value<String?> accountNumber,
      Value<int?> categoryId,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$IncomeLinesTableReferences
    extends BaseReferences<_$AppDatabase, $IncomeLinesTable, IncomeLineRow> {
  $$IncomeLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IncomeDocumentsTable _documentIdTable(_$AppDatabase db) =>
      db.incomeDocuments.createAlias(
        $_aliasNameGenerator(db.incomeLines.documentId, db.incomeDocuments.id),
      );

  $$IncomeDocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<String>('document_id')!;

    final manager = $$IncomeDocumentsTableTableManager(
      $_db,
      $_db.incomeDocuments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RentersTable _renterIdTable(_$AppDatabase db) =>
      db.renters.createAlias(
        $_aliasNameGenerator(db.incomeLines.renterId, db.renters.id),
      );

  $$RentersTableProcessedTableManager? get renterId {
    final $_column = $_itemColumn<String>('renter_id');
    if ($_column == null) return null;
    final manager = $$RentersTableTableManager(
      $_db,
      $_db.renters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_renterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IncomeCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.incomeCategories.createAlias(
        $_aliasNameGenerator(db.incomeLines.categoryId, db.incomeCategories.id),
      );

  $$IncomeCategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$IncomeCategoriesTableTableManager(
      $_db,
      $_db.incomeCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IncomeLinesTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeLinesTable> {
  $$IncomeLinesTableFilterComposer({
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

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$IncomeDocumentsTableFilterComposer get documentId {
    final $$IncomeDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.incomeDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.incomeDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RentersTableFilterComposer get renterId {
    final $$RentersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableFilterComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeCategoriesTableFilterComposer get categoryId {
    final $$IncomeCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeLinesTable> {
  $$IncomeLinesTableOrderingComposer({
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

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$IncomeDocumentsTableOrderingComposer get documentId {
    final $$IncomeDocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.incomeDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeDocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.incomeDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RentersTableOrderingComposer get renterId {
    final $$RentersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableOrderingComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeCategoriesTableOrderingComposer get categoryId {
    final $$IncomeCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeLinesTable> {
  $$IncomeLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$IncomeDocumentsTableAnnotationComposer get documentId {
    final $$IncomeDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.incomeDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RentersTableAnnotationComposer get renterId {
    final $$RentersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.renterId,
      referencedTable: $db.renters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RentersTableAnnotationComposer(
            $db: $db,
            $table: $db.renters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeCategoriesTableAnnotationComposer get categoryId {
    final $$IncomeCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeLinesTable,
          IncomeLineRow,
          $$IncomeLinesTableFilterComposer,
          $$IncomeLinesTableOrderingComposer,
          $$IncomeLinesTableAnnotationComposer,
          $$IncomeLinesTableCreateCompanionBuilder,
          $$IncomeLinesTableUpdateCompanionBuilder,
          (IncomeLineRow, $$IncomeLinesTableReferences),
          IncomeLineRow,
          PrefetchHooks Function({
            bool documentId,
            bool renterId,
            bool categoryId,
          })
        > {
  $$IncomeLinesTableTableManager(_$AppDatabase db, $IncomeLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> renterId = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeLinesCompanion(
                id: id,
                documentId: documentId,
                amountMinor: amountMinor,
                sourceType: sourceType,
                renterId: renterId,
                accountNumber: accountNumber,
                categoryId: categoryId,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String documentId,
                required int amountMinor,
                required String sourceType,
                Value<String?> renterId = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => IncomeLinesCompanion.insert(
                id: id,
                documentId: documentId,
                amountMinor: amountMinor,
                sourceType: sourceType,
                renterId: renterId,
                accountNumber: accountNumber,
                categoryId: categoryId,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncomeLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({documentId = false, renterId = false, categoryId = false}) {
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
                        if (documentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.documentId,
                                    referencedTable:
                                        $$IncomeLinesTableReferences
                                            ._documentIdTable(db),
                                    referencedColumn:
                                        $$IncomeLinesTableReferences
                                            ._documentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (renterId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.renterId,
                                    referencedTable:
                                        $$IncomeLinesTableReferences
                                            ._renterIdTable(db),
                                    referencedColumn:
                                        $$IncomeLinesTableReferences
                                            ._renterIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$IncomeLinesTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$IncomeLinesTableReferences
                                            ._categoryIdTable(db)
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

typedef $$IncomeLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeLinesTable,
      IncomeLineRow,
      $$IncomeLinesTableFilterComposer,
      $$IncomeLinesTableOrderingComposer,
      $$IncomeLinesTableAnnotationComposer,
      $$IncomeLinesTableCreateCompanionBuilder,
      $$IncomeLinesTableUpdateCompanionBuilder,
      (IncomeLineRow, $$IncomeLinesTableReferences),
      IncomeLineRow,
      PrefetchHooks Function({bool documentId, bool renterId, bool categoryId})
    >;
typedef $$ExpenseDocumentsTableCreateCompanionBuilder =
    ExpenseDocumentsCompanion Function({
      required String id,
      required String baseId,
      required DateTime date,
      required String accountType,
      required String accountRef,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ExpenseDocumentsTableUpdateCompanionBuilder =
    ExpenseDocumentsCompanion Function({
      Value<String> id,
      Value<String> baseId,
      Value<DateTime> date,
      Value<String> accountType,
      Value<String> accountRef,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ExpenseDocumentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExpenseDocumentsTable,
          ExpenseDocumentRow
        > {
  $$ExpenseDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BasesTable _baseIdTable(_$AppDatabase db) => db.bases.createAlias(
    $_aliasNameGenerator(db.expenseDocuments.baseId, db.bases.id),
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

  static MultiTypedResultKey<$ExpenseLinesTable, List<ExpenseLineRow>>
  _expenseLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenseLines,
    aliasName: $_aliasNameGenerator(
      db.expenseDocuments.id,
      db.expenseLines.documentId,
    ),
  );

  $$ExpenseLinesTableProcessedTableManager get expenseLinesRefs {
    final manager = $$ExpenseLinesTableTableManager(
      $_db,
      $_db.expenseLines,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expenseLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpenseDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseDocumentsTable> {
  $$ExpenseDocumentsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountRef => $composableBuilder(
    column: $table.accountRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  Expression<bool> expenseLinesRefs(
    Expression<bool> Function($$ExpenseLinesTableFilterComposer f) f,
  ) {
    final $$ExpenseLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseLines,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseLinesTableFilterComposer(
            $db: $db,
            $table: $db.expenseLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpenseDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseDocumentsTable> {
  $$ExpenseDocumentsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountRef => $composableBuilder(
    column: $table.accountRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$ExpenseDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseDocumentsTable> {
  $$ExpenseDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountRef => $composableBuilder(
    column: $table.accountRef,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

  Expression<T> expenseLinesRefs<T extends Object>(
    Expression<T> Function($$ExpenseLinesTableAnnotationComposer a) f,
  ) {
    final $$ExpenseLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseLines,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenseLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpenseDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseDocumentsTable,
          ExpenseDocumentRow,
          $$ExpenseDocumentsTableFilterComposer,
          $$ExpenseDocumentsTableOrderingComposer,
          $$ExpenseDocumentsTableAnnotationComposer,
          $$ExpenseDocumentsTableCreateCompanionBuilder,
          $$ExpenseDocumentsTableUpdateCompanionBuilder,
          (ExpenseDocumentRow, $$ExpenseDocumentsTableReferences),
          ExpenseDocumentRow,
          PrefetchHooks Function({bool baseId, bool expenseLinesRefs})
        > {
  $$ExpenseDocumentsTableTableManager(
    _$AppDatabase db,
    $ExpenseDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> baseId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<String> accountRef = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseDocumentsCompanion(
                id: id,
                baseId: baseId,
                date: date,
                accountType: accountType,
                accountRef: accountRef,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String baseId,
                required DateTime date,
                required String accountType,
                required String accountRef,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ExpenseDocumentsCompanion.insert(
                id: id,
                baseId: baseId,
                date: date,
                accountType: accountType,
                accountRef: accountRef,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpenseDocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({baseId = false, expenseLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expenseLinesRefs) db.expenseLines],
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
                                    $$ExpenseDocumentsTableReferences
                                        ._baseIdTable(db),
                                referencedColumn:
                                    $$ExpenseDocumentsTableReferences
                                        ._baseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expenseLinesRefs)
                    await $_getPrefetchedData<
                      ExpenseDocumentRow,
                      $ExpenseDocumentsTable,
                      ExpenseLineRow
                    >(
                      currentTable: table,
                      referencedTable: $$ExpenseDocumentsTableReferences
                          ._expenseLinesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExpenseDocumentsTableReferences(
                            db,
                            table,
                            p0,
                          ).expenseLinesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.documentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExpenseDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseDocumentsTable,
      ExpenseDocumentRow,
      $$ExpenseDocumentsTableFilterComposer,
      $$ExpenseDocumentsTableOrderingComposer,
      $$ExpenseDocumentsTableAnnotationComposer,
      $$ExpenseDocumentsTableCreateCompanionBuilder,
      $$ExpenseDocumentsTableUpdateCompanionBuilder,
      (ExpenseDocumentRow, $$ExpenseDocumentsTableReferences),
      ExpenseDocumentRow,
      PrefetchHooks Function({bool baseId, bool expenseLinesRefs})
    >;
typedef $$ExpenseLinesTableCreateCompanionBuilder =
    ExpenseLinesCompanion Function({
      required String id,
      required String documentId,
      required int amountMinor,
      required int categoryId,
      Value<String> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ExpenseLinesTableUpdateCompanionBuilder =
    ExpenseLinesCompanion Function({
      Value<String> id,
      Value<String> documentId,
      Value<int> amountMinor,
      Value<int> categoryId,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ExpenseLinesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpenseLinesTable, ExpenseLineRow> {
  $$ExpenseLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExpenseDocumentsTable _documentIdTable(_$AppDatabase db) =>
      db.expenseDocuments.createAlias(
        $_aliasNameGenerator(
          db.expenseLines.documentId,
          db.expenseDocuments.id,
        ),
      );

  $$ExpenseDocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<String>('document_id')!;

    final manager = $$ExpenseDocumentsTableTableManager(
      $_db,
      $_db.expenseDocuments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExpenseCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.expenseCategories.createAlias(
        $_aliasNameGenerator(
          db.expenseLines.categoryId,
          db.expenseCategories.id,
        ),
      );

  $$ExpenseCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$ExpenseCategoriesTableTableManager(
      $_db,
      $_db.expenseCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpenseLinesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseLinesTable> {
  $$ExpenseLinesTableFilterComposer({
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

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ExpenseDocumentsTableFilterComposer get documentId {
    final $$ExpenseDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.expenseDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.expenseDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpenseCategoriesTableFilterComposer get categoryId {
    final $$ExpenseCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.expenseCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.expenseCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseLinesTable> {
  $$ExpenseLinesTableOrderingComposer({
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

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExpenseDocumentsTableOrderingComposer get documentId {
    final $$ExpenseDocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.expenseDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseDocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.expenseDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpenseCategoriesTableOrderingComposer get categoryId {
    final $$ExpenseCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.expenseCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.expenseCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseLinesTable> {
  $$ExpenseLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExpenseDocumentsTableAnnotationComposer get documentId {
    final $$ExpenseDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.expenseDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.expenseDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpenseCategoriesTableAnnotationComposer get categoryId {
    final $$ExpenseCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.expenseCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.expenseCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ExpenseLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseLinesTable,
          ExpenseLineRow,
          $$ExpenseLinesTableFilterComposer,
          $$ExpenseLinesTableOrderingComposer,
          $$ExpenseLinesTableAnnotationComposer,
          $$ExpenseLinesTableCreateCompanionBuilder,
          $$ExpenseLinesTableUpdateCompanionBuilder,
          (ExpenseLineRow, $$ExpenseLinesTableReferences),
          ExpenseLineRow,
          PrefetchHooks Function({bool documentId, bool categoryId})
        > {
  $$ExpenseLinesTableTableManager(_$AppDatabase db, $ExpenseLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseLinesCompanion(
                id: id,
                documentId: documentId,
                amountMinor: amountMinor,
                categoryId: categoryId,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String documentId,
                required int amountMinor,
                required int categoryId,
                Value<String> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ExpenseLinesCompanion.insert(
                id: id,
                documentId: documentId,
                amountMinor: amountMinor,
                categoryId: categoryId,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpenseLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentId = false, categoryId = false}) {
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
                    if (documentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.documentId,
                                referencedTable: $$ExpenseLinesTableReferences
                                    ._documentIdTable(db),
                                referencedColumn: $$ExpenseLinesTableReferences
                                    ._documentIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$ExpenseLinesTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$ExpenseLinesTableReferences
                                    ._categoryIdTable(db)
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

typedef $$ExpenseLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseLinesTable,
      ExpenseLineRow,
      $$ExpenseLinesTableFilterComposer,
      $$ExpenseLinesTableOrderingComposer,
      $$ExpenseLinesTableAnnotationComposer,
      $$ExpenseLinesTableCreateCompanionBuilder,
      $$ExpenseLinesTableUpdateCompanionBuilder,
      (ExpenseLineRow, $$ExpenseLinesTableReferences),
      ExpenseLineRow,
      PrefetchHooks Function({bool documentId, bool categoryId})
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
  $$RentersTableTableManager get renters =>
      $$RentersTableTableManager(_db, _db.renters);
  $$IncomeCategoriesTableTableManager get incomeCategories =>
      $$IncomeCategoriesTableTableManager(_db, _db.incomeCategories);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$BankStatementOperationsTableTableManager get bankStatementOperations =>
      $$BankStatementOperationsTableTableManager(
        _db,
        _db.bankStatementOperations,
      );
  $$RenterAccountNumbersTableTableManager get renterAccountNumbers =>
      $$RenterAccountNumbersTableTableManager(_db, _db.renterAccountNumbers);
  $$RenterAssignmentsTableTableManager get renterAssignments =>
      $$RenterAssignmentsTableTableManager(_db, _db.renterAssignments);
  $$ExpenseCategoryAccountNumbersTableTableManager
  get expenseCategoryAccountNumbers =>
      $$ExpenseCategoryAccountNumbersTableTableManager(
        _db,
        _db.expenseCategoryAccountNumbers,
      );
  $$IncomeDocumentsTableTableManager get incomeDocuments =>
      $$IncomeDocumentsTableTableManager(_db, _db.incomeDocuments);
  $$IncomeLinesTableTableManager get incomeLines =>
      $$IncomeLinesTableTableManager(_db, _db.incomeLines);
  $$ExpenseDocumentsTableTableManager get expenseDocuments =>
      $$ExpenseDocumentsTableTableManager(_db, _db.expenseDocuments);
  $$ExpenseLinesTableTableManager get expenseLines =>
      $$ExpenseLinesTableTableManager(_db, _db.expenseLines);
}
