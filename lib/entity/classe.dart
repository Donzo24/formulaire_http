
import 'package:floor/floor.dart';

@entity
class Classe {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String nom;

  Classe(this.id, this.nom);
}