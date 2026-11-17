import 'package:drift/drift.dart';
import 'workout_sessions.dart';
import 'workout_exercises.dart';

class SetResults extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key, auto-incremented
  IntColumn get sessionId => integer()
      .references(WorkoutSessions, #id)(); // Foreign key referencing WorkoutSessions table
  IntColumn get workoutExerciseId => integer()
      .references(WorkoutExercises, #id)(); // Foreign key referencing WorkoutExercises table
  IntColumn get setNumber => integer()(); // Number of the set for the exercise in the workout session
  RealColumn get resistance => real()(); // Actual resistance used for the set
  IntColumn get reps => integer()(); // Actual number of repetitions completed for the set

  @override
  List<Set<Column>> get uniqueKeys => [
        {sessionId, workoutExerciseId, setNumber}, // Ensure that each set is unique within a workout session and exercise
      ];
}