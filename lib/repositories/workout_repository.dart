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

  // Get all exercises available in the exercise library.
  Future<List<Exercise>> getAllExercises() {
    return database.select(database.exercises).get();
  }

  // Get all exercises assigned to a specific workout.
  Future<List<WorkoutExercise>> getWorkoutExercises(
    int workoutId,
  ) {
    return (database.select(database.workoutExercises)
          ..where((table) => table.workoutId.equals(workoutId))
          ..orderBy([
            (table) => OrderingTerm.asc(table.exerciseNumber),
          ]))
        .get();
  }

  // Add an existing exercise to a workout.
  Future<int> addExerciseToWorkout({
    required int workoutId,
    required int exerciseId,
    required int targetSets,
    required int targetReps,
    required int targetRest,
  }) async {
    final existingExercises =
        await getWorkoutExercises(workoutId);

    return database.into(database.workoutExercises).insert(
      WorkoutExercisesCompanion.insert(
        workoutId: workoutId,
        exerciseId: exerciseId,
        exerciseNumber: existingExercises.length + 1,
        targetSets: targetSets,
        targetReps: targetReps,
        targetRest: targetRest,
      ),
    );
  }
}