
import 'package:drift/drift.dart';

import 'exercises.dart';
import 'workouts.dart';

class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId => integer().references(Workouts, #id)();

  IntColumn get exerciseId => integer().references(Exercises, #id)();

  IntColumn get exerciseNumber => integer()();

  IntColumn get targetRest => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {workoutId, exerciseNumber},
  ];
}
