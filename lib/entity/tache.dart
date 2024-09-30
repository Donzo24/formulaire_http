

import 'package:floor/floor.dart';

@entity
class Tache {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String description;

  Tache({this.id, required this.title, required this.description});

}