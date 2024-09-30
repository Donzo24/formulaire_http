
import 'package:floor/floor.dart';
import 'package:formulaire_http/entity/tache.dart';

@dao
abstract class TacheDao {

  @Query("SELECT * FROM Tache")
  Future<List<Tache>> findAllTaches();

  @Query("SELECT * FROM Tache WHERE id = :id")
  Future<Tache?> findById(int id);

  @insert
  Future<void> insertTache(Tache tache);

  @delete
  Future<void> deleteTache(Tache tache);

  @Update(
    onConflict: OnConflictStrategy.replace
  )
  Future<void> updateTache(Tache tache);
  
}