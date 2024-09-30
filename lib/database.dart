import 'dart:async';
import 'package:floor/floor.dart';
import 'package:formulaire_http/dao/tache_dao.dart';
import 'package:formulaire_http/entity/tache.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Tache])
abstract class AppDatabase extends FloorDatabase {
  TacheDao get tacheDao;
}
