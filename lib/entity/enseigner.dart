import 'package:floor/floor.dart';
import 'package:formulaire_http/entity/matiere.dart';
import 'package:formulaire_http/entity/professeur.dart';

@Entity(
  tableName: "enseigner",
  primaryKeys: ["matiereId", "professeurId"],
  foreignKeys: [
    ForeignKey(
      childColumns: ["matiereId"], 
      parentColumns: ["id"], 
      entity: Matiere
    ),
    ForeignKey(
      childColumns: ["professeurId"], 
      parentColumns: ["id"], 
      entity: Professeur
    )
  ]
)
class Enseigner {

  int matiereId;
  int professeurId;

  Enseigner(this.matiereId, this.professeurId);
}