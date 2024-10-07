
import 'package:floor/floor.dart';
import 'package:formulaire_http/entity/classe.dart';

@dao
abstract class ClasseDao {

  @Query("SELECT * FROM classe")
  Future<List<Classe>> findAll();

  @Query("SELECT * FROM classe WHERE id = :id")
  Future<Classe?> findById(int id);

  @insert
  Future<void> addClasse(Classe classe);

  @Update(
    onConflict: OnConflictStrategy.replace
  )
  Future<void> updateClasse(Classe classe);

  @delete
  Future<void> deleteClasse(Classe classe);
}