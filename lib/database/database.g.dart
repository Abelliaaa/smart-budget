// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionUidMeta =
      const VerificationMeta('transactionUid');
  @override
  late final GeneratedColumn<String> transactionUid = GeneratedColumn<String>(
      'transaction_uid', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _tanggalMeta =
      const VerificationMeta('tanggal');
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
      'tanggal', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kategoriMeta =
      const VerificationMeta('kategori');
  @override
  late final GeneratedColumn<String> kategori = GeneratedColumn<String>(
      'kategori', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isIncomeMeta =
      const VerificationMeta('isIncome');
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
      'is_income', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_income" IN (0, 1))'));
  static const VerificationMeta _catatanMeta =
      const VerificationMeta('catatan');
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
      'catatan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nominalMeta =
      const VerificationMeta('nominal');
  @override
  late final GeneratedColumn<int> nominal = GeneratedColumn<int>(
      'nominal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _buktiTransaksiMeta =
      const VerificationMeta('buktiTransaksi');
  @override
  late final GeneratedColumn<String> buktiTransaksi = GeneratedColumn<String>(
      'bukti_transaksi', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _supabaseUserIdMeta =
      const VerificationMeta('supabaseUserId');
  @override
  late final GeneratedColumn<String> supabaseUserId = GeneratedColumn<String>(
      'supabase_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isUploadedMeta =
      const VerificationMeta('isUploaded');
  @override
  late final GeneratedColumn<bool> isUploaded = GeneratedColumn<bool>(
      'is_uploaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_uploaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transactionUid,
        tanggal,
        kategori,
        isIncome,
        catatan,
        nominal,
        buktiTransaksi,
        supabaseUserId,
        isUploaded,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_uid')) {
      context.handle(
          _transactionUidMeta,
          transactionUid.isAcceptableOrUnknown(
              data['transaction_uid']!, _transactionUidMeta));
    }
    if (data.containsKey('tanggal')) {
      context.handle(_tanggalMeta,
          tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta));
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('kategori')) {
      context.handle(_kategoriMeta,
          kategori.isAcceptableOrUnknown(data['kategori']!, _kategoriMeta));
    } else if (isInserting) {
      context.missing(_kategoriMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(_isIncomeMeta,
          isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta));
    } else if (isInserting) {
      context.missing(_isIncomeMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(_catatanMeta,
          catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta));
    }
    if (data.containsKey('nominal')) {
      context.handle(_nominalMeta,
          nominal.isAcceptableOrUnknown(data['nominal']!, _nominalMeta));
    } else if (isInserting) {
      context.missing(_nominalMeta);
    }
    if (data.containsKey('bukti_transaksi')) {
      context.handle(
          _buktiTransaksiMeta,
          buktiTransaksi.isAcceptableOrUnknown(
              data['bukti_transaksi']!, _buktiTransaksiMeta));
    }
    if (data.containsKey('supabase_user_id')) {
      context.handle(
          _supabaseUserIdMeta,
          supabaseUserId.isAcceptableOrUnknown(
              data['supabase_user_id']!, _supabaseUserIdMeta));
    } else if (isInserting) {
      context.missing(_supabaseUserIdMeta);
    }
    if (data.containsKey('is_uploaded')) {
      context.handle(
          _isUploadedMeta,
          isUploaded.isAcceptableOrUnknown(
              data['is_uploaded']!, _isUploadedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_uid']),
      tanggal: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}tanggal'])!,
      kategori: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kategori'])!,
      isIncome: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_income'])!,
      catatan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}catatan']),
      nominal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nominal'])!,
      buktiTransaksi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bukti_transaksi']),
      supabaseUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}supabase_user_id'])!,
      isUploaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_uploaded'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final String? transactionUid;
  final DateTime tanggal;
  final String kategori;
  final bool isIncome;
  final String? catatan;
  final int nominal;
  final String? buktiTransaksi;
  final String supabaseUserId;
  final bool isUploaded;
  final DateTime updatedAt;
  const Transaction(
      {required this.id,
      this.transactionUid,
      required this.tanggal,
      required this.kategori,
      required this.isIncome,
      this.catatan,
      required this.nominal,
      this.buktiTransaksi,
      required this.supabaseUserId,
      required this.isUploaded,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || transactionUid != null) {
      map['transaction_uid'] = Variable<String>(transactionUid);
    }
    map['tanggal'] = Variable<DateTime>(tanggal);
    map['kategori'] = Variable<String>(kategori);
    map['is_income'] = Variable<bool>(isIncome);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['nominal'] = Variable<int>(nominal);
    if (!nullToAbsent || buktiTransaksi != null) {
      map['bukti_transaksi'] = Variable<String>(buktiTransaksi);
    }
    map['supabase_user_id'] = Variable<String>(supabaseUserId);
    map['is_uploaded'] = Variable<bool>(isUploaded);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      transactionUid: transactionUid == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionUid),
      tanggal: Value(tanggal),
      kategori: Value(kategori),
      isIncome: Value(isIncome),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      nominal: Value(nominal),
      buktiTransaksi: buktiTransaksi == null && nullToAbsent
          ? const Value.absent()
          : Value(buktiTransaksi),
      supabaseUserId: Value(supabaseUserId),
      isUploaded: Value(isUploaded),
      updatedAt: Value(updatedAt),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      transactionUid: serializer.fromJson<String?>(json['transactionUid']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      kategori: serializer.fromJson<String>(json['kategori']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      nominal: serializer.fromJson<int>(json['nominal']),
      buktiTransaksi: serializer.fromJson<String?>(json['buktiTransaksi']),
      supabaseUserId: serializer.fromJson<String>(json['supabaseUserId']),
      isUploaded: serializer.fromJson<bool>(json['isUploaded']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionUid': serializer.toJson<String?>(transactionUid),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'kategori': serializer.toJson<String>(kategori),
      'isIncome': serializer.toJson<bool>(isIncome),
      'catatan': serializer.toJson<String?>(catatan),
      'nominal': serializer.toJson<int>(nominal),
      'buktiTransaksi': serializer.toJson<String?>(buktiTransaksi),
      'supabaseUserId': serializer.toJson<String>(supabaseUserId),
      'isUploaded': serializer.toJson<bool>(isUploaded),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Transaction copyWith(
          {int? id,
          Value<String?> transactionUid = const Value.absent(),
          DateTime? tanggal,
          String? kategori,
          bool? isIncome,
          Value<String?> catatan = const Value.absent(),
          int? nominal,
          Value<String?> buktiTransaksi = const Value.absent(),
          String? supabaseUserId,
          bool? isUploaded,
          DateTime? updatedAt}) =>
      Transaction(
        id: id ?? this.id,
        transactionUid:
            transactionUid.present ? transactionUid.value : this.transactionUid,
        tanggal: tanggal ?? this.tanggal,
        kategori: kategori ?? this.kategori,
        isIncome: isIncome ?? this.isIncome,
        catatan: catatan.present ? catatan.value : this.catatan,
        nominal: nominal ?? this.nominal,
        buktiTransaksi:
            buktiTransaksi.present ? buktiTransaksi.value : this.buktiTransaksi,
        supabaseUserId: supabaseUserId ?? this.supabaseUserId,
        isUploaded: isUploaded ?? this.isUploaded,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      transactionUid: data.transactionUid.present
          ? data.transactionUid.value
          : this.transactionUid,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      kategori: data.kategori.present ? data.kategori.value : this.kategori,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      nominal: data.nominal.present ? data.nominal.value : this.nominal,
      buktiTransaksi: data.buktiTransaksi.present
          ? data.buktiTransaksi.value
          : this.buktiTransaksi,
      supabaseUserId: data.supabaseUserId.present
          ? data.supabaseUserId.value
          : this.supabaseUserId,
      isUploaded:
          data.isUploaded.present ? data.isUploaded.value : this.isUploaded,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('transactionUid: $transactionUid, ')
          ..write('tanggal: $tanggal, ')
          ..write('kategori: $kategori, ')
          ..write('isIncome: $isIncome, ')
          ..write('catatan: $catatan, ')
          ..write('nominal: $nominal, ')
          ..write('buktiTransaksi: $buktiTransaksi, ')
          ..write('supabaseUserId: $supabaseUserId, ')
          ..write('isUploaded: $isUploaded, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      transactionUid,
      tanggal,
      kategori,
      isIncome,
      catatan,
      nominal,
      buktiTransaksi,
      supabaseUserId,
      isUploaded,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.transactionUid == this.transactionUid &&
          other.tanggal == this.tanggal &&
          other.kategori == this.kategori &&
          other.isIncome == this.isIncome &&
          other.catatan == this.catatan &&
          other.nominal == this.nominal &&
          other.buktiTransaksi == this.buktiTransaksi &&
          other.supabaseUserId == this.supabaseUserId &&
          other.isUploaded == this.isUploaded &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String?> transactionUid;
  final Value<DateTime> tanggal;
  final Value<String> kategori;
  final Value<bool> isIncome;
  final Value<String?> catatan;
  final Value<int> nominal;
  final Value<String?> buktiTransaksi;
  final Value<String> supabaseUserId;
  final Value<bool> isUploaded;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.transactionUid = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.kategori = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.catatan = const Value.absent(),
    this.nominal = const Value.absent(),
    this.buktiTransaksi = const Value.absent(),
    this.supabaseUserId = const Value.absent(),
    this.isUploaded = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.transactionUid = const Value.absent(),
    required DateTime tanggal,
    required String kategori,
    required bool isIncome,
    this.catatan = const Value.absent(),
    required int nominal,
    this.buktiTransaksi = const Value.absent(),
    required String supabaseUserId,
    this.isUploaded = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : tanggal = Value(tanggal),
        kategori = Value(kategori),
        isIncome = Value(isIncome),
        nominal = Value(nominal),
        supabaseUserId = Value(supabaseUserId);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? transactionUid,
    Expression<DateTime>? tanggal,
    Expression<String>? kategori,
    Expression<bool>? isIncome,
    Expression<String>? catatan,
    Expression<int>? nominal,
    Expression<String>? buktiTransaksi,
    Expression<String>? supabaseUserId,
    Expression<bool>? isUploaded,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionUid != null) 'transaction_uid': transactionUid,
      if (tanggal != null) 'tanggal': tanggal,
      if (kategori != null) 'kategori': kategori,
      if (isIncome != null) 'is_income': isIncome,
      if (catatan != null) 'catatan': catatan,
      if (nominal != null) 'nominal': nominal,
      if (buktiTransaksi != null) 'bukti_transaksi': buktiTransaksi,
      if (supabaseUserId != null) 'supabase_user_id': supabaseUserId,
      if (isUploaded != null) 'is_uploaded': isUploaded,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? transactionUid,
      Value<DateTime>? tanggal,
      Value<String>? kategori,
      Value<bool>? isIncome,
      Value<String?>? catatan,
      Value<int>? nominal,
      Value<String?>? buktiTransaksi,
      Value<String>? supabaseUserId,
      Value<bool>? isUploaded,
      Value<DateTime>? updatedAt}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      transactionUid: transactionUid ?? this.transactionUid,
      tanggal: tanggal ?? this.tanggal,
      kategori: kategori ?? this.kategori,
      isIncome: isIncome ?? this.isIncome,
      catatan: catatan ?? this.catatan,
      nominal: nominal ?? this.nominal,
      buktiTransaksi: buktiTransaksi ?? this.buktiTransaksi,
      supabaseUserId: supabaseUserId ?? this.supabaseUserId,
      isUploaded: isUploaded ?? this.isUploaded,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionUid.present) {
      map['transaction_uid'] = Variable<String>(transactionUid.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (kategori.present) {
      map['kategori'] = Variable<String>(kategori.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (nominal.present) {
      map['nominal'] = Variable<int>(nominal.value);
    }
    if (buktiTransaksi.present) {
      map['bukti_transaksi'] = Variable<String>(buktiTransaksi.value);
    }
    if (supabaseUserId.present) {
      map['supabase_user_id'] = Variable<String>(supabaseUserId.value);
    }
    if (isUploaded.present) {
      map['is_uploaded'] = Variable<bool>(isUploaded.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('transactionUid: $transactionUid, ')
          ..write('tanggal: $tanggal, ')
          ..write('kategori: $kategori, ')
          ..write('isIncome: $isIncome, ')
          ..write('catatan: $catatan, ')
          ..write('nominal: $nominal, ')
          ..write('buktiTransaksi: $buktiTransaksi, ')
          ..write('supabaseUserId: $supabaseUserId, ')
          ..write('isUploaded: $isUploaded, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final TransactionDao transactionDao =
      TransactionDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [transactions];
}

typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<String?> transactionUid,
  required DateTime tanggal,
  required String kategori,
  required bool isIncome,
  Value<String?> catatan,
  required int nominal,
  Value<String?> buktiTransaksi,
  required String supabaseUserId,
  Value<bool> isUploaded,
  Value<DateTime> updatedAt,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<String?> transactionUid,
  Value<DateTime> tanggal,
  Value<String> kategori,
  Value<bool> isIncome,
  Value<String?> catatan,
  Value<int> nominal,
  Value<String?> buktiTransaksi,
  Value<String> supabaseUserId,
  Value<bool> isUploaded,
  Value<DateTime> updatedAt,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionUid => $composableBuilder(
      column: $table.transactionUid,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
      column: $table.tanggal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kategori => $composableBuilder(
      column: $table.kategori, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get catatan => $composableBuilder(
      column: $table.catatan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nominal => $composableBuilder(
      column: $table.nominal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buktiTransaksi => $composableBuilder(
      column: $table.buktiTransaksi,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supabaseUserId => $composableBuilder(
      column: $table.supabaseUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUploaded => $composableBuilder(
      column: $table.isUploaded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
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
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionUid => $composableBuilder(
      column: $table.transactionUid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
      column: $table.tanggal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kategori => $composableBuilder(
      column: $table.kategori, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get catatan => $composableBuilder(
      column: $table.catatan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nominal => $composableBuilder(
      column: $table.nominal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buktiTransaksi => $composableBuilder(
      column: $table.buktiTransaksi,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supabaseUserId => $composableBuilder(
      column: $table.supabaseUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUploaded => $composableBuilder(
      column: $table.isUploaded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionUid => $composableBuilder(
      column: $table.transactionUid, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get kategori =>
      $composableBuilder(column: $table.kategori, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<int> get nominal =>
      $composableBuilder(column: $table.nominal, builder: (column) => column);

  GeneratedColumn<String> get buktiTransaksi => $composableBuilder(
      column: $table.buktiTransaksi, builder: (column) => column);

  GeneratedColumn<String> get supabaseUserId => $composableBuilder(
      column: $table.supabaseUserId, builder: (column) => column);

  GeneratedColumn<bool> get isUploaded => $composableBuilder(
      column: $table.isUploaded, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> transactionUid = const Value.absent(),
            Value<DateTime> tanggal = const Value.absent(),
            Value<String> kategori = const Value.absent(),
            Value<bool> isIncome = const Value.absent(),
            Value<String?> catatan = const Value.absent(),
            Value<int> nominal = const Value.absent(),
            Value<String?> buktiTransaksi = const Value.absent(),
            Value<String> supabaseUserId = const Value.absent(),
            Value<bool> isUploaded = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            transactionUid: transactionUid,
            tanggal: tanggal,
            kategori: kategori,
            isIncome: isIncome,
            catatan: catatan,
            nominal: nominal,
            buktiTransaksi: buktiTransaksi,
            supabaseUserId: supabaseUserId,
            isUploaded: isUploaded,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> transactionUid = const Value.absent(),
            required DateTime tanggal,
            required String kategori,
            required bool isIncome,
            Value<String?> catatan = const Value.absent(),
            required int nominal,
            Value<String?> buktiTransaksi = const Value.absent(),
            required String supabaseUserId,
            Value<bool> isUploaded = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            transactionUid: transactionUid,
            tanggal: tanggal,
            kategori: kategori,
            isIncome: isIncome,
            catatan: catatan,
            nominal: nominal,
            buktiTransaksi: buktiTransaksi,
            supabaseUserId: supabaseUserId,
            isUploaded: isUploaded,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
}
