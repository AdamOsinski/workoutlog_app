import 'package:drift/drift.dart';

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key, auto-incremented
  TextColumn get name => text()(); // Name of the exercise
  TextColumn get resistanceType => text()(); // Type of resistance for the exercise
}