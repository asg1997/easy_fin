// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_statement_database.dart';

// ignore_for_file: type=lint
class $BankStatementsTable extends BankStatements
    with TableInfo<$BankStatementsTable, BankStatement> {
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
  static const VerificationMeta _initialBalanceMeta = const VerificationMeta(
    'initialBalance',
  );
  @override
  late final GeneratedColumn<double> initialBalance = GeneratedColumn<double>(
    'initial_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalBalanceMeta = const VerificationMeta(
    'finalBalance',
  );
  @override
  late final GeneratedColumn<double> finalBalance = GeneratedColumn<double>(
    'final_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    accountNumber,
    initialBalance,
    finalBalance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_statements';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankStatement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('initial_balance')) {
      context.handle(
        _initialBalanceMeta,
        initialBalance.isAcceptableOrUnknown(
          data['initial_balance']!,
          _initialBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialBalanceMeta);
    }
    if (data.containsKey('final_balance')) {
      context.handle(
        _finalBalanceMeta,
        finalBalance.isAcceptableOrUnknown(
          data['final_balance']!,
          _finalBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_finalBalanceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankStatement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankStatement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      )!,
      initialBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_balance'],
      )!,
      finalBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}final_balance'],
      )!,
    );
  }

  @override
  $BankStatementsTable createAlias(String alias) {
    return $BankStatementsTable(attachedDatabase, alias);
  }
}

class BankStatement extends DataClass implements Insertable<BankStatement> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String accountNumber;
  final double initialBalance;
  final double finalBalance;
  const BankStatement({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.accountNumber,
    required this.initialBalance,
    required this.finalBalance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['account_number'] = Variable<String>(accountNumber);
    map['initial_balance'] = Variable<double>(initialBalance);
    map['final_balance'] = Variable<double>(finalBalance);
    return map;
  }

  BankStatementsCompanion toCompanion(bool nullToAbsent) {
    return BankStatementsCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      accountNumber: Value(accountNumber),
      initialBalance: Value(initialBalance),
      finalBalance: Value(finalBalance),
    );
  }

  factory BankStatement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankStatement(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
      initialBalance: serializer.fromJson<double>(json['initialBalance']),
      finalBalance: serializer.fromJson<double>(json['finalBalance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'initialBalance': serializer.toJson<double>(initialBalance),
      'finalBalance': serializer.toJson<double>(finalBalance),
    };
  }

  BankStatement copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    String? accountNumber,
    double? initialBalance,
    double? finalBalance,
  }) => BankStatement(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    accountNumber: accountNumber ?? this.accountNumber,
    initialBalance: initialBalance ?? this.initialBalance,
    finalBalance: finalBalance ?? this.finalBalance,
  );
  BankStatement copyWithCompanion(BankStatementsCompanion data) {
    return BankStatement(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      finalBalance: data.finalBalance.present
          ? data.finalBalance.value
          : this.finalBalance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankStatement(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('finalBalance: $finalBalance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startDate,
    endDate,
    accountNumber,
    initialBalance,
    finalBalance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankStatement &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.accountNumber == this.accountNumber &&
          other.initialBalance == this.initialBalance &&
          other.finalBalance == this.finalBalance);
}

class BankStatementsCompanion extends UpdateCompanion<BankStatement> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> accountNumber;
  final Value<double> initialBalance;
  final Value<double> finalBalance;
  const BankStatementsCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.finalBalance = const Value.absent(),
  });
  BankStatementsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required String accountNumber,
    required double initialBalance,
    required double finalBalance,
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       accountNumber = Value(accountNumber),
       initialBalance = Value(initialBalance),
       finalBalance = Value(finalBalance);
  static Insertable<BankStatement> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? accountNumber,
    Expression<double>? initialBalance,
    Expression<double>? finalBalance,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (accountNumber != null) 'account_number': accountNumber,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (finalBalance != null) 'final_balance': finalBalance,
    });
  }

  BankStatementsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? accountNumber,
    Value<double>? initialBalance,
    Value<double>? finalBalance,
  }) {
    return BankStatementsCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      accountNumber: accountNumber ?? this.accountNumber,
      initialBalance: initialBalance ?? this.initialBalance,
      finalBalance: finalBalance ?? this.finalBalance,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<double>(initialBalance.value);
    }
    if (finalBalance.present) {
      map['final_balance'] = Variable<double>(finalBalance.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BankStatementsCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('finalBalance: $finalBalance')
          ..write(')'))
        .toString();
  }
}

class $BankStatementOperationsTable extends BankStatementOperations
    with TableInfo<$BankStatementOperationsTable, BankStatementOperation> {
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
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
    'debit',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<double> credit = GeneratedColumn<double>(
    'credit',
    aliasedName,
    true,
    type: DriftSqlType.double,
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
    debit,
    credit,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_statement_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankStatementOperation> instance, {
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
    if (data.containsKey('debit')) {
      context.handle(
        _debitMeta,
        debit.isAcceptableOrUnknown(data['debit']!, _debitMeta),
      );
    }
    if (data.containsKey('credit')) {
      context.handle(
        _creditMeta,
        credit.isAcceptableOrUnknown(data['credit']!, _creditMeta),
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
  BankStatementOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankStatementOperation(
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
      debit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}debit'],
      ),
      credit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit'],
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

class BankStatementOperation extends DataClass
    implements Insertable<BankStatementOperation> {
  final int id;
  final int statementId;
  final DateTime date;
  final String debitInn;
  final String debitBankAccount;
  final String creditInn;
  final String creditBankAccount;
  final double? debit;
  final double? credit;
  final String note;
  const BankStatementOperation({
    required this.id,
    required this.statementId,
    required this.date,
    required this.debitInn,
    required this.debitBankAccount,
    required this.creditInn,
    required this.creditBankAccount,
    this.debit,
    this.credit,
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
    if (!nullToAbsent || debit != null) {
      map['debit'] = Variable<double>(debit);
    }
    if (!nullToAbsent || credit != null) {
      map['credit'] = Variable<double>(credit);
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
      debit: debit == null && nullToAbsent
          ? const Value.absent()
          : Value(debit),
      credit: credit == null && nullToAbsent
          ? const Value.absent()
          : Value(credit),
      note: Value(note),
    );
  }

  factory BankStatementOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankStatementOperation(
      id: serializer.fromJson<int>(json['id']),
      statementId: serializer.fromJson<int>(json['statementId']),
      date: serializer.fromJson<DateTime>(json['date']),
      debitInn: serializer.fromJson<String>(json['debitInn']),
      debitBankAccount: serializer.fromJson<String>(json['debitBankAccount']),
      creditInn: serializer.fromJson<String>(json['creditInn']),
      creditBankAccount: serializer.fromJson<String>(json['creditBankAccount']),
      debit: serializer.fromJson<double?>(json['debit']),
      credit: serializer.fromJson<double?>(json['credit']),
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
      'debit': serializer.toJson<double?>(debit),
      'credit': serializer.toJson<double?>(credit),
      'note': serializer.toJson<String>(note),
    };
  }

  BankStatementOperation copyWith({
    int? id,
    int? statementId,
    DateTime? date,
    String? debitInn,
    String? debitBankAccount,
    String? creditInn,
    String? creditBankAccount,
    Value<double?> debit = const Value.absent(),
    Value<double?> credit = const Value.absent(),
    String? note,
  }) => BankStatementOperation(
    id: id ?? this.id,
    statementId: statementId ?? this.statementId,
    date: date ?? this.date,
    debitInn: debitInn ?? this.debitInn,
    debitBankAccount: debitBankAccount ?? this.debitBankAccount,
    creditInn: creditInn ?? this.creditInn,
    creditBankAccount: creditBankAccount ?? this.creditBankAccount,
    debit: debit.present ? debit.value : this.debit,
    credit: credit.present ? credit.value : this.credit,
    note: note ?? this.note,
  );
  BankStatementOperation copyWithCompanion(
    BankStatementOperationsCompanion data,
  ) {
    return BankStatementOperation(
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
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankStatementOperation(')
          ..write('id: $id, ')
          ..write('statementId: $statementId, ')
          ..write('date: $date, ')
          ..write('debitInn: $debitInn, ')
          ..write('debitBankAccount: $debitBankAccount, ')
          ..write('creditInn: $creditInn, ')
          ..write('creditBankAccount: $creditBankAccount, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
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
    debit,
    credit,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankStatementOperation &&
          other.id == this.id &&
          other.statementId == this.statementId &&
          other.date == this.date &&
          other.debitInn == this.debitInn &&
          other.debitBankAccount == this.debitBankAccount &&
          other.creditInn == this.creditInn &&
          other.creditBankAccount == this.creditBankAccount &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.note == this.note);
}

class BankStatementOperationsCompanion
    extends UpdateCompanion<BankStatementOperation> {
  final Value<int> id;
  final Value<int> statementId;
  final Value<DateTime> date;
  final Value<String> debitInn;
  final Value<String> debitBankAccount;
  final Value<String> creditInn;
  final Value<String> creditBankAccount;
  final Value<double?> debit;
  final Value<double?> credit;
  final Value<String> note;
  const BankStatementOperationsCompanion({
    this.id = const Value.absent(),
    this.statementId = const Value.absent(),
    this.date = const Value.absent(),
    this.debitInn = const Value.absent(),
    this.debitBankAccount = const Value.absent(),
    this.creditInn = const Value.absent(),
    this.creditBankAccount = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
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
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    required String note,
  }) : statementId = Value(statementId),
       date = Value(date),
       debitInn = Value(debitInn),
       debitBankAccount = Value(debitBankAccount),
       creditInn = Value(creditInn),
       creditBankAccount = Value(creditBankAccount),
       note = Value(note);
  static Insertable<BankStatementOperation> custom({
    Expression<int>? id,
    Expression<int>? statementId,
    Expression<DateTime>? date,
    Expression<String>? debitInn,
    Expression<String>? debitBankAccount,
    Expression<String>? creditInn,
    Expression<String>? creditBankAccount,
    Expression<double>? debit,
    Expression<double>? credit,
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
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
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
    Value<double?>? debit,
    Value<double?>? credit,
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
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
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
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<double>(credit.value);
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
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$BankStatementDatabase extends GeneratedDatabase {
  _$BankStatementDatabase(QueryExecutor e) : super(e);
  $BankStatementDatabaseManager get managers =>
      $BankStatementDatabaseManager(this);
  late final $BankStatementsTable bankStatements = $BankStatementsTable(this);
  late final $BankStatementOperationsTable bankStatementOperations =
      $BankStatementOperationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bankStatements,
    bankStatementOperations,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
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

typedef $$BankStatementsTableCreateCompanionBuilder =
    BankStatementsCompanion Function({
      Value<int> id,
      required DateTime startDate,
      required DateTime endDate,
      required String accountNumber,
      required double initialBalance,
      required double finalBalance,
    });
typedef $$BankStatementsTableUpdateCompanionBuilder =
    BankStatementsCompanion Function({
      Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> accountNumber,
      Value<double> initialBalance,
      Value<double> finalBalance,
    });

final class $$BankStatementsTableReferences
    extends
        BaseReferences<
          _$BankStatementDatabase,
          $BankStatementsTable,
          BankStatement
        > {
  $$BankStatementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $BankStatementOperationsTable,
    List<BankStatementOperation>
  >
  _bankStatementOperationsRefsTable(_$BankStatementDatabase db) =>
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
    extends Composer<_$BankStatementDatabase, $BankStatementsTable> {
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

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get finalBalance => $composableBuilder(
    column: $table.finalBalance,
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
    extends Composer<_$BankStatementDatabase, $BankStatementsTable> {
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

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get finalBalance => $composableBuilder(
    column: $table.finalBalance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BankStatementsTableAnnotationComposer
    extends Composer<_$BankStatementDatabase, $BankStatementsTable> {
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

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get finalBalance => $composableBuilder(
    column: $table.finalBalance,
    builder: (column) => column,
  );

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
          _$BankStatementDatabase,
          $BankStatementsTable,
          BankStatement,
          $$BankStatementsTableFilterComposer,
          $$BankStatementsTableOrderingComposer,
          $$BankStatementsTableAnnotationComposer,
          $$BankStatementsTableCreateCompanionBuilder,
          $$BankStatementsTableUpdateCompanionBuilder,
          (BankStatement, $$BankStatementsTableReferences),
          BankStatement,
          PrefetchHooks Function({bool bankStatementOperationsRefs})
        > {
  $$BankStatementsTableTableManager(
    _$BankStatementDatabase db,
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
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
                Value<double> initialBalance = const Value.absent(),
                Value<double> finalBalance = const Value.absent(),
              }) => BankStatementsCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                accountNumber: accountNumber,
                initialBalance: initialBalance,
                finalBalance: finalBalance,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required String accountNumber,
                required double initialBalance,
                required double finalBalance,
              }) => BankStatementsCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                accountNumber: accountNumber,
                initialBalance: initialBalance,
                finalBalance: finalBalance,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BankStatementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bankStatementOperationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bankStatementOperationsRefs) db.bankStatementOperations,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bankStatementOperationsRefs)
                    await $_getPrefetchedData<
                      BankStatement,
                      $BankStatementsTable,
                      BankStatementOperation
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
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
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
      _$BankStatementDatabase,
      $BankStatementsTable,
      BankStatement,
      $$BankStatementsTableFilterComposer,
      $$BankStatementsTableOrderingComposer,
      $$BankStatementsTableAnnotationComposer,
      $$BankStatementsTableCreateCompanionBuilder,
      $$BankStatementsTableUpdateCompanionBuilder,
      (BankStatement, $$BankStatementsTableReferences),
      BankStatement,
      PrefetchHooks Function({bool bankStatementOperationsRefs})
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
      Value<double?> debit,
      Value<double?> credit,
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
      Value<double?> debit,
      Value<double?> credit,
      Value<String> note,
    });

final class $$BankStatementOperationsTableReferences
    extends
        BaseReferences<
          _$BankStatementDatabase,
          $BankStatementOperationsTable,
          BankStatementOperation
        > {
  $$BankStatementOperationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BankStatementsTable _statementIdTable(_$BankStatementDatabase db) =>
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
    extends Composer<_$BankStatementDatabase, $BankStatementOperationsTable> {
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

  ColumnFilters<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get credit => $composableBuilder(
    column: $table.credit,
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
    extends Composer<_$BankStatementDatabase, $BankStatementOperationsTable> {
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

  ColumnOrderings<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get credit => $composableBuilder(
    column: $table.credit,
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
    extends Composer<_$BankStatementDatabase, $BankStatementOperationsTable> {
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

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

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
          _$BankStatementDatabase,
          $BankStatementOperationsTable,
          BankStatementOperation,
          $$BankStatementOperationsTableFilterComposer,
          $$BankStatementOperationsTableOrderingComposer,
          $$BankStatementOperationsTableAnnotationComposer,
          $$BankStatementOperationsTableCreateCompanionBuilder,
          $$BankStatementOperationsTableUpdateCompanionBuilder,
          (BankStatementOperation, $$BankStatementOperationsTableReferences),
          BankStatementOperation,
          PrefetchHooks Function({bool statementId})
        > {
  $$BankStatementOperationsTableTableManager(
    _$BankStatementDatabase db,
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
                Value<double?> debit = const Value.absent(),
                Value<double?> credit = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => BankStatementOperationsCompanion(
                id: id,
                statementId: statementId,
                date: date,
                debitInn: debitInn,
                debitBankAccount: debitBankAccount,
                creditInn: creditInn,
                creditBankAccount: creditBankAccount,
                debit: debit,
                credit: credit,
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
                Value<double?> debit = const Value.absent(),
                Value<double?> credit = const Value.absent(),
                required String note,
              }) => BankStatementOperationsCompanion.insert(
                id: id,
                statementId: statementId,
                date: date,
                debitInn: debitInn,
                debitBankAccount: debitBankAccount,
                creditInn: creditInn,
                creditBankAccount: creditBankAccount,
                debit: debit,
                credit: credit,
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
      _$BankStatementDatabase,
      $BankStatementOperationsTable,
      BankStatementOperation,
      $$BankStatementOperationsTableFilterComposer,
      $$BankStatementOperationsTableOrderingComposer,
      $$BankStatementOperationsTableAnnotationComposer,
      $$BankStatementOperationsTableCreateCompanionBuilder,
      $$BankStatementOperationsTableUpdateCompanionBuilder,
      (BankStatementOperation, $$BankStatementOperationsTableReferences),
      BankStatementOperation,
      PrefetchHooks Function({bool statementId})
    >;

class $BankStatementDatabaseManager {
  final _$BankStatementDatabase _db;
  $BankStatementDatabaseManager(this._db);
  $$BankStatementsTableTableManager get bankStatements =>
      $$BankStatementsTableTableManager(_db, _db.bankStatements);
  $$BankStatementOperationsTableTableManager get bankStatementOperations =>
      $$BankStatementOperationsTableTableManager(
        _db,
        _db.bankStatementOperations,
      );
}
