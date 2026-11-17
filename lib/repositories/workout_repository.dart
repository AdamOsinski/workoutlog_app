import 'package:drift/drift.dart';

import '../database/database.dart';

class WorkoutRepository {
  final AppDatabase database;

  WorkoutRepository(this.database);

  Future<List<Workout>> getAllWorkouts() {
    return database.select(database.workouts).get();
  }

  Future<int> addWorkout({
    required String name,
  }) {
    return database.into(database.workouts).insert(
      WorkoutsCompanion.insert(
        name: name,
      ),
    );
  }
}
