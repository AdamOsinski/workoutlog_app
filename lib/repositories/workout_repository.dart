
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

  // Get all planned sets for a workout exercise.
  Future<List<WorkoutExerciseSet>> getWorkoutExerciseSets(
    int workoutExerciseId,
  ) {
    return (database.select(database.workoutExerciseSets)
          ..where(
            (table) =>
                table.workoutExerciseId.equals(workoutExerciseId),
          )
          ..orderBy([
            (table) => OrderingTerm.asc(table.setNumber),
          ]))
        .get();
  }

  // Add an exercise and create its initial planned sets.
  Future<int> addExerciseToWorkout({
    required int workoutId,
    required int exerciseId,
    required int targetSets,
    required int targetReps,
    required int targetRest,
  }) async {
    final existingExercises =
        await getWorkoutExercises(workoutId);

    return database.transaction(() async {
      final workoutExerciseId =
          await database.into(database.workoutExercises).insert(
        WorkoutExercisesCompanion.insert(
          workoutId: workoutId,
          exerciseId: exerciseId,
          exerciseNumber: existingExercises.length + 1,
          targetRest: targetRest,
        ),
      );

      await database.batch((batch) {
        batch.insertAll(
          database.workoutExerciseSets,
          List.generate(targetSets, (index) {
            return WorkoutExerciseSetsCompanion.insert(
              workoutExerciseId: workoutExerciseId,
              setNumber: index + 1,
              repMin: targetReps,
              repMax: targetReps,
            );
          }),
        );
      });

      return workoutExerciseId;
    });
  }

  // Get the scheduled weekdays for a workout.
  Future<List<int>> getWorkoutDays(int workoutId) async {
    final rows = await (database.select(database.workoutDays)
          ..where((table) => table.workoutId.equals(workoutId))
          ..orderBy([
            (table) => OrderingTerm.asc(table.weekday),
          ]))
        .get();

    return rows.map((row) => row.weekday).toList();
  }

  // Replace the weekday schedule for a workout.
  Future<void> setWorkoutDays({
    required int workoutId,
    required List<int> weekdays,
  }) async {
    if (weekdays.any((day) => day < 1 || day > 7)) {
      throw ArgumentError('Weekdays must be between 1 and 7.');
    }

    final uniqueDays = weekdays.toSet().toList();

    await database.transaction(() async {
      await (database.delete(database.workoutDays)
            ..where((table) => table.workoutId.equals(workoutId)))
          .go();

      if (uniqueDays.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.workoutDays,
            uniqueDays.map((day) {
              return WorkoutDaysCompanion.insert(
                workoutId: workoutId,
                weekday: day,
              );
            }).toList(),
          );
        });
      }
    });
  }

  // Delete a workout only if it has no training history.
  Future<bool> deleteWorkout(int workoutId) async {
    final sessions = await (database.select(database.workoutSessions)
          ..where((table) => table.workoutId.equals(workoutId)))
        .get();

    if (sessions.isNotEmpty) {
      return false;
    }

    await database.transaction(() async {
      final exercises = await getWorkoutExercises(workoutId);

      for (final exercise in exercises) {
        await (database.delete(database.workoutExerciseSets)
              ..where(
                (table) => table.workoutExerciseId.equals(exercise.id),
              ))
            .go();
      }

      await (database.delete(database.workoutExercises)
            ..where((table) => table.workoutId.equals(workoutId)))
          .go();

      await (database.delete(database.workoutDays)
            ..where((table) => table.workoutId.equals(workoutId)))
          .go();

      await (database.delete(database.workouts)
            ..where((table) => table.id.equals(workoutId)))
          .go();
    });

    return true;
  }
}
