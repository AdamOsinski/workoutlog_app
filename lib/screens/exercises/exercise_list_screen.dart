import 'package:flutter/material.dart';

import '../../repositories/exercise_repository.dart';
import 'create_exercrise_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  final ExerciseRepository repository; // access to the exercise repository for fetching exercises from the database

  const ExerciseListScreen({
    super.key,
    required this.repository,
  });

  @override
  State<ExerciseListScreen> createState() =>
  _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {

  @override
  Widget build(BuildContext context) { // Builds the widget tree for the exercise list screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),

      body: FutureBuilder(
        future: widget.repository.getAllExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }

          final exercises = snapshot.data ?? [];

          if (exercises.isEmpty) {
            return const Center(
              child: Text('No exercises yet.'),
            );
          }

          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];

              return ListTile(
                title: Text(exercise.name),
                subtitle: Text(exercise.resistanceType),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => CreateExerciseScreen(
                repository: widget.repository,
              ),
            ),
          );

          if (result == true && context.mounted) {
            setState(() {}); // Refresh the list after returning from the create exercise screen
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}