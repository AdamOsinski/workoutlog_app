import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:workoutlog_app/database/database.dart';

void main() {
  test('Can insert and retrieve an exercise', () async {
    final db = AppDatabase(NativeDatabase.memory());

    // Insert a new exercise
    await db.into(db.exercises).insert(
      ExercisesCompanion.insert(
        name: 'Bench Press',
        resistanceType: 'BARBELL',
        bodypart: 'Chest',
      ),
    );

    // Retrieve the exercise
    final exercises = await db.select(db.exercises).get();

    // Verify the retrieved exercise
    expect(exercises.length, 1);
    expect(exercises.first.name, 'Bench Press');
    expect(exercises.first.resistanceType, 'BARBELL');
    expect(exercises.first.bodypart, 'Chest');

    await db.close();
  });
}