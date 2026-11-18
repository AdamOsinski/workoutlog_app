import 'package:drift/drift.dart';

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get resistanceType => text()();

  // Fixed equipment resistance in kg.
  // Null for exercises that use bodyweight as their baseline.
  RealColumn get baseResistance => real().nullable()();

  TextColumn get bodypart => text()();
}