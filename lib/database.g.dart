// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
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

  TacheDao? _tacheDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
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
            'CREATE TABLE IF NOT EXISTS `Tache` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TacheDao get tacheDao {
    return _tacheDaoInstance ??= _$TacheDao(database, changeListener);
  }
}

class _$TacheDao extends TacheDao {
  _$TacheDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tacheInsertionAdapter = InsertionAdapter(
            database,
            'Tache',
            (Tache item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description
                }),
        _tacheUpdateAdapter = UpdateAdapter(
            database,
            'Tache',
            ['id'],
            (Tache item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description
                }),
        _tacheDeletionAdapter = DeletionAdapter(
            database,
            'Tache',
            ['id'],
            (Tache item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tache> _tacheInsertionAdapter;

  final UpdateAdapter<Tache> _tacheUpdateAdapter;

  final DeletionAdapter<Tache> _tacheDeletionAdapter;

  @override
  Future<List<Tache>> findAllTaches() async {
    return _queryAdapter.queryList('SELECT * FROM Tache',
        mapper: (Map<String, Object?> row) => Tache(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String));
  }

  @override
  Future<Tache?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM Tache WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Tache(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertTache(Tache tache) async {
    await _tacheInsertionAdapter.insert(tache, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTache(Tache tache) async {
    await _tacheUpdateAdapter.update(tache, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteTache(Tache tache) async {
    await _tacheDeletionAdapter.delete(tache);
  }
}
