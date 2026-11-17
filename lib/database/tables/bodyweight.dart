import 'package:drift/drift.dart';

class Bodyweight extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key, auto-incremented
  DateTimeColumn get date => dateTime()(); // Date of the bodyweight exercise
  RealColumn get weight => real()(); // Weight used for the bodyweight exercise
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {date}, // Ensure that each bodyweight entry is unique by date
  ];
}