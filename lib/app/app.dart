import 'package:flutter/material.dart';

import '../database/database.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/workout_repository.dart';
import '../screens/workouts/workout_list_screen.dart';
import 'theme.dart';

class WorkoutLogApp extends StatelessWidget {
  final AppDatabase database;
  final ExerciseRepository exerciseRepository;
  final WorkoutRepository workoutRepository;

  WorkoutLogApp({
    super.key,
    required this.database,
  })  : exerciseRepository = ExerciseRepository(database),
        workoutRepository = WorkoutRepository(database);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: WorkoutListScreen(
        repository: workoutRepository,
      ),
    );
  }
}