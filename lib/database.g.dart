// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TBLAccountGroupDao? _tblAccountGroupDaoInstance;

  TBLAccountDao? _tblAccountDaoInstance;

  TBLCategoryDao? _tblCategoryDaoInstance;

  TBLDailyDetailDao? _tblDailyDetailDaoInstance;

  TBLDailyDao? _tblDailyDaoInstance;

  TBLMonthlySummaryDao? _tblMonthlySummaryDaoInstance;

  TBLAccountSummaryDao? _tblAccountSummaryDaoInstance;

  TBLWeeklyDao? _tblWeeklyDaoInstance;

  TBLDailyForWeekDao? _tblDailyForWeekDaoInstance;

  TBLWeeklySummaryDao? _tblWeeklySummaryDaoInstance;

  TBLProfileDao? _tblProfileDaoInstance;

  TBLStatusDao? _tblStatusDaoInstance;

  TBLExchangeDao? _tblExchangeDaoInstance;

  TBLGoldDao? _tblGoldDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLAccountGroup` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `total` TEXT NOT NULL, `isUpload` TEXT NOT NULL, `isActive` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLAccount` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `amount` TEXT NOT NULL, `subAmount` TEXT NOT NULL, `accountGroupId` TEXT NOT NULL, `note` TEXT NOT NULL, `isUpload` TEXT NOT NULL, `isActive` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLCategory` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `type` TEXT NOT NULL, `color` TEXT NOT NULL, `monthYear` TEXT NOT NULL, `isUpload` TEXT NOT NULL, `isActive` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBL_DailyDetail` (`id` TEXT NOT NULL, `date` TEXT NOT NULL, `monthYear` TEXT NOT NULL, `dailyId` TEXT NOT NULL, `accountName` TEXT NOT NULL, `categoryName` TEXT NOT NULL, `toAccountName` TEXT NOT NULL, `accountId` TEXT NOT NULL, `categoryId` TEXT NOT NULL, `toAccountId` TEXT NOT NULL, `amount` TEXT NOT NULL, `note` TEXT NOT NULL, `other` TEXT NOT NULL, `type` TEXT NOT NULL, `bookmark` TEXT NOT NULL, `image` TEXT NOT NULL, `isUpload` TEXT NOT NULL, `isActive` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBL_Daily` (`id` TEXT NOT NULL, `monthlySummaryID` TEXT NOT NULL, `date` TEXT NOT NULL, `monthYear` TEXT NOT NULL, `incomeAmount` TEXT NOT NULL, `expenseAmount` TEXT NOT NULL, `totalAmount` TEXT NOT NULL, `isUpload` TEXT NOT NULL, `isActive` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLMonthlySummary` (`id` TEXT NOT NULL, `monthYear` TEXT NOT NULL, `year` TEXT NOT NULL, `incomeAmount` TEXT NOT NULL, `expenseAmount` TEXT NOT NULL, `total` TEXT NOT NULL, `isUpload` TEXT NOT NULL, `isActive` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBL_Weekly` (`id` TEXT NOT NULL, `weekly` TEXT NOT NULL, `monthYear` TEXT NOT NULL, `income` TEXT NOT NULL, `expense` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBL_DailyForWeek` (`id` TEXT NOT NULL, `day` TEXT NOT NULL, `weeklyId` TEXT NOT NULL, `income` TEXT NOT NULL, `expense` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLAccountSummary` (`id` TEXT NOT NULL, `account` TEXT NOT NULL, `liabilities` TEXT NOT NULL, `total` TEXT NOT NULL, `isActive` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLWeeklySummary` (`id` TEXT NOT NULL, `income` TEXT NOT NULL, `expense` TEXT NOT NULL, `total` TEXT NOT NULL, `monthYear` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLProfile` (`id` TEXT NOT NULL, `full_name` TEXT NOT NULL, `user_name` TEXT NOT NULL, `password` TEXT NOT NULL, `email_address` TEXT NOT NULL, `phone_no` TEXT NOT NULL, `image` TEXT NOT NULL, `dob` TEXT NOT NULL, `gender` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLStatus` (`id` TEXT NOT NULL, `categoryName` TEXT NOT NULL, `type` TEXT NOT NULL, `amount` TEXT NOT NULL, `percent` TEXT NOT NULL, `color` TEXT NOT NULL, `monthYear` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLExchange` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `price` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `updatedBy` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TBLGold` (`id` TEXT NOT NULL, `local_price` TEXT NOT NULL, `date` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TBLAccountGroupDao get tblAccountGroupDao {
    return _tblAccountGroupDaoInstance ??=
        _$TBLAccountGroupDao(database, changeListener);
  }

  @override
  TBLAccountDao get tblAccountDao {
    return _tblAccountDaoInstance ??= _$TBLAccountDao(database, changeListener);
  }

  @override
  TBLCategoryDao get tblCategoryDao {
    return _tblCategoryDaoInstance ??=
        _$TBLCategoryDao(database, changeListener);
  }

  @override
  TBLDailyDetailDao get tblDailyDetailDao {
    return _tblDailyDetailDaoInstance ??=
        _$TBLDailyDetailDao(database, changeListener);
  }

  @override
  TBLDailyDao get tblDailyDao {
    return _tblDailyDaoInstance ??= _$TBLDailyDao(database, changeListener);
  }

  @override
  TBLMonthlySummaryDao get tblMonthlySummaryDao {
    return _tblMonthlySummaryDaoInstance ??=
        _$TBLMonthlySummaryDao(database, changeListener);
  }

  @override
  TBLAccountSummaryDao get tblAccountSummaryDao {
    return _tblAccountSummaryDaoInstance ??=
        _$TBLAccountSummaryDao(database, changeListener);
  }

  @override
  TBLWeeklyDao get tblWeeklyDao {
    return _tblWeeklyDaoInstance ??= _$TBLWeeklyDao(database, changeListener);
  }

  @override
  TBLDailyForWeekDao get tblDailyForWeekDao {
    return _tblDailyForWeekDaoInstance ??=
        _$TBLDailyForWeekDao(database, changeListener);
  }

  @override
  TBLWeeklySummaryDao get tblWeeklySummaryDao {
    return _tblWeeklySummaryDaoInstance ??=
        _$TBLWeeklySummaryDao(database, changeListener);
  }

  @override
  TBLProfileDao get tblProfileDao {
    return _tblProfileDaoInstance ??= _$TBLProfileDao(database, changeListener);
  }

  @override
  TBLStatusDao get tblStatusDao {
    return _tblStatusDaoInstance ??= _$TBLStatusDao(database, changeListener);
  }

  @override
  TBLExchangeDao get tblExchangeDao {
    return _tblExchangeDaoInstance ??=
        _$TBLExchangeDao(database, changeListener);
  }

  @override
  TBLGoldDao get tblGoldDao {
    return _tblGoldDaoInstance ??= _$TBLGoldDao(database, changeListener);
  }
}

class _$TBLAccountGroupDao extends TBLAccountGroupDao {
  _$TBLAccountGroupDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLAccountGroupInsertionAdapter = InsertionAdapter(
            database,
            'TBLAccountGroup',
            (TBLAccountGroup item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'total': item.total,
                  'isUpload': item.isUpload,
                  'isActive': item.isActive,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLAccountGroup> _tBLAccountGroupInsertionAdapter;

  @override
  Future<List<TBLAccountGroup>> selectAll(
      String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLAccountGroup WHERE createdBy=?1 and isActive=?2',
        mapper: (Map<String, Object?> row) => TBLAccountGroup(
            row['id'] as String,
            row['name'] as String,
            row['total'] as String,
            row['isUpload'] as String,
            row['isActive'] as String,
            row['createdAt'] as String,
            row['createdBy'] as String,
            row['updatedAt'] as String,
            row['updatedBy'] as String),
        arguments: [createdBy, isActive]);
  }

  @override
  Future<List<TBLAccountGroup>> selectNoUpload(String createdBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLAccountGroup WHERE createdBy=?1',
        mapper: (Map<String, Object?> row) => TBLAccountGroup(
            row['id'] as String,
            row['name'] as String,
            row['total'] as String,
            row['isUpload'] as String,
            row['isActive'] as String,
            row['createdAt'] as String,
            row['createdBy'] as String,
            row['updatedAt'] as String,
            row['updatedBy'] as String),
        arguments: [createdBy]);
  }

  @override
  Future<List<TBLAccountGroup>> selectAccountGroupByName(
      String id, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLAccountGroup WHERE id=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBLAccountGroup(row['id'] as String, row['name'] as String, row['total'] as String, row['isUpload'] as String, row['isActive'] as String, row['createdAt'] as String, row['createdBy'] as String, row['updatedAt'] as String, row['updatedBy'] as String),
        arguments: [id, createdBy, isActive]);
  }

  @override
  Future<void> deleteByAccountGroupId(
      String id, String createdBy, String isActive) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE TBLAccountGroup set isActive=?3 WHERE id=?1 and createdBy=?2',
        arguments: [id, createdBy, isActive]);
  }

  @override
  Future<void> deleteByAccountGroupIdUploaded(
      String id, String createdBy, String isUpload) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE TBLAccountGroup set isUpload=?3 WHERE id=?1 and createdBy=?2',
        arguments: [id, createdBy, isUpload]);
  }

  @override
  Future<void> insert(TBLAccountGroup categoryGroup) async {
    await _tBLAccountGroupInsertionAdapter.insert(
        categoryGroup, OnConflictStrategy.replace);
  }
}

class _$TBLAccountDao extends TBLAccountDao {
  _$TBLAccountDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLAccountInsertionAdapter = InsertionAdapter(
            database,
            'TBLAccount',
            (TBLAccount item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'amount': item.amount,
                  'subAmount': item.subAmount,
                  'accountGroupId': item.accountGroupId,
                  'note': item.note,
                  'isUpload': item.isUpload,
                  'isActive': item.isActive,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLAccount> _tBLAccountInsertionAdapter;

  @override
  Future<List<TBLAccount>> selectNoUpload(
      String createdBy, String isUpload) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLAccount WHERE createdBy=?1 and isUpload=?2',
        mapper: (Map<String, Object?> row) => TBLAccount(
            row['id'] as String,
            row['name'] as String,
            row['amount'] as String,
            row['subAmount'] as String,
            row['accountGroupId'] as String,
            row['note'] as String,
            row['isUpload'] as String,
            row['isActive'] as String,
            row['createdAt'] as String,
            row['createdBy'] as String,
            row['updatedAt'] as String,
            row['updatedBy'] as String),
        arguments: [createdBy, isUpload]);
  }

  @override
  Future<List<TBLAccount>> selectAccountByName(
      String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLAccount WHERE createdBy=?1 and isActive=?2',
        mapper: (Map<String, Object?> row) => TBLAccount(
            row['id'] as String,
            row['name'] as String,
            row['amount'] as String,
            row['subAmount'] as String,
            row['accountGroupId'] as String,
            row['note'] as String,
            row['isUpload'] as String,
            row['isActive'] as String,
            row['createdAt'] as String,
            row['createdBy'] as String,
            row['updatedAt'] as String,
            row['updatedBy'] as String),
        arguments: [createdBy, isActive]);
  }

  @override
  Future<List<TBLAccount>> selectAccountById(String id, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLAccount WHERE id=?1 and isActive=?2',
        mapper: (Map<String, Object?> row) => TBLAccount(
            row['id'] as String,
            row['name'] as String,
            row['amount'] as String,
            row['subAmount'] as String,
            row['accountGroupId'] as String,
            row['note'] as String,
            row['isUpload'] as String,
            row['isActive'] as String,
            row['createdAt'] as String,
            row['createdBy'] as String,
            row['updatedAt'] as String,
            row['updatedBy'] as String),
        arguments: [id, isActive]);
  }

  @override
  Future<List<TBLAccount>> selectAccountByGroupId(
      String accountGroupId, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLAccount WHERE accountGroupId=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBLAccount(row['id'] as String, row['name'] as String, row['amount'] as String, row['subAmount'] as String, row['accountGroupId'] as String, row['note'] as String, row['isUpload'] as String, row['isActive'] as String, row['createdAt'] as String, row['createdBy'] as String, row['updatedAt'] as String, row['updatedBy'] as String),
        arguments: [accountGroupId, createdBy, isActive]);
  }

  @override
  Future<void> deleteByAccountId(
      String id, String createdBy, String isActive) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE TBLAccount set isActive=?3 where id=?1 and createdBy=?2',
        arguments: [id, createdBy, isActive]);
  }

  @override
  Future<void> deleteByAccountIdUploaded(
      String id, String createdBy, String isUpload) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE TBLAccount set isUpload=?3 where id=?1 and createdBy=?2',
        arguments: [id, createdBy, isUpload]);
  }

  @override
  Future<void> updateAccount(String id, String isUpload) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE TBLAccount set isUpload=?2 where id=?1',
        arguments: [id, isUpload]);
  }

  @override
  Future<List<TBLAccount>> selectAll(String isActive, String createdBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLAccount WHERE isActive=?1 and createdBy=?2',
        mapper: (Map<String, Object?> row) => TBLAccount(
            row['id'] as String,
            row['name'] as String,
            row['amount'] as String,
            row['subAmount'] as String,
            row['accountGroupId'] as String,
            row['note'] as String,
            row['isUpload'] as String,
            row['isActive'] as String,
            row['createdAt'] as String,
            row['createdBy'] as String,
            row['updatedAt'] as String,
            row['updatedBy'] as String),
        arguments: [isActive, createdBy]);
  }

  @override
  Future<void> insert(TBLAccount categoryGroup) async {
    await _tBLAccountInsertionAdapter.insert(
        categoryGroup, OnConflictStrategy.replace);
  }
}

class _$TBLCategoryDao extends TBLCategoryDao {
  _$TBLCategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLCategoryInsertionAdapter = InsertionAdapter(
            database,
            'TBLCategory',
            (TBLCategory item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'type': item.type,
                  'color': item.color,
                  'monthYear': item.monthYear,
                  'isUpload': item.isUpload,
                  'isActive': item.isActive,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'createdBy': item.createdBy,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLCategory> _tBLCategoryInsertionAdapter;

  @override
  Future<List<TBLCategory>> getAllCategory(
      String type, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLCategory WHERE type=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBLCategory(id: row['id'] as String, name: row['name'] as String, type: row['type'] as String, color: row['color'] as String, monthYear: row['monthYear'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, updatedAt: row['updatedAt'] as String, createdBy: row['createdBy'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [type, createdBy, isActive]);
  }

  @override
  Future<List<TBLCategory>> selectByCategoryId(
      String id, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLCategory WHERE id=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBLCategory(id: row['id'] as String, name: row['name'] as String, type: row['type'] as String, color: row['color'] as String, monthYear: row['monthYear'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, updatedAt: row['updatedAt'] as String, createdBy: row['createdBy'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [id, createdBy, isActive]);
  }

  @override
  Future<void> deleteCategoryId(
      String id, String createdBy, String isActive) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE TBLCategory set isActive=?3 WHERE id=?1 and createdBy=?2',
        arguments: [id, createdBy, isActive]);
  }

  @override
  Future<void> deleteCategoryIdUploaded(
      String id, String createdBy, String isUpload) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE TBLCategory set isUpload=?3 WHERE id=?1 and createdBy=?2',
        arguments: [id, createdBy, isUpload]);
  }

  @override
  Future<List<TBLCategory>> selectCategoryByCreatedBy(
      String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLCategory WHERE createdBy=?1 and isActive=?2',
        mapper: (Map<String, Object?> row) => TBLCategory(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            color: row['color'] as String,
            monthYear: row['monthYear'] as String,
            isUpload: row['isUpload'] as String,
            isActive: row['isActive'] as String,
            createdAt: row['createdAt'] as String,
            updatedAt: row['updatedAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [createdBy, isActive]);
  }

  @override
  Future<List<TBLCategory>> selectNoUpload(
      String createdBy, String isUpload) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLCategory WHERE createdBy=?1 and isUpload=?2',
        mapper: (Map<String, Object?> row) => TBLCategory(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            color: row['color'] as String,
            monthYear: row['monthYear'] as String,
            isUpload: row['isUpload'] as String,
            isActive: row['isActive'] as String,
            createdAt: row['createdAt'] as String,
            updatedAt: row['updatedAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [createdBy, isUpload]);
  }

  @override
  Future<List<TBLCategory>> selectAll() async {
    return _queryAdapter.queryList('SELECT * FROM TBLCategory',
        mapper: (Map<String, Object?> row) => TBLCategory(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            color: row['color'] as String,
            monthYear: row['monthYear'] as String,
            isUpload: row['isUpload'] as String,
            isActive: row['isActive'] as String,
            createdAt: row['createdAt'] as String,
            updatedAt: row['updatedAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedBy: row['updatedBy'] as String));
  }

  @override
  Future<void> insert(TBLCategory category) async {
    await _tBLCategoryInsertionAdapter.insert(
        category, OnConflictStrategy.replace);
  }
}

class _$TBLDailyDetailDao extends TBLDailyDetailDao {
  _$TBLDailyDetailDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBL_DailyDetailInsertionAdapter = InsertionAdapter(
            database,
            'TBL_DailyDetail',
            (TBL_DailyDetail item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'monthYear': item.monthYear,
                  'dailyId': item.dailyId,
                  'accountName': item.accountName,
                  'categoryName': item.categoryName,
                  'toAccountName': item.toAccountName,
                  'accountId': item.accountId,
                  'categoryId': item.categoryId,
                  'toAccountId': item.toAccountId,
                  'amount': item.amount,
                  'note': item.note,
                  'other': item.other,
                  'type': item.type,
                  'bookmark': item.bookmark,
                  'image': item.image,
                  'isUpload': item.isUpload,
                  'isActive': item.isActive,
                  'createdBy': item.createdBy,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBL_DailyDetail> _tBL_DailyDetailInsertionAdapter;

  @override
  Future<List<TBL_DailyDetail>> selectAllById(
      String id, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_DailyDetail WHERE id=?1 and createdBy=?2 and isActive=?3 order by updatedAt desc',
        mapper: (Map<String, Object?> row) => TBL_DailyDetail(id: row['id'] as String, date: row['date'] as String, monthYear: row['monthYear'] as String, dailyId: row['dailyId'] as String, accountName: row['accountName'] as String, toAccountName: row['toAccountName'] as String, categoryName: row['categoryName'] as String, accountId: row['accountId'] as String, categoryId: row['categoryId'] as String, toAccountId: row['toAccountId'] as String, amount: row['amount'] as String, note: row['note'] as String, other: row['other'] as String, type: row['type'] as String, bookmark: row['bookmark'] as String, image: row['image'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [id, createdBy, isActive]);
  }

  @override
  Future<List<TBL_DailyDetail>> selectByDailyId(
      String dailyId, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_DailyDetail WHERE dailyId=?1 and createdBy=?2 and isActive=?3 order by updatedAt desc',
        mapper: (Map<String, Object?> row) => TBL_DailyDetail(id: row['id'] as String, date: row['date'] as String, monthYear: row['monthYear'] as String, dailyId: row['dailyId'] as String, accountName: row['accountName'] as String, toAccountName: row['toAccountName'] as String, categoryName: row['categoryName'] as String, accountId: row['accountId'] as String, categoryId: row['categoryId'] as String, toAccountId: row['toAccountId'] as String, amount: row['amount'] as String, note: row['note'] as String, other: row['other'] as String, type: row['type'] as String, bookmark: row['bookmark'] as String, image: row['image'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [dailyId, createdBy, isActive]);
  }

  @override
  Future<List<TBL_DailyDetail>> selectByAccountId(
      String accountId, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_DailyDetail WHERE accountId=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBL_DailyDetail(id: row['id'] as String, date: row['date'] as String, monthYear: row['monthYear'] as String, dailyId: row['dailyId'] as String, accountName: row['accountName'] as String, toAccountName: row['toAccountName'] as String, categoryName: row['categoryName'] as String, accountId: row['accountId'] as String, categoryId: row['categoryId'] as String, toAccountId: row['toAccountId'] as String, amount: row['amount'] as String, note: row['note'] as String, other: row['other'] as String, type: row['type'] as String, bookmark: row['bookmark'] as String, image: row['image'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [accountId, createdBy, isActive]);
  }

  @override
  Future<List<TBL_DailyDetail>> selectByToAccountId(
      String toAccountId, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_DailyDetail WHERE toAccountId=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBL_DailyDetail(id: row['id'] as String, date: row['date'] as String, monthYear: row['monthYear'] as String, dailyId: row['dailyId'] as String, accountName: row['accountName'] as String, toAccountName: row['toAccountName'] as String, categoryName: row['categoryName'] as String, accountId: row['accountId'] as String, categoryId: row['categoryId'] as String, toAccountId: row['toAccountId'] as String, amount: row['amount'] as String, note: row['note'] as String, other: row['other'] as String, type: row['type'] as String, bookmark: row['bookmark'] as String, image: row['image'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [toAccountId, createdBy, isActive]);
  }

  @override
  Future<List<TBL_DailyDetail>> selectByDate(
      String date, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_DailyDetail WHERE date=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBL_DailyDetail(id: row['id'] as String, date: row['date'] as String, monthYear: row['monthYear'] as String, dailyId: row['dailyId'] as String, accountName: row['accountName'] as String, toAccountName: row['toAccountName'] as String, categoryName: row['categoryName'] as String, accountId: row['accountId'] as String, categoryId: row['categoryId'] as String, toAccountId: row['toAccountId'] as String, amount: row['amount'] as String, note: row['note'] as String, other: row['other'] as String, type: row['type'] as String, bookmark: row['bookmark'] as String, image: row['image'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [date, createdBy, isActive]);
  }

  @override
  Future<void> deleteById(String id, String createdBy, String isActive) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE TBL_DailyDetail set isActive=?3 WHERE id=?1 and createdBy=?2',
        arguments: [id, createdBy, isActive]);
  }

  @override
  Future<void> deleteByIdUploaded(
      String id, String createdBy, String isUpload) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE TBL_DailyDetail set isUpload=?3 WHERE id=?1 and createdBy=?2',
        arguments: [id, createdBy, isUpload]);
  }

  @override
  Future<List<TBL_DailyDetail>> selectAllTransaction(
      String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_DailyDetail WHERE createdBy=?1 and isActive=?2',
        mapper: (Map<String, Object?> row) => TBL_DailyDetail(
            id: row['id'] as String,
            date: row['date'] as String,
            monthYear: row['monthYear'] as String,
            dailyId: row['dailyId'] as String,
            accountName: row['accountName'] as String,
            toAccountName: row['toAccountName'] as String,
            categoryName: row['categoryName'] as String,
            accountId: row['accountId'] as String,
            categoryId: row['categoryId'] as String,
            toAccountId: row['toAccountId'] as String,
            amount: row['amount'] as String,
            note: row['note'] as String,
            other: row['other'] as String,
            type: row['type'] as String,
            bookmark: row['bookmark'] as String,
            image: row['image'] as String,
            isUpload: row['isUpload'] as String,
            isActive: row['isActive'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [createdBy, isActive]);
  }

  @override
  Future<List<TBL_DailyDetail>> selectDailyDetailByCategoryMonthYear(
      String createdBy,
      String categoryId,
      String isActive,
      String monthYear) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_DailyDetail WHERE createdBy=?1 and categoryId=?2 and isActive=?3 and monthYear=?4',
        mapper: (Map<String, Object?> row) => TBL_DailyDetail(id: row['id'] as String, date: row['date'] as String, monthYear: row['monthYear'] as String, dailyId: row['dailyId'] as String, accountName: row['accountName'] as String, toAccountName: row['toAccountName'] as String, categoryName: row['categoryName'] as String, accountId: row['accountId'] as String, categoryId: row['categoryId'] as String, toAccountId: row['toAccountId'] as String, amount: row['amount'] as String, note: row['note'] as String, other: row['other'] as String, type: row['type'] as String, bookmark: row['bookmark'] as String, image: row['image'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [createdBy, categoryId, isActive, monthYear]);
  }

  @override
  Future<void> insert(TBL_DailyDetail transaction) async {
    await _tBL_DailyDetailInsertionAdapter.insert(
        transaction, OnConflictStrategy.replace);
  }
}

class _$TBLDailyDao extends TBLDailyDao {
  _$TBLDailyDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBL_DailyInsertionAdapter = InsertionAdapter(
            database,
            'TBL_Daily',
            (TBL_Daily item) => <String, Object?>{
                  'id': item.id,
                  'monthlySummaryID': item.monthlySummaryID,
                  'date': item.date,
                  'monthYear': item.monthYear,
                  'incomeAmount': item.incomeAmount,
                  'expenseAmount': item.expenseAmount,
                  'totalAmount': item.totalAmount,
                  'isUpload': item.isUpload,
                  'isActive': item.isActive,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBL_Daily> _tBL_DailyInsertionAdapter;

  @override
  Future<List<TBL_Daily>> selectDailyByMonthYear(
      String monthYear, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_Daily WHERE monthYear=?1 and createdBy=?2 and isActive=?3 order by updatedAt desc',
        mapper: (Map<String, Object?> row) => TBL_Daily(id: row['id'] as String, monthlySummaryID: row['monthlySummaryID'] as String, date: row['date'] as String, monthYear: row['monthYear'] as String, incomeAmount: row['incomeAmount'] as String, expenseAmount: row['expenseAmount'] as String, totalAmount: row['totalAmount'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [monthYear, createdBy, isActive]);
  }

  @override
  Future<List<TBL_Daily>> selectDailyByDate(
      String date, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_Daily WHERE date=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBL_Daily(id: row['id'] as String, monthlySummaryID: row['monthlySummaryID'] as String, date: row['date'] as String, monthYear: row['monthYear'] as String, incomeAmount: row['incomeAmount'] as String, expenseAmount: row['expenseAmount'] as String, totalAmount: row['totalAmount'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [date, createdBy, isActive]);
  }

  @override
  Future<List<TBL_Daily>> selectById(String id, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_Daily WHERE id=?1 and isActive=?2',
        mapper: (Map<String, Object?> row) => TBL_Daily(
            id: row['id'] as String,
            monthlySummaryID: row['monthlySummaryID'] as String,
            date: row['date'] as String,
            monthYear: row['monthYear'] as String,
            incomeAmount: row['incomeAmount'] as String,
            expenseAmount: row['expenseAmount'] as String,
            totalAmount: row['totalAmount'] as String,
            isUpload: row['isUpload'] as String,
            isActive: row['isActive'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [id, isActive]);
  }

  @override
  Future<List<TBL_Daily>> selectDailyAll(
      String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_Daily WHERE createdBy=?1 and isActive=?2 order by updatedAt desc',
        mapper: (Map<String, Object?> row) => TBL_Daily(id: row['id'] as String, monthlySummaryID: row['monthlySummaryID'] as String, date: row['date'] as String, monthYear: row['monthYear'] as String, incomeAmount: row['incomeAmount'] as String, expenseAmount: row['expenseAmount'] as String, totalAmount: row['totalAmount'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [createdBy, isActive]);
  }

  @override
  Future<void> insert(TBL_Daily tbl_daily) async {
    await _tBL_DailyInsertionAdapter.insert(
        tbl_daily, OnConflictStrategy.replace);
  }
}

class _$TBLMonthlySummaryDao extends TBLMonthlySummaryDao {
  _$TBLMonthlySummaryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLMonthlySummaryInsertionAdapter = InsertionAdapter(
            database,
            'TBLMonthlySummary',
            (TBLMonthlySummary item) => <String, Object?>{
                  'id': item.id,
                  'monthYear': item.monthYear,
                  'year': item.year,
                  'incomeAmount': item.incomeAmount,
                  'expenseAmount': item.expenseAmount,
                  'total': item.total,
                  'isUpload': item.isUpload,
                  'isActive': item.isActive,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLMonthlySummary> _tBLMonthlySummaryInsertionAdapter;

  @override
  Future<List<TBLMonthlySummary>> selectByMonthYear(
      String monthYear, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLMonthlySummary WHERE monthYear=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBLMonthlySummary(id: row['id'] as String, monthYear: row['monthYear'] as String, year: row['year'] as String, incomeAmount: row['incomeAmount'] as String, expenseAmount: row['expenseAmount'] as String, total: row['total'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [monthYear, createdBy, isActive]);
  }

  @override
  Future<List<TBLMonthlySummary>> selectByYear(
      String year, String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLMonthlySummary WHERE year=?1 and createdBy=?2 and isActive=?3',
        mapper: (Map<String, Object?> row) => TBLMonthlySummary(id: row['id'] as String, monthYear: row['monthYear'] as String, year: row['year'] as String, incomeAmount: row['incomeAmount'] as String, expenseAmount: row['expenseAmount'] as String, total: row['total'] as String, isUpload: row['isUpload'] as String, isActive: row['isActive'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [year, createdBy, isActive]);
  }

  @override
  Future<void> insert(TBLMonthlySummary summary) async {
    await _tBLMonthlySummaryInsertionAdapter.insert(
        summary, OnConflictStrategy.replace);
  }
}

class _$TBLAccountSummaryDao extends TBLAccountSummaryDao {
  _$TBLAccountSummaryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLAccountSummaryInsertionAdapter = InsertionAdapter(
            database,
            'TBLAccountSummary',
            (TBLAccountSummary item) => <String, Object?>{
                  'id': item.id,
                  'account': item.account,
                  'liabilities': item.liabilities,
                  'total': item.total,
                  'isActive': item.isActive,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLAccountSummary> _tBLAccountSummaryInsertionAdapter;

  @override
  Future<List<TBLAccountSummary>> selectAll(
      String createdBy, String isActive) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLAccountSummary WHERE createdBy=?1 and isActive=?2',
        mapper: (Map<String, Object?> row) => TBLAccountSummary(
            id: row['id'] as String,
            account: row['account'] as String,
            liabilities: row['liabilities'] as String,
            total: row['total'] as String,
            isActive: row['isActive'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [createdBy, isActive]);
  }

  @override
  Future<void> insert(TBLAccountSummary summary) async {
    await _tBLAccountSummaryInsertionAdapter.insert(
        summary, OnConflictStrategy.replace);
  }
}

class _$TBLWeeklyDao extends TBLWeeklyDao {
  _$TBLWeeklyDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBL_WeeklyInsertionAdapter = InsertionAdapter(
            database,
            'TBL_Weekly',
            (TBL_Weekly item) => <String, Object?>{
                  'id': item.id,
                  'weekly': item.weekly,
                  'monthYear': item.monthYear,
                  'income': item.income,
                  'expense': item.expense,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBL_Weekly> _tBL_WeeklyInsertionAdapter;

  @override
  Future<List<TBL_Weekly>> selectByMonthYear(
      String monthYear, String createdBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_Weekly WHERE monthYear=?1 and createdBy=?2',
        mapper: (Map<String, Object?> row) => TBL_Weekly(
            id: row['id'] as String,
            weekly: row['weekly'] as String,
            monthYear: row['monthYear'] as String,
            income: row['income'] as String,
            expense: row['expense'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [monthYear, createdBy]);
  }

  @override
  Future<List<TBL_Weekly>> selectAll(String createdBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_Weekly WHERE createdBy=?1',
        mapper: (Map<String, Object?> row) => TBL_Weekly(
            id: row['id'] as String,
            weekly: row['weekly'] as String,
            monthYear: row['monthYear'] as String,
            income: row['income'] as String,
            expense: row['expense'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [createdBy]);
  }

  @override
  Future<List<TBL_Weekly>> selectByWeekDay(
      String weekly, String createdBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_Weekly WHERE weekly=?1 and createdBy=?2',
        mapper: (Map<String, Object?> row) => TBL_Weekly(
            id: row['id'] as String,
            weekly: row['weekly'] as String,
            monthYear: row['monthYear'] as String,
            income: row['income'] as String,
            expense: row['expense'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [weekly, createdBy]);
  }

  @override
  Future<void> insert(TBL_Weekly summary) async {
    await _tBL_WeeklyInsertionAdapter.insert(
        summary, OnConflictStrategy.replace);
  }
}

class _$TBLDailyForWeekDao extends TBLDailyForWeekDao {
  _$TBLDailyForWeekDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBL_DailyForWeekInsertionAdapter = InsertionAdapter(
            database,
            'TBL_DailyForWeek',
            (TBL_DailyForWeek item) => <String, Object?>{
                  'id': item.id,
                  'day': item.day,
                  'weeklyId': item.weeklyId,
                  'income': item.income,
                  'expense': item.expense,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBL_DailyForWeek> _tBL_DailyForWeekInsertionAdapter;

  @override
  Future<List<TBL_DailyForWeek>> selectByWeeklySummaryId(
      String weeklyId, String createdBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_DailyForWeek WHERE weeklyId=?1 and createdBy=?2',
        mapper: (Map<String, Object?> row) => TBL_DailyForWeek(
            id: row['id'] as String,
            day: row['day'] as String,
            weeklyId: row['weeklyId'] as String,
            income: row['income'] as String,
            expense: row['expense'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [weeklyId, createdBy]);
  }

  @override
  Future<List<TBL_DailyForWeek>> selectByDay(
      String day, String createdBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBL_DailyForWeek WHERE day=?1 and createdBy=?2',
        mapper: (Map<String, Object?> row) => TBL_DailyForWeek(
            id: row['id'] as String,
            day: row['day'] as String,
            weeklyId: row['weeklyId'] as String,
            income: row['income'] as String,
            expense: row['expense'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [day, createdBy]);
  }

  @override
  Future<void> insert(TBL_DailyForWeek weekly) async {
    await _tBL_DailyForWeekInsertionAdapter.insert(
        weekly, OnConflictStrategy.replace);
  }
}

class _$TBLWeeklySummaryDao extends TBLWeeklySummaryDao {
  _$TBLWeeklySummaryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLWeeklySummaryInsertionAdapter = InsertionAdapter(
            database,
            'TBLWeeklySummary',
            (TBLWeeklySummary item) => <String, Object?>{
                  'id': item.id,
                  'income': item.income,
                  'expense': item.expense,
                  'total': item.total,
                  'monthYear': item.monthYear,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLWeeklySummary> _tBLWeeklySummaryInsertionAdapter;

  @override
  Future<List<TBLWeeklySummary>> selectByMonthYear(
      String monthYear, String createdBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLWeeklySummary WHERE monthYear=?1 and createdBy=?2',
        mapper: (Map<String, Object?> row) => TBLWeeklySummary(
            id: row['id'] as String,
            income: row['income'] as String,
            expense: row['expense'] as String,
            total: row['total'] as String,
            monthYear: row['monthYear'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [monthYear, createdBy]);
  }

  @override
  Future<void> insert(TBLWeeklySummary weeklySummary) async {
    await _tBLWeeklySummaryInsertionAdapter.insert(
        weeklySummary, OnConflictStrategy.replace);
  }
}

class _$TBLProfileDao extends TBLProfileDao {
  _$TBLProfileDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLProfileInsertionAdapter = InsertionAdapter(
            database,
            'TBLProfile',
            (TBLProfile item) => <String, Object?>{
                  'id': item.id,
                  'full_name': item.full_name,
                  'user_name': item.user_name,
                  'password': item.password,
                  'email_address': item.email_address,
                  'phone_no': item.phone_no,
                  'image': item.image,
                  'dob': item.dob,
                  'gender': item.gender,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLProfile> _tBLProfileInsertionAdapter;

  @override
  Future<List<TBLProfile>> selectByPhoneNo(String phoneNo) async {
    return _queryAdapter.queryList('SELECT * FROM TBLProfile WHERE phone_no=?1',
        mapper: (Map<String, Object?> row) => TBLProfile(
            id: row['id'] as String,
            full_name: row['full_name'] as String,
            user_name: row['user_name'] as String,
            password: row['password'] as String,
            email_address: row['email_address'] as String,
            phone_no: row['phone_no'] as String,
            image: row['image'] as String,
            dob: row['dob'] as String,
            gender: row['gender'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [phoneNo]);
  }

  @override
  Future<List<TBLProfile>> selectByProfileId(String profileId) async {
    return _queryAdapter.queryList('SELECT * FROM TBLProfile WHERE id=?1',
        mapper: (Map<String, Object?> row) => TBLProfile(
            id: row['id'] as String,
            full_name: row['full_name'] as String,
            user_name: row['user_name'] as String,
            password: row['password'] as String,
            email_address: row['email_address'] as String,
            phone_no: row['phone_no'] as String,
            image: row['image'] as String,
            dob: row['dob'] as String,
            gender: row['gender'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [profileId]);
  }

  @override
  Future<void> insert(TBLProfile profile) async {
    await _tBLProfileInsertionAdapter.insert(
        profile, OnConflictStrategy.replace);
  }
}

class _$TBLStatusDao extends TBLStatusDao {
  _$TBLStatusDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLStatusInsertionAdapter = InsertionAdapter(
            database,
            'TBLStatus',
            (TBLStatus item) => <String, Object?>{
                  'id': item.id,
                  'categoryName': item.categoryName,
                  'type': item.type,
                  'amount': item.amount,
                  'percent': item.percent,
                  'color': item.color,
                  'monthYear': item.monthYear,
                  'createdAt': item.createdAt,
                  'createdBy': item.createdBy,
                  'updatedAt': item.updatedAt,
                  'updatedBy': item.updatedBy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLStatus> _tBLStatusInsertionAdapter;

  @override
  Future<List<TBLStatus>> selectAll() async {
    return _queryAdapter.queryList('SELECT * FROM TBLStatus',
        mapper: (Map<String, Object?> row) => TBLStatus(
            id: row['id'] as String,
            categoryName: row['categoryName'] as String,
            type: row['type'] as String,
            amount: row['amount'] as String,
            percent: row['percent'] as String,
            color: row['color'] as String,
            monthYear: row['monthYear'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String));
  }

  @override
  Future<List<TBLStatus>> selectByType(
      String type, String createdBy, String monthYear) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLStatus WHERE type=?1 and createdBy=?2 and monthYear=?3',
        mapper: (Map<String, Object?> row) => TBLStatus(id: row['id'] as String, categoryName: row['categoryName'] as String, type: row['type'] as String, amount: row['amount'] as String, percent: row['percent'] as String, color: row['color'] as String, monthYear: row['monthYear'] as String, createdAt: row['createdAt'] as String, createdBy: row['createdBy'] as String, updatedAt: row['updatedAt'] as String, updatedBy: row['updatedBy'] as String),
        arguments: [type, createdBy, monthYear]);
  }

  @override
  Future<void> deleteById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM TBLStatus WHERE id=?1', arguments: [id]);
  }

  @override
  Future<void> insert(TBLStatus status) async {
    await _tBLStatusInsertionAdapter.insert(status, OnConflictStrategy.replace);
  }
}

class _$TBLExchangeDao extends TBLExchangeDao {
  _$TBLExchangeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLExchangeInsertionAdapter = InsertionAdapter(
            database,
            'TBLExchange',
            (TBLExchange item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'price': item.price,
                  'createdBy': item.createdBy,
                  'updatedBy': item.updatedBy,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLExchange> _tBLExchangeInsertionAdapter;

  @override
  Future<List<TBLExchange>> selectByDate(
      String updatedAt, String createdBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TBLExchange WHERE updatedAt=?1 and createdBy=?2',
        mapper: (Map<String, Object?> row) => TBLExchange(
            id: row['id'] as String,
            name: row['name'] as String,
            price: row['price'] as String,
            createdAt: row['createdAt'] as String,
            createdBy: row['createdBy'] as String,
            updatedAt: row['updatedAt'] as String,
            updatedBy: row['updatedBy'] as String),
        arguments: [updatedAt, createdBy]);
  }

  @override
  Future<void> deleteById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM TBLExchange WHERE id=?1', arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM TBLExchange');
  }

  @override
  Future<void> insert(TBLExchange tblExchange) async {
    await _tBLExchangeInsertionAdapter.insert(
        tblExchange, OnConflictStrategy.replace);
  }
}

class _$TBLGoldDao extends TBLGoldDao {
  _$TBLGoldDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tBLGoldInsertionAdapter = InsertionAdapter(
            database,
            'TBLGold',
            (TBLGold item) => <String, Object?>{
                  'id': item.id,
                  'local_price': item.local_price,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TBLGold> _tBLGoldInsertionAdapter;

  @override
  Future<List<TBLGold>> selectByDate(String date) async {
    return _queryAdapter.queryList('SELECT * FROM TBLGold WHERE date=?1',
        mapper: (Map<String, Object?> row) => TBLGold(
            id: row['id'] as String,
            local_price: row['local_price'] as String,
            date: row['date'] as String),
        arguments: [date]);
  }

  @override
  Future<List<TBLGold>> selectAll() async {
    return _queryAdapter.queryList('SELECT * FROM TBLGold',
        mapper: (Map<String, Object?> row) => TBLGold(
            id: row['id'] as String,
            local_price: row['local_price'] as String,
            date: row['date'] as String));
  }

  @override
  Future<void> insert(TBLGold categoryGroup) async {
    await _tBLGoldInsertionAdapter.insert(
        categoryGroup, OnConflictStrategy.replace);
  }
}
