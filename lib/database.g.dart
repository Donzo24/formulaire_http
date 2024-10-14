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

  EleveDao? _eleveDaoInstance;

  ClasseDao? _classeDaoInstance;

  MatiereDao? _matiereDaoInstance;

  ProfesseurDao? _professeurDaoInstance;

  EnseignerDao? _enseignerDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Classe` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `nom` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `professeur` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `nom` TEXT NOT NULL, `prenom` TEXT NOT NULL, `contact` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `enseigner` (`matiereId` INTEGER NOT NULL, `professeurId` INTEGER NOT NULL, FOREIGN KEY (`matiereId`) REFERENCES `matiere` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`professeurId`) REFERENCES `professeur` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`matiereId`, `professeurId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `matiere` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `nom` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `eleve` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `nom` TEXT NOT NULL, `prenom` TEXT NOT NULL, `genre` TEXT NOT NULL, `date_naissance` TEXT NOT NULL, `classe_id` INTEGER NOT NULL, FOREIGN KEY (`classe_id`) REFERENCES `Classe` (`id`) ON UPDATE CASCADE ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EleveDao get eleveDao {
    return _eleveDaoInstance ??= _$EleveDao(database, changeListener);
  }

  @override
  ClasseDao get classeDao {
    return _classeDaoInstance ??= _$ClasseDao(database, changeListener);
  }

  @override
  MatiereDao get matiereDao {
    return _matiereDaoInstance ??= _$MatiereDao(database, changeListener);
  }

  @override
  ProfesseurDao get professeurDao {
    return _professeurDaoInstance ??= _$ProfesseurDao(database, changeListener);
  }

  @override
  EnseignerDao get enseignerDao {
    return _enseignerDaoInstance ??= _$EnseignerDao(database, changeListener);
  }
}

class _$EleveDao extends EleveDao {
  _$EleveDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _eleveInsertionAdapter = InsertionAdapter(
            database,
            'eleve',
            (Eleve item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'prenom': item.prenom,
                  'genre': item.genre,
                  'date_naissance': item.dateNaissance,
                  'classe_id': item.classeId
                }),
        _eleveUpdateAdapter = UpdateAdapter(
            database,
            'eleve',
            ['id'],
            (Eleve item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'prenom': item.prenom,
                  'genre': item.genre,
                  'date_naissance': item.dateNaissance,
                  'classe_id': item.classeId
                }),
        _eleveDeletionAdapter = DeletionAdapter(
            database,
            'eleve',
            ['id'],
            (Eleve item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'prenom': item.prenom,
                  'genre': item.genre,
                  'date_naissance': item.dateNaissance,
                  'classe_id': item.classeId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Eleve> _eleveInsertionAdapter;

  final UpdateAdapter<Eleve> _eleveUpdateAdapter;

  final DeletionAdapter<Eleve> _eleveDeletionAdapter;

  @override
  Future<List<Eleve>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM eleve',
        mapper: (Map<String, Object?> row) => Eleve(
            row['id'] as int?,
            row['nom'] as String,
            row['prenom'] as String,
            row['genre'] as String,
            row['date_naissance'] as String,
            row['classe_id'] as int));
  }

  @override
  Future<Eleve?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM eleve WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Eleve(
            row['id'] as int?,
            row['nom'] as String,
            row['prenom'] as String,
            row['genre'] as String,
            row['date_naissance'] as String,
            row['classe_id'] as int),
        arguments: [id]);
  }

  @override
  Future<void> inscrire(Eleve eleve) async {
    await _eleveInsertionAdapter.insert(eleve, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEleve(Eleve eleve) async {
    await _eleveUpdateAdapter.update(eleve, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteEleve(Eleve eleve) async {
    await _eleveDeletionAdapter.delete(eleve);
  }
}

class _$ClasseDao extends ClasseDao {
  _$ClasseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _classeInsertionAdapter = InsertionAdapter(
            database,
            'Classe',
            (Classe item) => <String, Object?>{'id': item.id, 'nom': item.nom},
            changeListener),
        _classeUpdateAdapter = UpdateAdapter(
            database,
            'Classe',
            ['id'],
            (Classe item) => <String, Object?>{'id': item.id, 'nom': item.nom},
            changeListener),
        _classeDeletionAdapter = DeletionAdapter(
            database,
            'Classe',
            ['id'],
            (Classe item) => <String, Object?>{'id': item.id, 'nom': item.nom},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Classe> _classeInsertionAdapter;

  final UpdateAdapter<Classe> _classeUpdateAdapter;

  final DeletionAdapter<Classe> _classeDeletionAdapter;

  @override
  Future<List<Classe>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM classe',
        mapper: (Map<String, Object?> row) =>
            Classe(row['id'] as int?, row['nom'] as String));
  }

  @override
  Stream<List<Classe>> findAllStream() {
    return _queryAdapter.queryListStream('SELECT * FROM classe',
        mapper: (Map<String, Object?> row) =>
            Classe(row['id'] as int?, row['nom'] as String),
        queryableName: 'classe',
        isView: false);
  }

  @override
  Future<Classe?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM classe WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Classe(row['id'] as int?, row['nom'] as String),
        arguments: [id]);
  }

  @override
  Future<void> addClasse(Classe classe) async {
    await _classeInsertionAdapter.insert(classe, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateClasse(Classe classe) async {
    await _classeUpdateAdapter.update(classe, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteClasse(Classe classe) async {
    await _classeDeletionAdapter.delete(classe);
  }
}

class _$MatiereDao extends MatiereDao {
  _$MatiereDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _matiereInsertionAdapter = InsertionAdapter(
            database,
            'matiere',
            (Matiere item) =>
                <String, Object?>{'id': item.id, 'nom': item.nom}),
        _matiereUpdateAdapter = UpdateAdapter(
            database,
            'matiere',
            ['id'],
            (Matiere item) =>
                <String, Object?>{'id': item.id, 'nom': item.nom}),
        _matiereDeletionAdapter = DeletionAdapter(
            database,
            'matiere',
            ['id'],
            (Matiere item) =>
                <String, Object?>{'id': item.id, 'nom': item.nom});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Matiere> _matiereInsertionAdapter;

  final UpdateAdapter<Matiere> _matiereUpdateAdapter;

  final DeletionAdapter<Matiere> _matiereDeletionAdapter;

  @override
  Future<List<Matiere>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM matiere',
        mapper: (Map<String, Object?> row) =>
            Matiere(row['id'] as int?, row['nom'] as String));
  }

  @override
  Future<Matiere?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM matiere WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Matiere(row['id'] as int?, row['nom'] as String),
        arguments: [id]);
  }

  @override
  Future<void> addMatiere(Matiere matiere) async {
    await _matiereInsertionAdapter.insert(matiere, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMatiere(Matiere matiere) async {
    await _matiereUpdateAdapter.update(matiere, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteMatiere(Matiere matiere) async {
    await _matiereDeletionAdapter.delete(matiere);
  }
}

class _$ProfesseurDao extends ProfesseurDao {
  _$ProfesseurDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _professeurInsertionAdapter = InsertionAdapter(
            database,
            'professeur',
            (Professeur item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'prenom': item.prenom,
                  'contact': item.contact
                }),
        _professeurUpdateAdapter = UpdateAdapter(
            database,
            'professeur',
            ['id'],
            (Professeur item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'prenom': item.prenom,
                  'contact': item.contact
                }),
        _professeurDeletionAdapter = DeletionAdapter(
            database,
            'professeur',
            ['id'],
            (Professeur item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'prenom': item.prenom,
                  'contact': item.contact
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Professeur> _professeurInsertionAdapter;

  final UpdateAdapter<Professeur> _professeurUpdateAdapter;

  final DeletionAdapter<Professeur> _professeurDeletionAdapter;

  @override
  Future<List<Professeur>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM professeur',
        mapper: (Map<String, Object?> row) => Professeur(
            row['id'] as int?,
            row['nom'] as String,
            row['prenom'] as String,
            row['contact'] as String));
  }

  @override
  Future<Professeur?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM professeur WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Professeur(
            row['id'] as int?,
            row['nom'] as String,
            row['prenom'] as String,
            row['contact'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertProfesseur(Professeur professeur) async {
    await _professeurInsertionAdapter.insert(
        professeur, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProfesseur(Professeur professeur) async {
    await _professeurUpdateAdapter.update(
        professeur, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteProfesseur(Professeur professeur) async {
    await _professeurDeletionAdapter.delete(professeur);
  }
}

class _$EnseignerDao extends EnseignerDao {
  _$EnseignerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _enseignerInsertionAdapter = InsertionAdapter(
            database,
            'enseigner',
            (Enseigner item) => <String, Object?>{
                  'matiereId': item.matiereId,
                  'professeurId': item.professeurId
                }),
        _enseignerUpdateAdapter = UpdateAdapter(
            database,
            'enseigner',
            ['matiereId', 'professeurId'],
            (Enseigner item) => <String, Object?>{
                  'matiereId': item.matiereId,
                  'professeurId': item.professeurId
                }),
        _enseignerDeletionAdapter = DeletionAdapter(
            database,
            'enseigner',
            ['matiereId', 'professeurId'],
            (Enseigner item) => <String, Object?>{
                  'matiereId': item.matiereId,
                  'professeurId': item.professeurId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Enseigner> _enseignerInsertionAdapter;

  final UpdateAdapter<Enseigner> _enseignerUpdateAdapter;

  final DeletionAdapter<Enseigner> _enseignerDeletionAdapter;

  @override
  Future<List<Enseigner>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM enseigner',
        mapper: (Map<String, Object?> row) =>
            Enseigner(row['matiereId'] as int, row['professeurId'] as int));
  }

  @override
  Future<void> addEnseigner(Enseigner classe) async {
    await _enseignerInsertionAdapter.insert(classe, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEnseigner(Enseigner classe) async {
    await _enseignerUpdateAdapter.update(classe, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteEnseigner(Enseigner classe) async {
    await _enseignerDeletionAdapter.delete(classe);
  }
}
