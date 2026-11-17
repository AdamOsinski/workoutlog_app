import 'package:flutter/material.dart';
import 'theme.dart';

class WorkoutLogApp extends StatelessWidget {
  const WorkoutLogApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkoutLog App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('WorkoutLog App'),
        ),
      ),
    );
  }
}