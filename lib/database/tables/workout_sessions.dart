import 'package:drift/drift.dart';
import 'workouts.dart';

class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key, auto-incremented
  IntColumn get workoutId => integer()
      .references(Workouts, #id)(); // Foreign key referencing Workouts table
  DateTimeColumn get date => dateTime()(); // Date of the workout session
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))(); // Status of the workout session
}