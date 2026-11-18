
import 'package:drift/drift.dart';

import 'workout_sessions.dart';
import 'workout_exercises.dart';

class SetResults extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId =>
      integer().references(WorkoutSessions, #id)();

  IntColumn get workoutExerciseId =>
      integer().references(WorkoutExercises, #id)();

  IntColumn get setNumber => integer()();

  // Actual additional resistance in kg.
  // Negative values represent assistance.
  RealColumn get actualAddedWeight =>
      real().withDefault(const Constant(0))();

  // The equipment/bodyweight baseline at the time of the set.
  RealColumn get baseResistanceSnapshot => real()();

  IntColumn get reps => integer()();

  IntColumn get actualRest => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sessionId, workoutExerciseId, setNumber},
  ];
}
