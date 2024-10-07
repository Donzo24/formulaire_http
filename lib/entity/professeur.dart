
import 'package:floor/floor.dart';

@Entity(
  tableName: "professeur",
)
class Professeur {
  
  @PrimaryKey(autoGenerate: true)
  int? id;
  String nom;
  String prenom;
  String contact;

  Professeur(this.id, this.nom, this.prenom, this.contact);
}