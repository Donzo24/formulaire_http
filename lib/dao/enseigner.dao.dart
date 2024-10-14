
import 'package:floor/floor.dart';
import 'package:formulaire_http/entity/classe.dart';
import 'package:formulaire_http/entity/enseigner.dart';

@dao
abstract class EnseignerDao {

  @Query("SELECT * FROM enseigner")
  Future<List<Enseigner>> findAll();

  @insert
  Future<void> addEnseigner(Enseigner classe);

  @Update(
    onConflict: OnConflictStrategy.replace
  )
  Future<void> updateEnseigner(Enseigner classe);

  @delete
  Future<void> deleteEnseigner(Enseigner classe);
}