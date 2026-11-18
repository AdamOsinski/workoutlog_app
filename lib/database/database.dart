import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/exercises.dart';
import 'tables/workouts.dart';
import 'tables/workout_exercises.dart';
import 'tables/workout_sessions.dart';
import 'tables/set_results.dart';
import 'tables/bodyweight.dart';
import 'tables/workout_days.dart';
import 'tables/workout_exercise_sets.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Exercises,
    Workouts,
    WorkoutExercises,
    WorkoutExerciseSets,
    WorkoutSessions,
    SetResults,
    Bodyweight,
    WorkoutDays
  ],
)

class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
   : super(executor ?? _openConnection()); // allows for in-memory database for testing

  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      await m.deleteTable('set_results');
      await m.deleteTable('workout_exercise_sets');
      await m.deleteTable('workout_exercises');
      await m.deleteTable('workout_days');
      await m.deleteTable('workout_sessions');
      await m.deleteTable('workouts');
      await m.deleteTable('exercises');
      await m.deleteTable('bodyweights');

      await m.createAll();
    },
  );


  @override
  int get schemaVersion => 3; // Increment this number whenever you change the database schema
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(dbFolder.path, 'workoutlog.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
