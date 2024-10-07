
import 'package:floor/floor.dart';
import 'package:formulaire_http/entity/eleve.dart';

@dao
abstract class EleveDao {

  @Query("SELECT * FROM eleve")
  Future<List<Eleve>> findAll();

  @Query("SELECT * FROM eleve WHERE id = :id")
  Future<Eleve?> findById(int id);

  @insert
  Future<void> inscrire(Eleve eleve);

  @Update(
    onConflict: OnConflictStrategy.replace
  )
  Future<void> updateEleve(Eleve eleve);

  @delete
  Future<void> deleteEleve(Eleve eleve);
}