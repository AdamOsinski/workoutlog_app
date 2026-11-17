import '../database/database.dart';

import 'package:drift/drift.dart';

class ExerciseRepository {
  final AppDatabase database;

  ExerciseRepository(this.database);

  Future<List<Exercise>> getAllExercises() {
    return database.select(database.exercises).get();
  }

  Future<int> addExercise({required String name, required String resistanceType,}) {
    return database.into(database.exercises).insert(
      ExercisesCompanion.insert(
        name: name,
        resistanceType: resistanceType,
      ),
    );
  }

  Future<int> renameExercise({ required int id, required String newName,}) async{
    final query = database.update(database.exercises)
    ..where((tbl) => tbl.id.equals(id));

    return await query.write(
      ExercisesCompanion(
        name: Value(newName)
      )
    );
  }
}