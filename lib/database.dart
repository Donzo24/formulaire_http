import 'dart:async';
import 'package:floor/floor.dart';
import 'package:formulaire_http/dao/classe.dao.dart';
import 'package:formulaire_http/dao/eleve_dao.dart';
import 'package:formulaire_http/dao/enseigner.dao.dart';
import 'package:formulaire_http/dao/matiere.dao.dart';
import 'package:formulaire_http/dao/professeur.dao.dart';
import 'package:formulaire_http/entity/classe.dart';
import 'package:formulaire_http/entity/eleve.dart';
import 'package:formulaire_http/entity/enseigner.dart';
import 'package:formulaire_http/entity/matiere.dart';
import 'package:formulaire_http/entity/professeur.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Classe, Professeur, Enseigner, Matiere, Eleve])
abstract class AppDatabase extends FloorDatabase {
  EleveDao get eleveDao;
  ClasseDao get classeDao;
  MatiereDao get matiereDao;
  ProfesseurDao get professeurDao;
  EnseignerDao get enseignerDao;
}
