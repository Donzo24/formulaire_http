
import 'package:floor/floor.dart';
import 'package:formulaire_http/entity/matiere.dart';
import 'package:formulaire_http/entity/matiere.dart';

@dao
abstract class MatiereDao {

  @Query("SELECT * FROM matiere")
  Future<List<Matiere>> findAll();

  @Query("SELECT * FROM matiere WHERE id = :id")
  Future<Matiere?> findById(int id);

  @insert
  Future<void> addMatiere(Matiere matiere);

  @Update(
    onConflict: OnConflictStrategy.replace
  )
  Future<void> updateMatiere(Matiere matiere);

  @delete
  Future<void> deleteMatiere(Matiere matiere);
}