import 'package:drift/drift.dart';

import 'workouts.dart';

class WorkoutDays extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId => integer()
      .references(Workouts, #id)();

  IntColumn get weekday => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {workoutId, weekday},
  ];
}