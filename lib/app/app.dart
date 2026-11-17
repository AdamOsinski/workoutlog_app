import 'package:flutter/material.dart';

import '../database/database.dart';
import '../repositories/exercise_repository.dart';
import 'theme.dart';
import '../screens/exercises/exercise_list_screen.dart';

// The main application widget
class WorkoutLogApp extends StatelessWidget {
  final AppDatabase database;
  final ExerciseRepository exerciseRepository;

  WorkoutLogApp({
    super.key,
    required this.database
  }): exerciseRepository = ExerciseRepository(database);

  // Builds the widget tree for the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkoutLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ExerciseListScreen(
        repository: exerciseRepository,
      ),
    );
  }
}