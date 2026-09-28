// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _holderNameMeta = const VerificationMeta(
    'holderName',
  );
  @override
  late final GeneratedColumn<String> holderName = GeneratedColumn<String>(
    'holder_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceKoboMeta = const VerificationMeta(
    'balanceKobo',
  );
  @override
  late final GeneratedColumn<int> balanceKobo = GeneratedColumn<int>(
    'balance_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kycTierMeta = const VerificationMeta(
    'kycTier',
  );
  @override
  late final GeneratedColumn<int> kycTier = GeneratedColumn<int>(
    'kyc_tier',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    holderName,
    accountNumber,
    balanceKobo,
    kycTier,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('holder_name')) {
      context.handle(
        _holderNameMeta,
        holderName.isAcceptableOrUnknown(data['holder_name']!, _holderNameMeta),
      );
    } else if (isInserting) {
      context.missing(_holderNameMeta);
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
    if (data.containsKey('balance_kobo')) {
      context.handle(
        _balanceKoboMeta,
        balanceKobo.isAcceptableOrUnknown(
          data['balance_kobo']!,
          _balanceKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceKoboMeta);
    }
    if (data.containsKey('kyc_tier')) {
      context.handle(
        _kycTierMeta,
        kycTier.isAcceptableOrUnknown(data['kyc_tier']!, _kycTierMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      holderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}holder_name'],
      )!,
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      )!,
      balanceKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_kobo'],
      )!,
      kycTier: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kyc_tier'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String holderName;
  final String accountNumber;
  final int balanceKobo;
  final int kycTier;
  const AccountRow({
    required this.id,
    required this.holderName,
    required this.accountNumber,
    required this.balanceKobo,
    required this.kycTier,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['holder_name'] = Variable<String>(holderName);
    map['account_number'] = Variable<String>(accountNumber);
    map['balance_kobo'] = Variable<int>(balanceKobo);
    map['kyc_tier'] = Variable<int>(kycTier);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      holderName: Value(holderName),
      accountNumber: Value(accountNumber),
      balanceKobo: Value(balanceKobo),
      kycTier: Value(kycTier),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      holderName: serializer.fromJson<String>(json['holderName']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
      balanceKobo: serializer.fromJson<int>(json['balanceKobo']),
      kycTier: serializer.fromJson<int>(json['kycTier']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'holderName': serializer.toJson<String>(holderName),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'balanceKobo': serializer.toJson<int>(balanceKobo),
      'kycTier': serializer.toJson<int>(kycTier),
    };
  }

  AccountRow copyWith({
    String? id,
    String? holderName,
    String? accountNumber,
    int? balanceKobo,
    int? kycTier,
  }) => AccountRow(
    id: id ?? this.id,
    holderName: holderName ?? this.holderName,
    accountNumber: accountNumber ?? this.accountNumber,
    balanceKobo: balanceKobo ?? this.balanceKobo,
    kycTier: kycTier ?? this.kycTier,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      holderName: data.holderName.present
          ? data.holderName.value
          : this.holderName,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      balanceKobo: data.balanceKobo.present
          ? data.balanceKobo.value
          : this.balanceKobo,
      kycTier: data.kycTier.present ? data.kycTier.value : this.kycTier,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('holderName: $holderName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('balanceKobo: $balanceKobo, ')
          ..write('kycTier: $kycTier')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, holderName, accountNumber, balanceKobo, kycTier);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.holderName == this.holderName &&
          other.accountNumber == this.accountNumber &&
          other.balanceKobo == this.balanceKobo &&
          other.kycTier == this.kycTier);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> holderName;
  final Value<String> accountNumber;
  final Value<int> balanceKobo;
  final Value<int> kycTier;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.holderName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.balanceKobo = const Value.absent(),
    this.kycTier = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String holderName,
    required String accountNumber,
    required int balanceKobo,
    this.kycTier = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       holderName = Value(holderName),
       accountNumber = Value(accountNumber),
       balanceKobo = Value(balanceKobo);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? holderName,
    Expression<String>? accountNumber,
    Expression<int>? balanceKobo,
    Expression<int>? kycTier,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (holderName != null) 'holder_name': holderName,
      if (accountNumber != null) 'account_number': accountNumber,
      if (balanceKobo != null) 'balance_kobo': balanceKobo,
      if (kycTier != null) 'kyc_tier': kycTier,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? holderName,
    Value<String>? accountNumber,
    Value<int>? balanceKobo,
    Value<int>? kycTier,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      holderName: holderName ?? this.holderName,
      accountNumber: accountNumber ?? this.accountNumber,
      balanceKobo: balanceKobo ?? this.balanceKobo,
      kycTier: kycTier ?? this.kycTier,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (holderName.present) {
      map['holder_name'] = Variable<String>(holderName.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (balanceKobo.present) {
      map['balance_kobo'] = Variable<int>(balanceKobo.value);
    }
    if (kycTier.present) {
      map['kyc_tier'] = Variable<int>(kycTier.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('holderName: $holderName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('balanceKobo: $balanceKobo, ')
          ..write('kycTier: $kycTier, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxnDirection, String> direction =
      GeneratedColumn<String>(
        'direction',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxnDirection>($TransactionsTable.$converterdirection);
  @override
  late final GeneratedColumnWithTypeConverter<TxnCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxnCategory>($TransactionsTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<TxnStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxnStatus>($TransactionsTable.$converterstatus);
  static const VerificationMeta _amountKoboMeta = const VerificationMeta(
    'amountKobo',
  );
  @override
  late final GeneratedColumn<int> amountKobo = GeneratedColumn<int>(
    'amount_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feeKoboMeta = const VerificationMeta(
    'feeKobo',
  );
  @override
  late final GeneratedColumn<int> feeKobo = GeneratedColumn<int>(
    'fee_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _narrationMeta = const VerificationMeta(
    'narration',
  );
  @override
  late final GeneratedColumn<String> narration = GeneratedColumn<String>(
    'narration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _counterpartyNameMeta = const VerificationMeta(
    'counterpartyName',
  );
  @override
  late final GeneratedColumn<String> counterpartyName = GeneratedColumn<String>(
    'counterparty_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _counterpartyAccountMeta =
      const VerificationMeta('counterpartyAccount');
  @override
  late final GeneratedColumn<String> counterpartyAccount =
      GeneratedColumn<String>(
        'counterparty_account',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _counterpartyBankMeta = const VerificationMeta(
    'counterpartyBank',
  );
  @override
  late final GeneratedColumn<String> counterpartyBank = GeneratedColumn<String>(
    'counterparty_bank',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    accountId,
    reference,
    direction,
    category,
    status,
    amountKobo,
    feeKobo,
    narration,
    counterpartyName,
    counterpartyAccount,
    counterpartyBank,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('amount_kobo')) {
      context.handle(
        _amountKoboMeta,
        amountKobo.isAcceptableOrUnknown(data['amount_kobo']!, _amountKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_amountKoboMeta);
    }
    if (data.containsKey('fee_kobo')) {
      context.handle(
        _feeKoboMeta,
        feeKobo.isAcceptableOrUnknown(data['fee_kobo']!, _feeKoboMeta),
      );
    }
    if (data.containsKey('narration')) {
      context.handle(
        _narrationMeta,
        narration.isAcceptableOrUnknown(data['narration']!, _narrationMeta),
      );
    }
    if (data.containsKey('counterparty_name')) {
      context.handle(
        _counterpartyNameMeta,
        counterpartyName.isAcceptableOrUnknown(
          data['counterparty_name']!,
          _counterpartyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_counterpartyNameMeta);
    }
    if (data.containsKey('counterparty_account')) {
      context.handle(
        _counterpartyAccountMeta,
        counterpartyAccount.isAcceptableOrUnknown(
          data['counterparty_account']!,
          _counterpartyAccountMeta,
        ),
      );
    }
    if (data.containsKey('counterparty_bank')) {
      context.handle(
        _counterpartyBankMeta,
        counterpartyBank.isAcceptableOrUnknown(
          data['counterparty_bank']!,
          _counterpartyBankMeta,
        ),
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
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      direction: $TransactionsTable.$converterdirection.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}direction'],
        )!,
      ),
      category: $TransactionsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      status: $TransactionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      amountKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_kobo'],
      )!,
      feeKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fee_kobo'],
      )!,
      narration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}narration'],
      )!,
      counterpartyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty_name'],
      )!,
      counterpartyAccount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty_account'],
      ),
      counterpartyBank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty_bank'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxnDirection, String, String> $converterdirection =
      const EnumNameConverter<TxnDirection>(TxnDirection.values);
  static JsonTypeConverter2<TxnCategory, String, String> $convertercategory =
      const EnumNameConverter<TxnCategory>(TxnCategory.values);
  static JsonTypeConverter2<TxnStatus, String, String> $converterstatus =
      const EnumNameConverter<TxnStatus>(TxnStatus.values);
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final String accountId;
  final String reference;
  final TxnDirection direction;
  final TxnCategory category;
  final TxnStatus status;
  final int amountKobo;
  final int feeKobo;
  final String narration;
  final String counterpartyName;
  final String? counterpartyAccount;
  final String? counterpartyBank;
  final DateTime createdAt;
  const TransactionRow({
    required this.id,
    required this.accountId,
    required this.reference,
    required this.direction,
    required this.category,
    required this.status,
    required this.amountKobo,
    required this.feeKobo,
    required this.narration,
    required this.counterpartyName,
    this.counterpartyAccount,
    this.counterpartyBank,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['reference'] = Variable<String>(reference);
    {
      map['direction'] = Variable<String>(
        $TransactionsTable.$converterdirection.toSql(direction),
      );
    }
    {
      map['category'] = Variable<String>(
        $TransactionsTable.$convertercategory.toSql(category),
      );
    }
    {
      map['status'] = Variable<String>(
        $TransactionsTable.$converterstatus.toSql(status),
      );
    }
    map['amount_kobo'] = Variable<int>(amountKobo);
    map['fee_kobo'] = Variable<int>(feeKobo);
    map['narration'] = Variable<String>(narration);
    map['counterparty_name'] = Variable<String>(counterpartyName);
    if (!nullToAbsent || counterpartyAccount != null) {
      map['counterparty_account'] = Variable<String>(counterpartyAccount);
    }
    if (!nullToAbsent || counterpartyBank != null) {
      map['counterparty_bank'] = Variable<String>(counterpartyBank);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      reference: Value(reference),
      direction: Value(direction),
      category: Value(category),
      status: Value(status),
      amountKobo: Value(amountKobo),
      feeKobo: Value(feeKobo),
      narration: Value(narration),
      counterpartyName: Value(counterpartyName),
      counterpartyAccount: counterpartyAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(counterpartyAccount),
      counterpartyBank: counterpartyBank == null && nullToAbsent
          ? const Value.absent()
          : Value(counterpartyBank),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      reference: serializer.fromJson<String>(json['reference']),
      direction: $TransactionsTable.$converterdirection.fromJson(
        serializer.fromJson<String>(json['direction']),
      ),
      category: $TransactionsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      status: $TransactionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      amountKobo: serializer.fromJson<int>(json['amountKobo']),
      feeKobo: serializer.fromJson<int>(json['feeKobo']),
      narration: serializer.fromJson<String>(json['narration']),
      counterpartyName: serializer.fromJson<String>(json['counterpartyName']),
      counterpartyAccount: serializer.fromJson<String?>(
        json['counterpartyAccount'],
      ),
      counterpartyBank: serializer.fromJson<String?>(json['counterpartyBank']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'reference': serializer.toJson<String>(reference),
      'direction': serializer.toJson<String>(
        $TransactionsTable.$converterdirection.toJson(direction),
      ),
      'category': serializer.toJson<String>(
        $TransactionsTable.$convertercategory.toJson(category),
      ),
      'status': serializer.toJson<String>(
        $TransactionsTable.$converterstatus.toJson(status),
      ),
      'amountKobo': serializer.toJson<int>(amountKobo),
      'feeKobo': serializer.toJson<int>(feeKobo),
      'narration': serializer.toJson<String>(narration),
      'counterpartyName': serializer.toJson<String>(counterpartyName),
      'counterpartyAccount': serializer.toJson<String?>(counterpartyAccount),
      'counterpartyBank': serializer.toJson<String?>(counterpartyBank),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionRow copyWith({
    String? id,
    String? accountId,
    String? reference,
    TxnDirection? direction,
    TxnCategory? category,
    TxnStatus? status,
    int? amountKobo,
    int? feeKobo,
    String? narration,
    String? counterpartyName,
    Value<String?> counterpartyAccount = const Value.absent(),
    Value<String?> counterpartyBank = const Value.absent(),
    DateTime? createdAt,
  }) => TransactionRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    reference: reference ?? this.reference,
    direction: direction ?? this.direction,
    category: category ?? this.category,
    status: status ?? this.status,
    amountKobo: amountKobo ?? this.amountKobo,
    feeKobo: feeKobo ?? this.feeKobo,
    narration: narration ?? this.narration,
    counterpartyName: counterpartyName ?? this.counterpartyName,
    counterpartyAccount: counterpartyAccount.present
        ? counterpartyAccount.value
        : this.counterpartyAccount,
    counterpartyBank: counterpartyBank.present
        ? counterpartyBank.value
        : this.counterpartyBank,
    createdAt: createdAt ?? this.createdAt,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      reference: data.reference.present ? data.reference.value : this.reference,
      direction: data.direction.present ? data.direction.value : this.direction,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      amountKobo: data.amountKobo.present
          ? data.amountKobo.value
          : this.amountKobo,
      feeKobo: data.feeKobo.present ? data.feeKobo.value : this.feeKobo,
      narration: data.narration.present ? data.narration.value : this.narration,
      counterpartyName: data.counterpartyName.present
          ? data.counterpartyName.value
          : this.counterpartyName,
      counterpartyAccount: data.counterpartyAccount.present
          ? data.counterpartyAccount.value
          : this.counterpartyAccount,
      counterpartyBank: data.counterpartyBank.present
          ? data.counterpartyBank.value
          : this.counterpartyBank,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('reference: $reference, ')
          ..write('direction: $direction, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('feeKobo: $feeKobo, ')
          ..write('narration: $narration, ')
          ..write('counterpartyName: $counterpartyName, ')
          ..write('counterpartyAccount: $counterpartyAccount, ')
          ..write('counterpartyBank: $counterpartyBank, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    reference,
    direction,
    category,
    status,
    amountKobo,
    feeKobo,
    narration,
    counterpartyName,
    counterpartyAccount,
    counterpartyBank,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.reference == this.reference &&
          other.direction == this.direction &&
          other.category == this.category &&
          other.status == this.status &&
          other.amountKobo == this.amountKobo &&
          other.feeKobo == this.feeKobo &&
          other.narration == this.narration &&
          other.counterpartyName == this.counterpartyName &&
          other.counterpartyAccount == this.counterpartyAccount &&
          other.counterpartyBank == this.counterpartyBank &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> reference;
  final Value<TxnDirection> direction;
  final Value<TxnCategory> category;
  final Value<TxnStatus> status;
  final Value<int> amountKobo;
  final Value<int> feeKobo;
  final Value<String> narration;
  final Value<String> counterpartyName;
  final Value<String?> counterpartyAccount;
  final Value<String?> counterpartyBank;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.reference = const Value.absent(),
    this.direction = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.amountKobo = const Value.absent(),
    this.feeKobo = const Value.absent(),
    this.narration = const Value.absent(),
    this.counterpartyName = const Value.absent(),
    this.counterpartyAccount = const Value.absent(),
    this.counterpartyBank = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String accountId,
    required String reference,
    required TxnDirection direction,
    required TxnCategory category,
    required TxnStatus status,
    required int amountKobo,
    this.feeKobo = const Value.absent(),
    this.narration = const Value.absent(),
    required String counterpartyName,
    this.counterpartyAccount = const Value.absent(),
    this.counterpartyBank = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       reference = Value(reference),
       direction = Value(direction),
       category = Value(category),
       status = Value(status),
       amountKobo = Value(amountKobo),
       counterpartyName = Value(counterpartyName),
       createdAt = Value(createdAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? reference,
    Expression<String>? direction,
    Expression<String>? category,
    Expression<String>? status,
    Expression<int>? amountKobo,
    Expression<int>? feeKobo,
    Expression<String>? narration,
    Expression<String>? counterpartyName,
    Expression<String>? counterpartyAccount,
    Expression<String>? counterpartyBank,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (reference != null) 'reference': reference,
      if (direction != null) 'direction': direction,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (amountKobo != null) 'amount_kobo': amountKobo,
      if (feeKobo != null) 'fee_kobo': feeKobo,
      if (narration != null) 'narration': narration,
      if (counterpartyName != null) 'counterparty_name': counterpartyName,
      if (counterpartyAccount != null)
        'counterparty_account': counterpartyAccount,
      if (counterpartyBank != null) 'counterparty_bank': counterpartyBank,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? reference,
    Value<TxnDirection>? direction,
    Value<TxnCategory>? category,
    Value<TxnStatus>? status,
    Value<int>? amountKobo,
    Value<int>? feeKobo,
    Value<String>? narration,
    Value<String>? counterpartyName,
    Value<String?>? counterpartyAccount,
    Value<String?>? counterpartyBank,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      reference: reference ?? this.reference,
      direction: direction ?? this.direction,
      category: category ?? this.category,
      status: status ?? this.status,
      amountKobo: amountKobo ?? this.amountKobo,
      feeKobo: feeKobo ?? this.feeKobo,
      narration: narration ?? this.narration,
      counterpartyName: counterpartyName ?? this.counterpartyName,
      counterpartyAccount: counterpartyAccount ?? this.counterpartyAccount,
      counterpartyBank: counterpartyBank ?? this.counterpartyBank,
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
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(
        $TransactionsTable.$converterdirection.toSql(direction.value),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $TransactionsTable.$convertercategory.toSql(category.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TransactionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (amountKobo.present) {
      map['amount_kobo'] = Variable<int>(amountKobo.value);
    }
    if (feeKobo.present) {
      map['fee_kobo'] = Variable<int>(feeKobo.value);
    }
    if (narration.present) {
      map['narration'] = Variable<String>(narration.value);
    }
    if (counterpartyName.present) {
      map['counterparty_name'] = Variable<String>(counterpartyName.value);
    }
    if (counterpartyAccount.present) {
      map['counterparty_account'] = Variable<String>(counterpartyAccount.value);
    }
    if (counterpartyBank.present) {
      map['counterparty_bank'] = Variable<String>(counterpartyBank.value);
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
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('reference: $reference, ')
          ..write('direction: $direction, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('feeKobo: $feeKobo, ')
          ..write('narration: $narration, ')
          ..write('counterpartyName: $counterpartyName, ')
          ..write('counterpartyAccount: $counterpartyAccount, ')
          ..write('counterpartyBank: $counterpartyBank, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BeneficiariesTable extends Beneficiaries
    with TableInfo<$BeneficiariesTable, BeneficiaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeneficiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bankCodeMeta = const VerificationMeta(
    'bankCode',
  );
  @override
  late final GeneratedColumn<String> bankCode = GeneratedColumn<String>(
    'bank_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bankCode,
    accountNumber,
    name,
    lastUsedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beneficiaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BeneficiaryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bank_code')) {
      context.handle(
        _bankCodeMeta,
        bankCode.isAcceptableOrUnknown(data['bank_code']!, _bankCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_bankCodeMeta);
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUsedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bankCode, accountNumber};
  @override
  BeneficiaryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BeneficiaryRow(
      bankCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_code'],
      )!,
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      )!,
    );
  }

  @override
  $BeneficiariesTable createAlias(String alias) {
    return $BeneficiariesTable(attachedDatabase, alias);
  }
}

class BeneficiaryRow extends DataClass implements Insertable<BeneficiaryRow> {
  final String bankCode;
  final String accountNumber;
  final String name;
  final DateTime lastUsedAt;
  const BeneficiaryRow({
    required this.bankCode,
    required this.accountNumber,
    required this.name,
    required this.lastUsedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bank_code'] = Variable<String>(bankCode);
    map['account_number'] = Variable<String>(accountNumber);
    map['name'] = Variable<String>(name);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    return map;
  }

  BeneficiariesCompanion toCompanion(bool nullToAbsent) {
    return BeneficiariesCompanion(
      bankCode: Value(bankCode),
      accountNumber: Value(accountNumber),
      name: Value(name),
      lastUsedAt: Value(lastUsedAt),
    );
  }

  factory BeneficiaryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BeneficiaryRow(
      bankCode: serializer.fromJson<String>(json['bankCode']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
      name: serializer.fromJson<String>(json['name']),
      lastUsedAt: serializer.fromJson<DateTime>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bankCode': serializer.toJson<String>(bankCode),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'name': serializer.toJson<String>(name),
      'lastUsedAt': serializer.toJson<DateTime>(lastUsedAt),
    };
  }

  BeneficiaryRow copyWith({
    String? bankCode,
    String? accountNumber,
    String? name,
    DateTime? lastUsedAt,
  }) => BeneficiaryRow(
    bankCode: bankCode ?? this.bankCode,
    accountNumber: accountNumber ?? this.accountNumber,
    name: name ?? this.name,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
  );
  BeneficiaryRow copyWithCompanion(BeneficiariesCompanion data) {
    return BeneficiaryRow(
      bankCode: data.bankCode.present ? data.bankCode.value : this.bankCode,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      name: data.name.present ? data.name.value : this.name,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BeneficiaryRow(')
          ..write('bankCode: $bankCode, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('name: $name, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(bankCode, accountNumber, name, lastUsedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BeneficiaryRow &&
          other.bankCode == this.bankCode &&
          other.accountNumber == this.accountNumber &&
          other.name == this.name &&
          other.lastUsedAt == this.lastUsedAt);
}

class BeneficiariesCompanion extends UpdateCompanion<BeneficiaryRow> {
  final Value<String> bankCode;
  final Value<String> accountNumber;
  final Value<String> name;
  final Value<DateTime> lastUsedAt;
  final Value<int> rowid;
  const BeneficiariesCompanion({
    this.bankCode = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BeneficiariesCompanion.insert({
    required String bankCode,
    required String accountNumber,
    required String name,
    required DateTime lastUsedAt,
    this.rowid = const Value.absent(),
  }) : bankCode = Value(bankCode),
       accountNumber = Value(accountNumber),
       name = Value(name),
       lastUsedAt = Value(lastUsedAt);
  static Insertable<BeneficiaryRow> custom({
    Expression<String>? bankCode,
    Expression<String>? accountNumber,
    Expression<String>? name,
    Expression<DateTime>? lastUsedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bankCode != null) 'bank_code': bankCode,
      if (accountNumber != null) 'account_number': accountNumber,
      if (name != null) 'name': name,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BeneficiariesCompanion copyWith({
    Value<String>? bankCode,
    Value<String>? accountNumber,
    Value<String>? name,
    Value<DateTime>? lastUsedAt,
    Value<int>? rowid,
  }) {
    return BeneficiariesCompanion(
      bankCode: bankCode ?? this.bankCode,
      accountNumber: accountNumber ?? this.accountNumber,
      name: name ?? this.name,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bankCode.present) {
      map['bank_code'] = Variable<String>(bankCode.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeneficiariesCompanion(')
          ..write('bankCode: $bankCode, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('name: $name, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DemoMetaTable extends DemoMeta
    with TableInfo<$DemoMetaTable, DemoMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DemoMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'demo_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<DemoMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DemoMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DemoMetaRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $DemoMetaTable createAlias(String alias) {
    return $DemoMetaTable(attachedDatabase, alias);
  }
}

class DemoMetaRow extends DataClass implements Insertable<DemoMetaRow> {
  final String key;
  final String value;
  const DemoMetaRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  DemoMetaCompanion toCompanion(bool nullToAbsent) {
    return DemoMetaCompanion(key: Value(key), value: Value(value));
  }

  factory DemoMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DemoMetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  DemoMetaRow copyWith({String? key, String? value}) =>
      DemoMetaRow(key: key ?? this.key, value: value ?? this.value);
  DemoMetaRow copyWithCompanion(DemoMetaCompanion data) {
    return DemoMetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DemoMetaRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DemoMetaRow &&
          other.key == this.key &&
          other.value == this.value);
}

class DemoMetaCompanion extends UpdateCompanion<DemoMetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const DemoMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DemoMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<DemoMetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DemoMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return DemoMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DemoMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MortgagesTable extends Mortgages
    with TableInfo<$MortgagesTable, MortgageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MortgagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MortgageProduct, String> product =
      GeneratedColumn<String>(
        'product',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MortgageProduct>($MortgagesTable.$converterproduct);
  static const VerificationMeta _propertyNameMeta = const VerificationMeta(
    'propertyName',
  );
  @override
  late final GeneratedColumn<String> propertyName = GeneratedColumn<String>(
    'property_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyLocationMeta = const VerificationMeta(
    'propertyLocation',
  );
  @override
  late final GeneratedColumn<String> propertyLocation = GeneratedColumn<String>(
    'property_location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalKoboMeta = const VerificationMeta(
    'principalKobo',
  );
  @override
  late final GeneratedColumn<int> principalKobo = GeneratedColumn<int>(
    'principal_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenorMonthsMeta = const VerificationMeta(
    'tenorMonths',
  );
  @override
  late final GeneratedColumn<int> tenorMonths = GeneratedColumn<int>(
    'tenor_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstDueDateMeta = const VerificationMeta(
    'firstDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> firstDueDate = GeneratedColumn<DateTime>(
    'first_due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installmentsPaidMeta = const VerificationMeta(
    'installmentsPaid',
  );
  @override
  late final GeneratedColumn<int> installmentsPaid = GeneratedColumn<int>(
    'installments_paid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    product,
    propertyName,
    propertyLocation,
    principalKobo,
    tenorMonths,
    firstDueDate,
    installmentsPaid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mortgages';
  @override
  VerificationContext validateIntegrity(
    Insertable<MortgageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('property_name')) {
      context.handle(
        _propertyNameMeta,
        propertyName.isAcceptableOrUnknown(
          data['property_name']!,
          _propertyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_propertyNameMeta);
    }
    if (data.containsKey('property_location')) {
      context.handle(
        _propertyLocationMeta,
        propertyLocation.isAcceptableOrUnknown(
          data['property_location']!,
          _propertyLocationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_propertyLocationMeta);
    }
    if (data.containsKey('principal_kobo')) {
      context.handle(
        _principalKoboMeta,
        principalKobo.isAcceptableOrUnknown(
          data['principal_kobo']!,
          _principalKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalKoboMeta);
    }
    if (data.containsKey('tenor_months')) {
      context.handle(
        _tenorMonthsMeta,
        tenorMonths.isAcceptableOrUnknown(
          data['tenor_months']!,
          _tenorMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tenorMonthsMeta);
    }
    if (data.containsKey('first_due_date')) {
      context.handle(
        _firstDueDateMeta,
        firstDueDate.isAcceptableOrUnknown(
          data['first_due_date']!,
          _firstDueDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstDueDateMeta);
    }
    if (data.containsKey('installments_paid')) {
      context.handle(
        _installmentsPaidMeta,
        installmentsPaid.isAcceptableOrUnknown(
          data['installments_paid']!,
          _installmentsPaidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentsPaidMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MortgageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MortgageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      product: $MortgagesTable.$converterproduct.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}product'],
        )!,
      ),
      propertyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property_name'],
      )!,
      propertyLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property_location'],
      )!,
      principalKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_kobo'],
      )!,
      tenorMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tenor_months'],
      )!,
      firstDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_due_date'],
      )!,
      installmentsPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installments_paid'],
      )!,
    );
  }

  @override
  $MortgagesTable createAlias(String alias) {
    return $MortgagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MortgageProduct, String, String> $converterproduct =
      const EnumNameConverter<MortgageProduct>(MortgageProduct.values);
}

class MortgageRow extends DataClass implements Insertable<MortgageRow> {
  final String id;
  final MortgageProduct product;
  final String propertyName;
  final String propertyLocation;
  final int principalKobo;
  final int tenorMonths;
  final DateTime firstDueDate;
  final int installmentsPaid;
  const MortgageRow({
    required this.id,
    required this.product,
    required this.propertyName,
    required this.propertyLocation,
    required this.principalKobo,
    required this.tenorMonths,
    required this.firstDueDate,
    required this.installmentsPaid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['product'] = Variable<String>(
        $MortgagesTable.$converterproduct.toSql(product),
      );
    }
    map['property_name'] = Variable<String>(propertyName);
    map['property_location'] = Variable<String>(propertyLocation);
    map['principal_kobo'] = Variable<int>(principalKobo);
    map['tenor_months'] = Variable<int>(tenorMonths);
    map['first_due_date'] = Variable<DateTime>(firstDueDate);
    map['installments_paid'] = Variable<int>(installmentsPaid);
    return map;
  }

  MortgagesCompanion toCompanion(bool nullToAbsent) {
    return MortgagesCompanion(
      id: Value(id),
      product: Value(product),
      propertyName: Value(propertyName),
      propertyLocation: Value(propertyLocation),
      principalKobo: Value(principalKobo),
      tenorMonths: Value(tenorMonths),
      firstDueDate: Value(firstDueDate),
      installmentsPaid: Value(installmentsPaid),
    );
  }

  factory MortgageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MortgageRow(
      id: serializer.fromJson<String>(json['id']),
      product: $MortgagesTable.$converterproduct.fromJson(
        serializer.fromJson<String>(json['product']),
      ),
      propertyName: serializer.fromJson<String>(json['propertyName']),
      propertyLocation: serializer.fromJson<String>(json['propertyLocation']),
      principalKobo: serializer.fromJson<int>(json['principalKobo']),
      tenorMonths: serializer.fromJson<int>(json['tenorMonths']),
      firstDueDate: serializer.fromJson<DateTime>(json['firstDueDate']),
      installmentsPaid: serializer.fromJson<int>(json['installmentsPaid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'product': serializer.toJson<String>(
        $MortgagesTable.$converterproduct.toJson(product),
      ),
      'propertyName': serializer.toJson<String>(propertyName),
      'propertyLocation': serializer.toJson<String>(propertyLocation),
      'principalKobo': serializer.toJson<int>(principalKobo),
      'tenorMonths': serializer.toJson<int>(tenorMonths),
      'firstDueDate': serializer.toJson<DateTime>(firstDueDate),
      'installmentsPaid': serializer.toJson<int>(installmentsPaid),
    };
  }

  MortgageRow copyWith({
    String? id,
    MortgageProduct? product,
    String? propertyName,
    String? propertyLocation,
    int? principalKobo,
    int? tenorMonths,
    DateTime? firstDueDate,
    int? installmentsPaid,
  }) => MortgageRow(
    id: id ?? this.id,
    product: product ?? this.product,
    propertyName: propertyName ?? this.propertyName,
    propertyLocation: propertyLocation ?? this.propertyLocation,
    principalKobo: principalKobo ?? this.principalKobo,
    tenorMonths: tenorMonths ?? this.tenorMonths,
    firstDueDate: firstDueDate ?? this.firstDueDate,
    installmentsPaid: installmentsPaid ?? this.installmentsPaid,
  );
  MortgageRow copyWithCompanion(MortgagesCompanion data) {
    return MortgageRow(
      id: data.id.present ? data.id.value : this.id,
      product: data.product.present ? data.product.value : this.product,
      propertyName: data.propertyName.present
          ? data.propertyName.value
          : this.propertyName,
      propertyLocation: data.propertyLocation.present
          ? data.propertyLocation.value
          : this.propertyLocation,
      principalKobo: data.principalKobo.present
          ? data.principalKobo.value
          : this.principalKobo,
      tenorMonths: data.tenorMonths.present
          ? data.tenorMonths.value
          : this.tenorMonths,
      firstDueDate: data.firstDueDate.present
          ? data.firstDueDate.value
          : this.firstDueDate,
      installmentsPaid: data.installmentsPaid.present
          ? data.installmentsPaid.value
          : this.installmentsPaid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MortgageRow(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('propertyName: $propertyName, ')
          ..write('propertyLocation: $propertyLocation, ')
          ..write('principalKobo: $principalKobo, ')
          ..write('tenorMonths: $tenorMonths, ')
          ..write('firstDueDate: $firstDueDate, ')
          ..write('installmentsPaid: $installmentsPaid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    product,
    propertyName,
    propertyLocation,
    principalKobo,
    tenorMonths,
    firstDueDate,
    installmentsPaid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MortgageRow &&
          other.id == this.id &&
          other.product == this.product &&
          other.propertyName == this.propertyName &&
          other.propertyLocation == this.propertyLocation &&
          other.principalKobo == this.principalKobo &&
          other.tenorMonths == this.tenorMonths &&
          other.firstDueDate == this.firstDueDate &&
          other.installmentsPaid == this.installmentsPaid);
}

class MortgagesCompanion extends UpdateCompanion<MortgageRow> {
  final Value<String> id;
  final Value<MortgageProduct> product;
  final Value<String> propertyName;
  final Value<String> propertyLocation;
  final Value<int> principalKobo;
  final Value<int> tenorMonths;
  final Value<DateTime> firstDueDate;
  final Value<int> installmentsPaid;
  final Value<int> rowid;
  const MortgagesCompanion({
    this.id = const Value.absent(),
    this.product = const Value.absent(),
    this.propertyName = const Value.absent(),
    this.propertyLocation = const Value.absent(),
    this.principalKobo = const Value.absent(),
    this.tenorMonths = const Value.absent(),
    this.firstDueDate = const Value.absent(),
    this.installmentsPaid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MortgagesCompanion.insert({
    required String id,
    required MortgageProduct product,
    required String propertyName,
    required String propertyLocation,
    required int principalKobo,
    required int tenorMonths,
    required DateTime firstDueDate,
    required int installmentsPaid,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       product = Value(product),
       propertyName = Value(propertyName),
       propertyLocation = Value(propertyLocation),
       principalKobo = Value(principalKobo),
       tenorMonths = Value(tenorMonths),
       firstDueDate = Value(firstDueDate),
       installmentsPaid = Value(installmentsPaid);
  static Insertable<MortgageRow> custom({
    Expression<String>? id,
    Expression<String>? product,
    Expression<String>? propertyName,
    Expression<String>? propertyLocation,
    Expression<int>? principalKobo,
    Expression<int>? tenorMonths,
    Expression<DateTime>? firstDueDate,
    Expression<int>? installmentsPaid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (product != null) 'product': product,
      if (propertyName != null) 'property_name': propertyName,
      if (propertyLocation != null) 'property_location': propertyLocation,
      if (principalKobo != null) 'principal_kobo': principalKobo,
      if (tenorMonths != null) 'tenor_months': tenorMonths,
      if (firstDueDate != null) 'first_due_date': firstDueDate,
      if (installmentsPaid != null) 'installments_paid': installmentsPaid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MortgagesCompanion copyWith({
    Value<String>? id,
    Value<MortgageProduct>? product,
    Value<String>? propertyName,
    Value<String>? propertyLocation,
    Value<int>? principalKobo,
    Value<int>? tenorMonths,
    Value<DateTime>? firstDueDate,
    Value<int>? installmentsPaid,
    Value<int>? rowid,
  }) {
    return MortgagesCompanion(
      id: id ?? this.id,
      product: product ?? this.product,
      propertyName: propertyName ?? this.propertyName,
      propertyLocation: propertyLocation ?? this.propertyLocation,
      principalKobo: principalKobo ?? this.principalKobo,
      tenorMonths: tenorMonths ?? this.tenorMonths,
      firstDueDate: firstDueDate ?? this.firstDueDate,
      installmentsPaid: installmentsPaid ?? this.installmentsPaid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (product.present) {
      map['product'] = Variable<String>(
        $MortgagesTable.$converterproduct.toSql(product.value),
      );
    }
    if (propertyName.present) {
      map['property_name'] = Variable<String>(propertyName.value);
    }
    if (propertyLocation.present) {
      map['property_location'] = Variable<String>(propertyLocation.value);
    }
    if (principalKobo.present) {
      map['principal_kobo'] = Variable<int>(principalKobo.value);
    }
    if (tenorMonths.present) {
      map['tenor_months'] = Variable<int>(tenorMonths.value);
    }
    if (firstDueDate.present) {
      map['first_due_date'] = Variable<DateTime>(firstDueDate.value);
    }
    if (installmentsPaid.present) {
      map['installments_paid'] = Variable<int>(installmentsPaid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MortgagesCompanion(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('propertyName: $propertyName, ')
          ..write('propertyLocation: $propertyLocation, ')
          ..write('principalKobo: $principalKobo, ')
          ..write('tenorMonths: $tenorMonths, ')
          ..write('firstDueDate: $firstDueDate, ')
          ..write('installmentsPaid: $installmentsPaid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MortgageApplicationsTable extends MortgageApplications
    with TableInfo<$MortgageApplicationsTable, MortgageApplicationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MortgageApplicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MortgageProduct, String> product =
      GeneratedColumn<String>(
        'product',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MortgageProduct>(
        $MortgageApplicationsTable.$converterproduct,
      );
  static const VerificationMeta _amountKoboMeta = const VerificationMeta(
    'amountKobo',
  );
  @override
  late final GeneratedColumn<int> amountKobo = GeneratedColumn<int>(
    'amount_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenorMonthsMeta = const VerificationMeta(
    'tenorMonths',
  );
  @override
  late final GeneratedColumn<int> tenorMonths = GeneratedColumn<int>(
    'tenor_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyMeta = const VerificationMeta(
    'property',
  );
  @override
  late final GeneratedColumn<String> property = GeneratedColumn<String>(
    'property',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyIncomeKoboMeta = const VerificationMeta(
    'monthlyIncomeKobo',
  );
  @override
  late final GeneratedColumn<int> monthlyIncomeKobo = GeneratedColumn<int>(
    'monthly_income_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    product,
    amountKobo,
    tenorMonths,
    property,
    monthlyIncomeKobo,
    submittedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mortgage_applications';
  @override
  VerificationContext validateIntegrity(
    Insertable<MortgageApplicationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_kobo')) {
      context.handle(
        _amountKoboMeta,
        amountKobo.isAcceptableOrUnknown(data['amount_kobo']!, _amountKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_amountKoboMeta);
    }
    if (data.containsKey('tenor_months')) {
      context.handle(
        _tenorMonthsMeta,
        tenorMonths.isAcceptableOrUnknown(
          data['tenor_months']!,
          _tenorMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tenorMonthsMeta);
    }
    if (data.containsKey('property')) {
      context.handle(
        _propertyMeta,
        property.isAcceptableOrUnknown(data['property']!, _propertyMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyMeta);
    }
    if (data.containsKey('monthly_income_kobo')) {
      context.handle(
        _monthlyIncomeKoboMeta,
        monthlyIncomeKobo.isAcceptableOrUnknown(
          data['monthly_income_kobo']!,
          _monthlyIncomeKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyIncomeKoboMeta);
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submittedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MortgageApplicationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MortgageApplicationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      product: $MortgageApplicationsTable.$converterproduct.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}product'],
        )!,
      ),
      amountKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_kobo'],
      )!,
      tenorMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tenor_months'],
      )!,
      property: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property'],
      )!,
      monthlyIncomeKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_income_kobo'],
      )!,
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      )!,
    );
  }

  @override
  $MortgageApplicationsTable createAlias(String alias) {
    return $MortgageApplicationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MortgageProduct, String, String> $converterproduct =
      const EnumNameConverter<MortgageProduct>(MortgageProduct.values);
}

class MortgageApplicationRow extends DataClass
    implements Insertable<MortgageApplicationRow> {
  final String id;
  final MortgageProduct product;
  final int amountKobo;
  final int tenorMonths;
  final String property;
  final int monthlyIncomeKobo;
  final DateTime submittedAt;
  const MortgageApplicationRow({
    required this.id,
    required this.product,
    required this.amountKobo,
    required this.tenorMonths,
    required this.property,
    required this.monthlyIncomeKobo,
    required this.submittedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['product'] = Variable<String>(
        $MortgageApplicationsTable.$converterproduct.toSql(product),
      );
    }
    map['amount_kobo'] = Variable<int>(amountKobo);
    map['tenor_months'] = Variable<int>(tenorMonths);
    map['property'] = Variable<String>(property);
    map['monthly_income_kobo'] = Variable<int>(monthlyIncomeKobo);
    map['submitted_at'] = Variable<DateTime>(submittedAt);
    return map;
  }

  MortgageApplicationsCompanion toCompanion(bool nullToAbsent) {
    return MortgageApplicationsCompanion(
      id: Value(id),
      product: Value(product),
      amountKobo: Value(amountKobo),
      tenorMonths: Value(tenorMonths),
      property: Value(property),
      monthlyIncomeKobo: Value(monthlyIncomeKobo),
      submittedAt: Value(submittedAt),
    );
  }

  factory MortgageApplicationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MortgageApplicationRow(
      id: serializer.fromJson<String>(json['id']),
      product: $MortgageApplicationsTable.$converterproduct.fromJson(
        serializer.fromJson<String>(json['product']),
      ),
      amountKobo: serializer.fromJson<int>(json['amountKobo']),
      tenorMonths: serializer.fromJson<int>(json['tenorMonths']),
      property: serializer.fromJson<String>(json['property']),
      monthlyIncomeKobo: serializer.fromJson<int>(json['monthlyIncomeKobo']),
      submittedAt: serializer.fromJson<DateTime>(json['submittedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'product': serializer.toJson<String>(
        $MortgageApplicationsTable.$converterproduct.toJson(product),
      ),
      'amountKobo': serializer.toJson<int>(amountKobo),
      'tenorMonths': serializer.toJson<int>(tenorMonths),
      'property': serializer.toJson<String>(property),
      'monthlyIncomeKobo': serializer.toJson<int>(monthlyIncomeKobo),
      'submittedAt': serializer.toJson<DateTime>(submittedAt),
    };
  }

  MortgageApplicationRow copyWith({
    String? id,
    MortgageProduct? product,
    int? amountKobo,
    int? tenorMonths,
    String? property,
    int? monthlyIncomeKobo,
    DateTime? submittedAt,
  }) => MortgageApplicationRow(
    id: id ?? this.id,
    product: product ?? this.product,
    amountKobo: amountKobo ?? this.amountKobo,
    tenorMonths: tenorMonths ?? this.tenorMonths,
    property: property ?? this.property,
    monthlyIncomeKobo: monthlyIncomeKobo ?? this.monthlyIncomeKobo,
    submittedAt: submittedAt ?? this.submittedAt,
  );
  MortgageApplicationRow copyWithCompanion(MortgageApplicationsCompanion data) {
    return MortgageApplicationRow(
      id: data.id.present ? data.id.value : this.id,
      product: data.product.present ? data.product.value : this.product,
      amountKobo: data.amountKobo.present
          ? data.amountKobo.value
          : this.amountKobo,
      tenorMonths: data.tenorMonths.present
          ? data.tenorMonths.value
          : this.tenorMonths,
      property: data.property.present ? data.property.value : this.property,
      monthlyIncomeKobo: data.monthlyIncomeKobo.present
          ? data.monthlyIncomeKobo.value
          : this.monthlyIncomeKobo,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MortgageApplicationRow(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('tenorMonths: $tenorMonths, ')
          ..write('property: $property, ')
          ..write('monthlyIncomeKobo: $monthlyIncomeKobo, ')
          ..write('submittedAt: $submittedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    product,
    amountKobo,
    tenorMonths,
    property,
    monthlyIncomeKobo,
    submittedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MortgageApplicationRow &&
          other.id == this.id &&
          other.product == this.product &&
          other.amountKobo == this.amountKobo &&
          other.tenorMonths == this.tenorMonths &&
          other.property == this.property &&
          other.monthlyIncomeKobo == this.monthlyIncomeKobo &&
          other.submittedAt == this.submittedAt);
}

class MortgageApplicationsCompanion
    extends UpdateCompanion<MortgageApplicationRow> {
  final Value<String> id;
  final Value<MortgageProduct> product;
  final Value<int> amountKobo;
  final Value<int> tenorMonths;
  final Value<String> property;
  final Value<int> monthlyIncomeKobo;
  final Value<DateTime> submittedAt;
  final Value<int> rowid;
  const MortgageApplicationsCompanion({
    this.id = const Value.absent(),
    this.product = const Value.absent(),
    this.amountKobo = const Value.absent(),
    this.tenorMonths = const Value.absent(),
    this.property = const Value.absent(),
    this.monthlyIncomeKobo = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MortgageApplicationsCompanion.insert({
    required String id,
    required MortgageProduct product,
    required int amountKobo,
    required int tenorMonths,
    required String property,
    required int monthlyIncomeKobo,
    required DateTime submittedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       product = Value(product),
       amountKobo = Value(amountKobo),
       tenorMonths = Value(tenorMonths),
       property = Value(property),
       monthlyIncomeKobo = Value(monthlyIncomeKobo),
       submittedAt = Value(submittedAt);
  static Insertable<MortgageApplicationRow> custom({
    Expression<String>? id,
    Expression<String>? product,
    Expression<int>? amountKobo,
    Expression<int>? tenorMonths,
    Expression<String>? property,
    Expression<int>? monthlyIncomeKobo,
    Expression<DateTime>? submittedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (product != null) 'product': product,
      if (amountKobo != null) 'amount_kobo': amountKobo,
      if (tenorMonths != null) 'tenor_months': tenorMonths,
      if (property != null) 'property': property,
      if (monthlyIncomeKobo != null) 'monthly_income_kobo': monthlyIncomeKobo,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MortgageApplicationsCompanion copyWith({
    Value<String>? id,
    Value<MortgageProduct>? product,
    Value<int>? amountKobo,
    Value<int>? tenorMonths,
    Value<String>? property,
    Value<int>? monthlyIncomeKobo,
    Value<DateTime>? submittedAt,
    Value<int>? rowid,
  }) {
    return MortgageApplicationsCompanion(
      id: id ?? this.id,
      product: product ?? this.product,
      amountKobo: amountKobo ?? this.amountKobo,
      tenorMonths: tenorMonths ?? this.tenorMonths,
      property: property ?? this.property,
      monthlyIncomeKobo: monthlyIncomeKobo ?? this.monthlyIncomeKobo,
      submittedAt: submittedAt ?? this.submittedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (product.present) {
      map['product'] = Variable<String>(
        $MortgageApplicationsTable.$converterproduct.toSql(product.value),
      );
    }
    if (amountKobo.present) {
      map['amount_kobo'] = Variable<int>(amountKobo.value);
    }
    if (tenorMonths.present) {
      map['tenor_months'] = Variable<int>(tenorMonths.value);
    }
    if (property.present) {
      map['property'] = Variable<String>(property.value);
    }
    if (monthlyIncomeKobo.present) {
      map['monthly_income_kobo'] = Variable<int>(monthlyIncomeKobo.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MortgageApplicationsCompanion(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('tenorMonths: $tenorMonths, ')
          ..write('property: $property, ')
          ..write('monthlyIncomeKobo: $monthlyIncomeKobo, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomerProfilesTable extends CustomerProfiles
    with TableInfo<$CustomerProfilesTable, CustomerProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bvnLast4Meta = const VerificationMeta(
    'bvnLast4',
  );
  @override
  late final GeneratedColumn<String> bvnLast4 = GeneratedColumn<String>(
    'bvn_last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ninLast4Meta = const VerificationMeta(
    'ninLast4',
  );
  @override
  late final GeneratedColumn<String> ninLast4 = GeneratedColumn<String>(
    'nin_last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memberSinceMeta = const VerificationMeta(
    'memberSince',
  );
  @override
  late final GeneratedColumn<DateTime> memberSince = GeneratedColumn<DateTime>(
    'member_since',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    accountId,
    phone,
    email,
    dateOfBirth,
    address,
    bvnLast4,
    ninLast4,
    memberSince,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('bvn_last4')) {
      context.handle(
        _bvnLast4Meta,
        bvnLast4.isAcceptableOrUnknown(data['bvn_last4']!, _bvnLast4Meta),
      );
    }
    if (data.containsKey('nin_last4')) {
      context.handle(
        _ninLast4Meta,
        ninLast4.isAcceptableOrUnknown(data['nin_last4']!, _ninLast4Meta),
      );
    }
    if (data.containsKey('member_since')) {
      context.handle(
        _memberSinceMeta,
        memberSince.isAcceptableOrUnknown(
          data['member_since']!,
          _memberSinceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_memberSinceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId};
  @override
  CustomerProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerProfileRow(
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      bvnLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bvn_last4'],
      ),
      ninLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nin_last4'],
      ),
      memberSince: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}member_since'],
      )!,
    );
  }

  @override
  $CustomerProfilesTable createAlias(String alias) {
    return $CustomerProfilesTable(attachedDatabase, alias);
  }
}

class CustomerProfileRow extends DataClass
    implements Insertable<CustomerProfileRow> {
  final String accountId;
  final String phone;
  final String? email;
  final DateTime? dateOfBirth;
  final String? address;
  final String? bvnLast4;
  final String? ninLast4;
  final DateTime memberSince;
  const CustomerProfileRow({
    required this.accountId,
    required this.phone,
    this.email,
    this.dateOfBirth,
    this.address,
    this.bvnLast4,
    this.ninLast4,
    required this.memberSince,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<String>(accountId);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || bvnLast4 != null) {
      map['bvn_last4'] = Variable<String>(bvnLast4);
    }
    if (!nullToAbsent || ninLast4 != null) {
      map['nin_last4'] = Variable<String>(ninLast4);
    }
    map['member_since'] = Variable<DateTime>(memberSince);
    return map;
  }

  CustomerProfilesCompanion toCompanion(bool nullToAbsent) {
    return CustomerProfilesCompanion(
      accountId: Value(accountId),
      phone: Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      bvnLast4: bvnLast4 == null && nullToAbsent
          ? const Value.absent()
          : Value(bvnLast4),
      ninLast4: ninLast4 == null && nullToAbsent
          ? const Value.absent()
          : Value(ninLast4),
      memberSince: Value(memberSince),
    );
  }

  factory CustomerProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerProfileRow(
      accountId: serializer.fromJson<String>(json['accountId']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      address: serializer.fromJson<String?>(json['address']),
      bvnLast4: serializer.fromJson<String?>(json['bvnLast4']),
      ninLast4: serializer.fromJson<String?>(json['ninLast4']),
      memberSince: serializer.fromJson<DateTime>(json['memberSince']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String>(accountId),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String?>(email),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'address': serializer.toJson<String?>(address),
      'bvnLast4': serializer.toJson<String?>(bvnLast4),
      'ninLast4': serializer.toJson<String?>(ninLast4),
      'memberSince': serializer.toJson<DateTime>(memberSince),
    };
  }

  CustomerProfileRow copyWith({
    String? accountId,
    String? phone,
    Value<String?> email = const Value.absent(),
    Value<DateTime?> dateOfBirth = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> bvnLast4 = const Value.absent(),
    Value<String?> ninLast4 = const Value.absent(),
    DateTime? memberSince,
  }) => CustomerProfileRow(
    accountId: accountId ?? this.accountId,
    phone: phone ?? this.phone,
    email: email.present ? email.value : this.email,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    address: address.present ? address.value : this.address,
    bvnLast4: bvnLast4.present ? bvnLast4.value : this.bvnLast4,
    ninLast4: ninLast4.present ? ninLast4.value : this.ninLast4,
    memberSince: memberSince ?? this.memberSince,
  );
  CustomerProfileRow copyWithCompanion(CustomerProfilesCompanion data) {
    return CustomerProfileRow(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      address: data.address.present ? data.address.value : this.address,
      bvnLast4: data.bvnLast4.present ? data.bvnLast4.value : this.bvnLast4,
      ninLast4: data.ninLast4.present ? data.ninLast4.value : this.ninLast4,
      memberSince: data.memberSince.present
          ? data.memberSince.value
          : this.memberSince,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerProfileRow(')
          ..write('accountId: $accountId, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('address: $address, ')
          ..write('bvnLast4: $bvnLast4, ')
          ..write('ninLast4: $ninLast4, ')
          ..write('memberSince: $memberSince')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    accountId,
    phone,
    email,
    dateOfBirth,
    address,
    bvnLast4,
    ninLast4,
    memberSince,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerProfileRow &&
          other.accountId == this.accountId &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.dateOfBirth == this.dateOfBirth &&
          other.address == this.address &&
          other.bvnLast4 == this.bvnLast4 &&
          other.ninLast4 == this.ninLast4 &&
          other.memberSince == this.memberSince);
}

class CustomerProfilesCompanion extends UpdateCompanion<CustomerProfileRow> {
  final Value<String> accountId;
  final Value<String> phone;
  final Value<String?> email;
  final Value<DateTime?> dateOfBirth;
  final Value<String?> address;
  final Value<String?> bvnLast4;
  final Value<String?> ninLast4;
  final Value<DateTime> memberSince;
  final Value<int> rowid;
  const CustomerProfilesCompanion({
    this.accountId = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.address = const Value.absent(),
    this.bvnLast4 = const Value.absent(),
    this.ninLast4 = const Value.absent(),
    this.memberSince = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomerProfilesCompanion.insert({
    required String accountId,
    required String phone,
    this.email = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.address = const Value.absent(),
    this.bvnLast4 = const Value.absent(),
    this.ninLast4 = const Value.absent(),
    required DateTime memberSince,
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       phone = Value(phone),
       memberSince = Value(memberSince);
  static Insertable<CustomerProfileRow> custom({
    Expression<String>? accountId,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? address,
    Expression<String>? bvnLast4,
    Expression<String>? ninLast4,
    Expression<DateTime>? memberSince,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (address != null) 'address': address,
      if (bvnLast4 != null) 'bvn_last4': bvnLast4,
      if (ninLast4 != null) 'nin_last4': ninLast4,
      if (memberSince != null) 'member_since': memberSince,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomerProfilesCompanion copyWith({
    Value<String>? accountId,
    Value<String>? phone,
    Value<String?>? email,
    Value<DateTime?>? dateOfBirth,
    Value<String?>? address,
    Value<String?>? bvnLast4,
    Value<String?>? ninLast4,
    Value<DateTime>? memberSince,
    Value<int>? rowid,
  }) {
    return CustomerProfilesCompanion(
      accountId: accountId ?? this.accountId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      bvnLast4: bvnLast4 ?? this.bvnLast4,
      ninLast4: ninLast4 ?? this.ninLast4,
      memberSince: memberSince ?? this.memberSince,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (bvnLast4.present) {
      map['bvn_last4'] = Variable<String>(bvnLast4.value);
    }
    if (ninLast4.present) {
      map['nin_last4'] = Variable<String>(ninLast4.value);
    }
    if (memberSince.present) {
      map['member_since'] = Variable<DateTime>(memberSince.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerProfilesCompanion(')
          ..write('accountId: $accountId, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('address: $address, ')
          ..write('bvnLast4: $bvnLast4, ')
          ..write('ninLast4: $ninLast4, ')
          ..write('memberSince: $memberSince, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BeneficiariesTable beneficiaries = $BeneficiariesTable(this);
  late final $DemoMetaTable demoMeta = $DemoMetaTable(this);
  late final $MortgagesTable mortgages = $MortgagesTable(this);
  late final $MortgageApplicationsTable mortgageApplications =
      $MortgageApplicationsTable(this);
  late final $CustomerProfilesTable customerProfiles = $CustomerProfilesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    transactions,
    beneficiaries,
    demoMeta,
    mortgages,
    mortgageApplications,
    customerProfiles,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String holderName,
  required String accountNumber,
  required int balanceKobo,
  Value<int> kycTier,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> holderName,
  Value<String> accountNumber,
  Value<int> balanceKobo,
  Value<int> kycTier,
  Value<int> rowid,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, AccountRow> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<TransactionRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'accounts__id__transactions__account_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CustomerProfilesTable, List<CustomerProfileRow>>
  _customerProfilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customerProfiles,
    aliasName: 'accounts__id__customer_profiles__account_id',
  );

  $$CustomerProfilesTableProcessedTableManager get customerProfilesRefs {
    final manager = $$CustomerProfilesTableTableManager(
      $_db,
      $_db.customerProfiles,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _customerProfilesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
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

  ColumnFilters<String> get holderName => $composableBuilder(
    column: $table.holderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceKobo => $composableBuilder(
    column: $table.balanceKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kycTier => $composableBuilder(
    column: $table.kycTier,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> customerProfilesRefs(
    Expression<bool> Function($$CustomerProfilesTableFilterComposer f) f,
  ) {
    final $$CustomerProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customerProfiles,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomerProfilesTableFilterComposer(
            $db: $db,
            $table: $db.customerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
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

  ColumnOrderings<String> get holderName => $composableBuilder(
    column: $table.holderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceKobo => $composableBuilder(
    column: $table.balanceKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kycTier => $composableBuilder(
    column: $table.kycTier,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get holderName => $composableBuilder(
    column: $table.holderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get balanceKobo => $composableBuilder(
    column: $table.balanceKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kycTier =>
      $composableBuilder(column: $table.kycTier, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> customerProfilesRefs<T extends Object>(
    Expression<T> Function($$CustomerProfilesTableAnnotationComposer a) f,
  ) {
    final $$CustomerProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customerProfiles,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomerProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.customerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          AccountRow,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (AccountRow, $$AccountsTableReferences),
          AccountRow,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool customerProfilesRefs,
          })
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> holderName = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
                Value<int> balanceKobo = const Value.absent(),
                Value<int> kycTier = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                holderName: holderName,
                accountNumber: accountNumber,
                balanceKobo: balanceKobo,
                kycTier: kycTier,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String holderName,
                required String accountNumber,
                required int balanceKobo,
                Value<int> kycTier = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                holderName: holderName,
                accountNumber: accountNumber,
                balanceKobo: balanceKobo,
                kycTier: kycTier,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, AccountRow>(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({transactionsRefs = false, customerProfilesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (customerProfilesRefs) db.customerProfiles,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          TransactionRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (customerProfilesRefs)
                        await $_getPrefetchedData<
                          AccountRow,
                          $AccountsTable,
                          CustomerProfileRow
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._customerProfilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).customerProfilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
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

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      AccountRow,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (AccountRow, $$AccountsTableReferences),
      AccountRow,
      PrefetchHooks Function({bool transactionsRefs, bool customerProfilesRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String accountId,
      required String reference,
      required TxnDirection direction,
      required TxnCategory category,
      required TxnStatus status,
      required int amountKobo,
      Value<int> feeKobo,
      Value<String> narration,
      required String counterpartyName,
      Value<String?> counterpartyAccount,
      Value<String?> counterpartyBank,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> reference,
      Value<TxnDirection> direction,
      Value<TxnCategory> category,
      Value<TxnStatus> status,
      Value<int> amountKobo,
      Value<int> feeKobo,
      Value<String> narration,
      Value<String> counterpartyName,
      Value<String?> counterpartyAccount,
      Value<String?> counterpartyBank,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('transactions__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnDirection, TxnDirection, String>
  get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnCategory, TxnCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnStatus, TxnStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get feeKobo => $composableBuilder(
    column: $table.feeKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get narration => $composableBuilder(
    column: $table.narration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterpartyName => $composableBuilder(
    column: $table.counterpartyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterpartyAccount => $composableBuilder(
    column: $table.counterpartyAccount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterpartyBank => $composableBuilder(
    column: $table.counterpartyBank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get feeKobo => $composableBuilder(
    column: $table.feeKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get narration => $composableBuilder(
    column: $table.narration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterpartyName => $composableBuilder(
    column: $table.counterpartyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterpartyAccount => $composableBuilder(
    column: $table.counterpartyAccount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterpartyBank => $composableBuilder(
    column: $table.counterpartyBank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnDirection, String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get feeKobo =>
      $composableBuilder(column: $table.feeKobo, builder: (column) => column);

  GeneratedColumn<String> get narration =>
      $composableBuilder(column: $table.narration, builder: (column) => column);

  GeneratedColumn<String> get counterpartyName => $composableBuilder(
    column: $table.counterpartyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get counterpartyAccount => $composableBuilder(
    column: $table.counterpartyAccount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get counterpartyBank => $composableBuilder(
    column: $table.counterpartyBank,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (TransactionRow, $$TransactionsTableReferences),
          TransactionRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<TxnDirection> direction = const Value.absent(),
                Value<TxnCategory> category = const Value.absent(),
                Value<TxnStatus> status = const Value.absent(),
                Value<int> amountKobo = const Value.absent(),
                Value<int> feeKobo = const Value.absent(),
                Value<String> narration = const Value.absent(),
                Value<String> counterpartyName = const Value.absent(),
                Value<String?> counterpartyAccount = const Value.absent(),
                Value<String?> counterpartyBank = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                accountId: accountId,
                reference: reference,
                direction: direction,
                category: category,
                status: status,
                amountKobo: amountKobo,
                feeKobo: feeKobo,
                narration: narration,
                counterpartyName: counterpartyName,
                counterpartyAccount: counterpartyAccount,
                counterpartyBank: counterpartyBank,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String reference,
                required TxnDirection direction,
                required TxnCategory category,
                required TxnStatus status,
                required int amountKobo,
                Value<int> feeKobo = const Value.absent(),
                Value<String> narration = const Value.absent(),
                required String counterpartyName,
                Value<String?> counterpartyAccount = const Value.absent(),
                Value<String?> counterpartyBank = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                accountId: accountId,
                reference: reference,
                direction: direction,
                category: category,
                status: status,
                amountKobo: amountKobo,
                feeKobo: feeKobo,
                narration: narration,
                counterpartyName: counterpartyName,
                counterpartyAccount: counterpartyAccount,
                counterpartyBank: counterpartyBank,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TransactionRow>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
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
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$TransactionsTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$TransactionsTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
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

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (TransactionRow, $$TransactionsTableReferences),
      TransactionRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$BeneficiariesTableCreateCompanionBuilder =
    BeneficiariesCompanion Function({
      required String bankCode,
      required String accountNumber,
      required String name,
      required DateTime lastUsedAt,
      Value<int> rowid,
    });
typedef $$BeneficiariesTableUpdateCompanionBuilder =
    BeneficiariesCompanion Function({
      Value<String> bankCode,
      Value<String> accountNumber,
      Value<String> name,
      Value<DateTime> lastUsedAt,
      Value<int> rowid,
    });

class $$BeneficiariesTableFilterComposer
    extends Composer<_$AppDatabase, $BeneficiariesTable> {
  $$BeneficiariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BeneficiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $BeneficiariesTable> {
  $$BeneficiariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BeneficiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BeneficiariesTable> {
  $$BeneficiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bankCode =>
      $composableBuilder(column: $table.bankCode, builder: (column) => column);

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );
}

class $$BeneficiariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BeneficiariesTable,
          BeneficiaryRow,
          $$BeneficiariesTableFilterComposer,
          $$BeneficiariesTableOrderingComposer,
          $$BeneficiariesTableAnnotationComposer,
          $$BeneficiariesTableCreateCompanionBuilder,
          $$BeneficiariesTableUpdateCompanionBuilder,
          (
            BeneficiaryRow,
            BaseReferences<_$AppDatabase, $BeneficiariesTable, BeneficiaryRow>,
          ),
          BeneficiaryRow,
          PrefetchHooks Function()
        > {
  $$BeneficiariesTableTableManager(_$AppDatabase db, $BeneficiariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BeneficiariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BeneficiariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BeneficiariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> bankCode = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BeneficiariesCompanion(
                bankCode: bankCode,
                accountNumber: accountNumber,
                name: name,
                lastUsedAt: lastUsedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bankCode,
                required String accountNumber,
                required String name,
                required DateTime lastUsedAt,
                Value<int> rowid = const Value.absent(),
              }) => BeneficiariesCompanion.insert(
                bankCode: bankCode,
                accountNumber: accountNumber,
                name: name,
                lastUsedAt: lastUsedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BeneficiariesTable, BeneficiaryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BeneficiariesTable,
                    BeneficiaryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BeneficiariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BeneficiariesTable,
      BeneficiaryRow,
      $$BeneficiariesTableFilterComposer,
      $$BeneficiariesTableOrderingComposer,
      $$BeneficiariesTableAnnotationComposer,
      $$BeneficiariesTableCreateCompanionBuilder,
      $$BeneficiariesTableUpdateCompanionBuilder,
      (
        BeneficiaryRow,
        BaseReferences<_$AppDatabase, $BeneficiariesTable, BeneficiaryRow>,
      ),
      BeneficiaryRow,
      PrefetchHooks Function()
    >;
typedef $$DemoMetaTableCreateCompanionBuilder = DemoMetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$DemoMetaTableUpdateCompanionBuilder = DemoMetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$DemoMetaTableFilterComposer
    extends Composer<_$AppDatabase, $DemoMetaTable> {
  $$DemoMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DemoMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $DemoMetaTable> {
  $$DemoMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DemoMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $DemoMetaTable> {
  $$DemoMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$DemoMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DemoMetaTable,
          DemoMetaRow,
          $$DemoMetaTableFilterComposer,
          $$DemoMetaTableOrderingComposer,
          $$DemoMetaTableAnnotationComposer,
          $$DemoMetaTableCreateCompanionBuilder,
          $$DemoMetaTableUpdateCompanionBuilder,
          (
            DemoMetaRow,
            BaseReferences<_$AppDatabase, $DemoMetaTable, DemoMetaRow>,
          ),
          DemoMetaRow,
          PrefetchHooks Function()
        > {
  $$DemoMetaTableTableManager(_$AppDatabase db, $DemoMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DemoMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DemoMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DemoMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => DemoMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => DemoMetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DemoMetaTable, DemoMetaRow>(table),
                  BaseReferences<_$AppDatabase, $DemoMetaTable, DemoMetaRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DemoMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DemoMetaTable,
      DemoMetaRow,
      $$DemoMetaTableFilterComposer,
      $$DemoMetaTableOrderingComposer,
      $$DemoMetaTableAnnotationComposer,
      $$DemoMetaTableCreateCompanionBuilder,
      $$DemoMetaTableUpdateCompanionBuilder,
      (DemoMetaRow, BaseReferences<_$AppDatabase, $DemoMetaTable, DemoMetaRow>),
      DemoMetaRow,
      PrefetchHooks Function()
    >;
typedef $$MortgagesTableCreateCompanionBuilder = MortgagesCompanion Function({
  required String id,
  required MortgageProduct product,
  required String propertyName,
  required String propertyLocation,
  required int principalKobo,
  required int tenorMonths,
  required DateTime firstDueDate,
  required int installmentsPaid,
  Value<int> rowid,
});
typedef $$MortgagesTableUpdateCompanionBuilder = MortgagesCompanion Function({
  Value<String> id,
  Value<MortgageProduct> product,
  Value<String> propertyName,
  Value<String> propertyLocation,
  Value<int> principalKobo,
  Value<int> tenorMonths,
  Value<DateTime> firstDueDate,
  Value<int> installmentsPaid,
  Value<int> rowid,
});

class $$MortgagesTableFilterComposer
    extends Composer<_$AppDatabase, $MortgagesTable> {
  $$MortgagesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<MortgageProduct, MortgageProduct, String>
  get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get propertyName => $composableBuilder(
    column: $table.propertyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get propertyLocation => $composableBuilder(
    column: $table.propertyLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get principalKobo => $composableBuilder(
    column: $table.principalKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tenorMonths => $composableBuilder(
    column: $table.tenorMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstDueDate => $composableBuilder(
    column: $table.firstDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentsPaid => $composableBuilder(
    column: $table.installmentsPaid,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MortgagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MortgagesTable> {
  $$MortgagesTableOrderingComposer({
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

  ColumnOrderings<String> get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertyName => $composableBuilder(
    column: $table.propertyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertyLocation => $composableBuilder(
    column: $table.propertyLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalKobo => $composableBuilder(
    column: $table.principalKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tenorMonths => $composableBuilder(
    column: $table.tenorMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstDueDate => $composableBuilder(
    column: $table.firstDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentsPaid => $composableBuilder(
    column: $table.installmentsPaid,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MortgagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MortgagesTable> {
  $$MortgagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MortgageProduct, String> get product =>
      $composableBuilder(column: $table.product, builder: (column) => column);

  GeneratedColumn<String> get propertyName => $composableBuilder(
    column: $table.propertyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get propertyLocation => $composableBuilder(
    column: $table.propertyLocation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get principalKobo => $composableBuilder(
    column: $table.principalKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tenorMonths => $composableBuilder(
    column: $table.tenorMonths,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firstDueDate => $composableBuilder(
    column: $table.firstDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentsPaid => $composableBuilder(
    column: $table.installmentsPaid,
    builder: (column) => column,
  );
}

class $$MortgagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MortgagesTable,
          MortgageRow,
          $$MortgagesTableFilterComposer,
          $$MortgagesTableOrderingComposer,
          $$MortgagesTableAnnotationComposer,
          $$MortgagesTableCreateCompanionBuilder,
          $$MortgagesTableUpdateCompanionBuilder,
          (
            MortgageRow,
            BaseReferences<_$AppDatabase, $MortgagesTable, MortgageRow>,
          ),
          MortgageRow,
          PrefetchHooks Function()
        > {
  $$MortgagesTableTableManager(_$AppDatabase db, $MortgagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MortgagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MortgagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MortgagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<MortgageProduct> product = const Value.absent(),
                Value<String> propertyName = const Value.absent(),
                Value<String> propertyLocation = const Value.absent(),
                Value<int> principalKobo = const Value.absent(),
                Value<int> tenorMonths = const Value.absent(),
                Value<DateTime> firstDueDate = const Value.absent(),
                Value<int> installmentsPaid = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MortgagesCompanion(
                id: id,
                product: product,
                propertyName: propertyName,
                propertyLocation: propertyLocation,
                principalKobo: principalKobo,
                tenorMonths: tenorMonths,
                firstDueDate: firstDueDate,
                installmentsPaid: installmentsPaid,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required MortgageProduct product,
                required String propertyName,
                required String propertyLocation,
                required int principalKobo,
                required int tenorMonths,
                required DateTime firstDueDate,
                required int installmentsPaid,
                Value<int> rowid = const Value.absent(),
              }) => MortgagesCompanion.insert(
                id: id,
                product: product,
                propertyName: propertyName,
                propertyLocation: propertyLocation,
                principalKobo: principalKobo,
                tenorMonths: tenorMonths,
                firstDueDate: firstDueDate,
                installmentsPaid: installmentsPaid,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MortgagesTable, MortgageRow>(table),
                  BaseReferences<_$AppDatabase, $MortgagesTable, MortgageRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MortgagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MortgagesTable,
      MortgageRow,
      $$MortgagesTableFilterComposer,
      $$MortgagesTableOrderingComposer,
      $$MortgagesTableAnnotationComposer,
      $$MortgagesTableCreateCompanionBuilder,
      $$MortgagesTableUpdateCompanionBuilder,
      (
        MortgageRow,
        BaseReferences<_$AppDatabase, $MortgagesTable, MortgageRow>,
      ),
      MortgageRow,
      PrefetchHooks Function()
    >;
typedef $$MortgageApplicationsTableCreateCompanionBuilder =
    MortgageApplicationsCompanion Function({
      required String id,
      required MortgageProduct product,
      required int amountKobo,
      required int tenorMonths,
      required String property,
      required int monthlyIncomeKobo,
      required DateTime submittedAt,
      Value<int> rowid,
    });
typedef $$MortgageApplicationsTableUpdateCompanionBuilder =
    MortgageApplicationsCompanion Function({
      Value<String> id,
      Value<MortgageProduct> product,
      Value<int> amountKobo,
      Value<int> tenorMonths,
      Value<String> property,
      Value<int> monthlyIncomeKobo,
      Value<DateTime> submittedAt,
      Value<int> rowid,
    });

class $$MortgageApplicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MortgageApplicationsTable> {
  $$MortgageApplicationsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<MortgageProduct, MortgageProduct, String>
  get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tenorMonths => $composableBuilder(
    column: $table.tenorMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get property => $composableBuilder(
    column: $table.property,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyIncomeKobo => $composableBuilder(
    column: $table.monthlyIncomeKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MortgageApplicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MortgageApplicationsTable> {
  $$MortgageApplicationsTableOrderingComposer({
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

  ColumnOrderings<String> get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tenorMonths => $composableBuilder(
    column: $table.tenorMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get property => $composableBuilder(
    column: $table.property,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyIncomeKobo => $composableBuilder(
    column: $table.monthlyIncomeKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MortgageApplicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MortgageApplicationsTable> {
  $$MortgageApplicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MortgageProduct, String> get product =>
      $composableBuilder(column: $table.product, builder: (column) => column);

  GeneratedColumn<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tenorMonths => $composableBuilder(
    column: $table.tenorMonths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get property =>
      $composableBuilder(column: $table.property, builder: (column) => column);

  GeneratedColumn<int> get monthlyIncomeKobo => $composableBuilder(
    column: $table.monthlyIncomeKobo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );
}

class $$MortgageApplicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MortgageApplicationsTable,
          MortgageApplicationRow,
          $$MortgageApplicationsTableFilterComposer,
          $$MortgageApplicationsTableOrderingComposer,
          $$MortgageApplicationsTableAnnotationComposer,
          $$MortgageApplicationsTableCreateCompanionBuilder,
          $$MortgageApplicationsTableUpdateCompanionBuilder,
          (
            MortgageApplicationRow,
            BaseReferences<
              _$AppDatabase,
              $MortgageApplicationsTable,
              MortgageApplicationRow
            >,
          ),
          MortgageApplicationRow,
          PrefetchHooks Function()
        > {
  $$MortgageApplicationsTableTableManager(
    _$AppDatabase db,
    $MortgageApplicationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MortgageApplicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MortgageApplicationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MortgageApplicationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<MortgageProduct> product = const Value.absent(),
                Value<int> amountKobo = const Value.absent(),
                Value<int> tenorMonths = const Value.absent(),
                Value<String> property = const Value.absent(),
                Value<int> monthlyIncomeKobo = const Value.absent(),
                Value<DateTime> submittedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MortgageApplicationsCompanion(
                id: id,
                product: product,
                amountKobo: amountKobo,
                tenorMonths: tenorMonths,
                property: property,
                monthlyIncomeKobo: monthlyIncomeKobo,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required MortgageProduct product,
                required int amountKobo,
                required int tenorMonths,
                required String property,
                required int monthlyIncomeKobo,
                required DateTime submittedAt,
                Value<int> rowid = const Value.absent(),
              }) => MortgageApplicationsCompanion.insert(
                id: id,
                product: product,
                amountKobo: amountKobo,
                tenorMonths: tenorMonths,
                property: property,
                monthlyIncomeKobo: monthlyIncomeKobo,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $MortgageApplicationsTable,
                    MortgageApplicationRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MortgageApplicationsTable,
                    MortgageApplicationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MortgageApplicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MortgageApplicationsTable,
      MortgageApplicationRow,
      $$MortgageApplicationsTableFilterComposer,
      $$MortgageApplicationsTableOrderingComposer,
      $$MortgageApplicationsTableAnnotationComposer,
      $$MortgageApplicationsTableCreateCompanionBuilder,
      $$MortgageApplicationsTableUpdateCompanionBuilder,
      (
        MortgageApplicationRow,
        BaseReferences<
          _$AppDatabase,
          $MortgageApplicationsTable,
          MortgageApplicationRow
        >,
      ),
      MortgageApplicationRow,
      PrefetchHooks Function()
    >;
typedef $$CustomerProfilesTableCreateCompanionBuilder =
    CustomerProfilesCompanion Function({
      required String accountId,
      required String phone,
      Value<String?> email,
      Value<DateTime?> dateOfBirth,
      Value<String?> address,
      Value<String?> bvnLast4,
      Value<String?> ninLast4,
      required DateTime memberSince,
      Value<int> rowid,
    });
typedef $$CustomerProfilesTableUpdateCompanionBuilder =
    CustomerProfilesCompanion Function({
      Value<String> accountId,
      Value<String> phone,
      Value<String?> email,
      Value<DateTime?> dateOfBirth,
      Value<String?> address,
      Value<String?> bvnLast4,
      Value<String?> ninLast4,
      Value<DateTime> memberSince,
      Value<int> rowid,
    });

final class $$CustomerProfilesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CustomerProfilesTable,
          CustomerProfileRow
        > {
  $$CustomerProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('customer_profiles__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CustomerProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomerProfilesTable> {
  $$CustomerProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bvnLast4 => $composableBuilder(
    column: $table.bvnLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ninLast4 => $composableBuilder(
    column: $table.ninLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get memberSince => $composableBuilder(
    column: $table.memberSince,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomerProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomerProfilesTable> {
  $$CustomerProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bvnLast4 => $composableBuilder(
    column: $table.bvnLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ninLast4 => $composableBuilder(
    column: $table.ninLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get memberSince => $composableBuilder(
    column: $table.memberSince,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomerProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomerProfilesTable> {
  $$CustomerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get bvnLast4 =>
      $composableBuilder(column: $table.bvnLast4, builder: (column) => column);

  GeneratedColumn<String> get ninLast4 =>
      $composableBuilder(column: $table.ninLast4, builder: (column) => column);

  GeneratedColumn<DateTime> get memberSince => $composableBuilder(
    column: $table.memberSince,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomerProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomerProfilesTable,
          CustomerProfileRow,
          $$CustomerProfilesTableFilterComposer,
          $$CustomerProfilesTableOrderingComposer,
          $$CustomerProfilesTableAnnotationComposer,
          $$CustomerProfilesTableCreateCompanionBuilder,
          $$CustomerProfilesTableUpdateCompanionBuilder,
          (CustomerProfileRow, $$CustomerProfilesTableReferences),
          CustomerProfileRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$CustomerProfilesTableTableManager(
    _$AppDatabase db,
    $CustomerProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomerProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> accountId = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> bvnLast4 = const Value.absent(),
                Value<String?> ninLast4 = const Value.absent(),
                Value<DateTime> memberSince = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomerProfilesCompanion(
                accountId: accountId,
                phone: phone,
                email: email,
                dateOfBirth: dateOfBirth,
                address: address,
                bvnLast4: bvnLast4,
                ninLast4: ninLast4,
                memberSince: memberSince,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String accountId,
                required String phone,
                Value<String?> email = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> bvnLast4 = const Value.absent(),
                Value<String?> ninLast4 = const Value.absent(),
                required DateTime memberSince,
                Value<int> rowid = const Value.absent(),
              }) => CustomerProfilesCompanion.insert(
                accountId: accountId,
                phone: phone,
                email: email,
                dateOfBirth: dateOfBirth,
                address: address,
                bvnLast4: bvnLast4,
                ninLast4: ninLast4,
                memberSince: memberSince,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomerProfilesTable, CustomerProfileRow>(
                    table,
                  ),
                  $$CustomerProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
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
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$CustomerProfilesTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$CustomerProfilesTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
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

typedef $$CustomerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomerProfilesTable,
      CustomerProfileRow,
      $$CustomerProfilesTableFilterComposer,
      $$CustomerProfilesTableOrderingComposer,
      $$CustomerProfilesTableAnnotationComposer,
      $$CustomerProfilesTableCreateCompanionBuilder,
      $$CustomerProfilesTableUpdateCompanionBuilder,
      (CustomerProfileRow, $$CustomerProfilesTableReferences),
      CustomerProfileRow,
      PrefetchHooks Function({bool accountId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BeneficiariesTableTableManager get beneficiaries =>
      $$BeneficiariesTableTableManager(_db, _db.beneficiaries);
  $$DemoMetaTableTableManager get demoMeta =>
      $$DemoMetaTableTableManager(_db, _db.demoMeta);
  $$MortgagesTableTableManager get mortgages =>
      $$MortgagesTableTableManager(_db, _db.mortgages);
  $$MortgageApplicationsTableTableManager get mortgageApplications =>
      $$MortgageApplicationsTableTableManager(_db, _db.mortgageApplications);
  $$CustomerProfilesTableTableManager get customerProfiles =>
      $$CustomerProfilesTableTableManager(_db, _db.customerProfiles);
}
