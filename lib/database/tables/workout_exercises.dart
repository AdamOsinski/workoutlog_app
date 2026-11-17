import 'package:drift/drift.dart';
import 'exercises.dart';
import 'workouts.dart';

class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key, auto-incremented
  IntColumn get workoutId => integer()
    .references(Workouts, #id)(); // Foreign key referencing Workouts table
  IntColumn get exerciseId => integer()
    .references(Exercises, #id)(); // Foreign key referencing Exercises table
  IntColumn get exerciseNumber => integer()(); // Number of sets for the exercise in the workout
  IntColumn get targetSets => integer()(); // Number of repetitions for the exercise in the workout
  IntColumn get targetReps => integer()(); // Number of repetitions for the exercise in the workout
  IntColumn get targetRest => integer()(); // Target weight for the exercise in the workout

  @override
  List<Set<Column>> get uniqueKeys => [
        {workoutId, exerciseNumber}, // Ensure that each exercise is unique within a workout
      ];
}