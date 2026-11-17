import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../repositories/workout_repository.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final Workout workout;
  final WorkoutRepository repository;

  const WorkoutDetailsScreen({
    super.key,
    required this.workout,
    required this.repository,
  });

  @override
  State<WorkoutDetailsScreen> createState() =>
      _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState
    extends State<WorkoutDetailsScreen> {
  Future<void> _addExercise() async {
    final exercises =
        await widget.repository.getAllExercises();

    if (!mounted) return;

    if (exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create an exercise first.'),
        ),
      );
      return;
    }

    int? selectedExerciseId = exercises.first.id;
    int targetSets = 3;
    int targetReps = 10;
    int targetRest = 90;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Exercise'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedExerciseId,
                      decoration: const InputDecoration(
                        labelText: 'Exercise',
                      ),
                      items: exercises.map((exercise) {
                        return DropdownMenuItem(
                          value: exercise.id,
                          child: Text(exercise.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedExerciseId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: '$targetSets',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Target sets',
                      ),
                      onChanged: (value) {
                        targetSets =
                            int.tryParse(value) ?? targetSets;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: '$targetReps',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Target reps',
                      ),
                      onChanged: (value) {
                        targetReps =
                            int.tryParse(value) ?? targetReps;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: '$targetRest',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Rest (seconds)',
                      ),
                      onChanged: (value) {
                        targetRest =
                            int.tryParse(value) ?? targetRest;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedExerciseId != null &&
                        targetSets > 0 &&
                        targetReps > 0 &&
                        targetRest >= 0) {
                      Navigator.pop(dialogContext, true);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true || !mounted) return;

    await widget.repository.addExerciseToWorkout(
      workoutId: widget.workout.id,
      exerciseId: selectedExerciseId!,
      targetSets: targetSets,
      targetReps: targetReps,
      targetRest: targetRest,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: FutureBuilder(
        future: widget.repository.getWorkoutExercises(
          widget.workout.id,
        ),
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

          final workoutExercises = snapshot.data ?? [];

          if (workoutExercises.isEmpty) {
            return const Center(
              child: Text('No exercises in this workout yet.'),
            );
          }

          return FutureBuilder(
            future: widget.repository.getAllExercises(),
            builder: (context, exerciseSnapshot) {
              if (!exerciseSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final exercises = exerciseSnapshot.data!;

              return ListView.builder(
                itemCount: workoutExercises.length,
                itemBuilder: (context, index) {
                  final workoutExercise =
                      workoutExercises[index];

                  final exercise = exercises.firstWhere(
                    (item) =>
                        item.id == workoutExercise.exerciseId,
                  );

                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(
                      '${workoutExercise.targetSets} sets × '
                      '${workoutExercise.targetReps} reps'
                      ' • ${workoutExercise.targetRest}s rest',
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}