
import 'package:material_ui/material_ui.dart';

import '../../database/database.dart';
import '../../repositories/workout_repository.dart';
import '../../repositories/exercise_repository.dart';
import '../exercises/create_exercise_screen.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final Workout workout;
  final WorkoutRepository repository;
  final ExerciseRepository exerciseRepository;

  const WorkoutDetailsScreen({
    super.key,
    required this.workout,
    required this.repository,
    required this.exerciseRepository,
  });

  @override
  State<WorkoutDetailsScreen> createState() =>
      _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState
    extends State<WorkoutDetailsScreen> {
  late Future<List<_WorkoutExerciseDetails>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _refreshExercises();
  }

  void _refreshExercises() {
    _detailsFuture = _loadExercises();
  }

  Future<List<_WorkoutExerciseDetails>> _loadExercises() async {
    final workoutExercises =
        await widget.repository.getWorkoutExercises(
      widget.workout.id,
    );

    final exercises =
        await widget.repository.getAllExercises();

    final result = <_WorkoutExerciseDetails>[];

    for (final workoutExercise in workoutExercises) {
      final exercise = exercises.firstWhere(
        (item) => item.id == workoutExercise.exerciseId,
      );

      final sets =
          await widget.repository.getWorkoutExerciseSets(
        workoutExercise.id,
      );

      result.add(
        _WorkoutExerciseDetails(
          name: exercise.name,
          rest: workoutExercise.targetRest,
          sets: sets,
        ),
      );
    }

    return result;
  }

  Future<void> _addExercise() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Select existing exercise'),
              onTap: () => Navigator.pop(context, 'existing'),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Create new exercise'),
              onTap: () => Navigator.pop(context, 'new'),
            ),
          ],
        ),
      ),
    );

    if (!mounted || choice == null) return;

    if (choice == 'new') {
      final exerciseId = await Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (context) => CreateExerciseScreen(
            repository: widget.exerciseRepository,
          ),
        ),
      );

      if (exerciseId == null || !mounted) return;

      await widget.repository.addExerciseToWorkout(
        workoutId: widget.workout.id,
        exerciseId: exerciseId,
        targetSets: 3,
        targetReps: 10,
        targetRest: 90,
      );

      if (mounted) {
        setState(_refreshExercises);
      }
      return;
    }

    if (choice == 'existing') {
      await _selectExistingExercise();
    }
  }

  Future<void> _selectExistingExercise() async {
  final exercises =
      await widget.exerciseRepository.getAllExercises();

  if (!mounted) return;

  if (exercises.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No exercises found. Create one first.'),
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
            title: const Text('Select Exercise'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: selectedExerciseId,
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
                      targetSets = int.tryParse(value) ?? 0;
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
                      targetReps = int.tryParse(value) ?? 0;
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
                      targetRest = int.tryParse(value) ?? -1;
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
    setState(_refreshExercises);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: FutureBuilder<List<_WorkoutExerciseDetails>>(
        future: _detailsFuture,
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

          return ListView.builder(
            itemCount: workoutExercises.length,
            itemBuilder: (context, index) {
              final item = workoutExercises[index];

              final setSummary = item.sets.isEmpty
                  ? 'No sets planned'
                  : item.sets.map((set) {
                      if (set.repMin == set.repMax) {
                        return '${set.repMin} reps';
                      }
                      return '${set.repMin}–${set.repMax} reps';
                    }).join(', ');

              return ListTile(
                title: Text(item.name),
                subtitle: Text(
                  '$setSummary • ${item.rest}s rest',
                ),
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

class _WorkoutExerciseDetails {
  final String name;
  final int rest;
  final List<WorkoutExerciseSet> sets;

  const _WorkoutExerciseDetails({
    required this.name,
    required this.rest,
    required this.sets,
  });
}
