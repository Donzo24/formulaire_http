

import 'package:floor/floor.dart';

@entity
class Tache {
  @primaryKey
  final int id;
  final String title;
  final String description;

  Tache(this.id, this.title, this.description);

}