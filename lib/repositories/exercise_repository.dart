import 'package:drift/drift.dart';

import '../database/database.dart';

class ExerciseRepository {
  final AppDatabase database;

  ExerciseRepository(this.database);

  Future<List<Exercise>> getAllExercises() {
    return database.select(database.exercises).get();
  }

  Future<int> addExercise({
    required String name,
    required String resistanceType,
    required String bodypart,
    double? baseResistance,
  }) {
    return database.into(database.exercises).insert(
      ExercisesCompanion.insert(
        name: name,
        resistanceType: resistanceType,
        bodypart: bodypart,
        baseResistance: Value(baseResistance),
      ),
    );
  }

  Future<int> renameExercise({
    required int id,
    required String newName,
  }) async {
    final query = database.update(database.exercises)
      ..where((tbl) => tbl.id.equals(id));

    return query.write(
      ExercisesCompanion(
        name: Value(newName),
      ),
    );
  }
}