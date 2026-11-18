
import 'package:drift/drift.dart';

import 'workout_exercises.dart';

class WorkoutExerciseSets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutExerciseId =>
      integer().references(WorkoutExercises, #id)();

  IntColumn get setNumber => integer()();

  IntColumn get repMin => integer()();

  IntColumn get repMax => integer()();

  // Additional resistance in kg. Can be negative for assistance.
  RealColumn get targetAddedWeight =>
      real().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {workoutExerciseId, setNumber},
  ];
}
