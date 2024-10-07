
import 'package:floor/floor.dart';
import 'package:formulaire_http/entity/classe.dart';

@Entity(
  tableName: "eleve",
  foreignKeys: [
    ForeignKey(
      childColumns: ["classe_id"], 
      parentColumns: ["id"], 
      entity: Classe,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.cascade
    )
  ]
)
class Eleve {
  
  @PrimaryKey(autoGenerate: true)
  int? id;
  String nom;
  String prenom;
  String genre;

  @ColumnInfo(
    name: "date_naissance"
  )
  String dateNaissance;

  @ColumnInfo(
    name: "classe_id"
  )
  int classeId;

  Eleve(this.id, this.nom, this.prenom, this.genre, this.dateNaissance, this.classeId);
}