import 'package:flutter/material.dart';
import 'theme.dart';

// The main application widget
class WorkoutLogApp extends StatelessWidget {
  const WorkoutLogApp({super.key});
  
  // Builds the widget tree for the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkoutLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('WorkoutLog'),
        ),
      ),
    );
  }
}