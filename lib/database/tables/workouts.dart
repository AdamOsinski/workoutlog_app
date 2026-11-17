import 'package:drift/drift.dart';

class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key, auto-incremented
  TextColumn get name => text()(); // Name of the workout
}