
import 'package:floor/floor.dart';
import 'package:formulaire_http/entity/professeur.dart';
import 'package:formulaire_http/entity/professeur.dart';

@dao
abstract class ProfesseurDao {

  @Query("SELECT * FROM professeur")
  Future<List<Professeur>> findAll();

  @Query("SELECT * FROM professeur WHERE id = :id")
  Future<Professeur?> findById(int id);

  @insert
  Future<void> addProfesseur(Professeur professeur);

  @Update(
    onConflict: OnConflictStrategy.replace
  )
  Future<void> updateProfesseur(Professeur professeur);

  @delete
  Future<void> deleteProfesseur(Professeur professeur);
}