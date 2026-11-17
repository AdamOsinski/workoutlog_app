import 'package:flutter/material.dart';
import 'app/app.dart';
import 'database/database.dart';



/// Entry point of the application
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  final database = AppDatabase(); // Initialize the database
  runApp(WorkoutLogApp(database: database)); // Run the app and pass the database instance
}