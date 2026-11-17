
import 'package:flutter/material.dart';

import '../../repositories/exercise_repository.dart';
import 'create_exercise_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  final ExerciseRepository repository;

  const ExerciseListScreen({
    super.key,
    required this.repository,
  });

  @override
  State<ExerciseListScreen> createState() =>
      _ExerciseListScreenState();
}

class _ExerciseListScreenState
    extends State<ExerciseListScreen> {

  Future<void> _renameExercise(
  int id,
  String currentName,
) async {
  final newName = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      final controller =
          TextEditingController(text: currentName);

      return AlertDialog(
        title: const Text('Rename Exercise'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Exercise name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                controller.text.trim(),
              );
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );

  if (!mounted) return;

  if (newName != null && newName.isNotEmpty) {
    await widget.repository.renameExercise(
      id: id,
      newName: newName,
    );

    if (mounted) {
      setState(() {});
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),

      body: FutureBuilder(
        future: widget.repository.getAllExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
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
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _renameExercise(
                      exercise.id,
                      exercise.name,
                    );
                  },
                ),
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
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
