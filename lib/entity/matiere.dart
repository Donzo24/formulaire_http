
import 'package:floor/floor.dart';

@Entity(
  tableName: "matiere",
)
class Matiere {
  
  @PrimaryKey(autoGenerate: true)
  int? id;
  String nom;


  Matiere(this.id, this.nom);
}