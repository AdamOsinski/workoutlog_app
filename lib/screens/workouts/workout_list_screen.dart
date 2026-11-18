
import 'package:material_ui/material_ui.dart';

import '../../repositories/workout_repository.dart';
import '../../widgets/workout_card.dart';
import 'workout_details_screen.dart';

class WorkoutListScreen extends StatefulWidget {
  final WorkoutRepository repository;

  const WorkoutListScreen({
    super.key,
    required this.repository,
  });

  @override
  State<WorkoutListScreen> createState() =>
      _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  late Future<List<_WorkoutCardData>> _workoutsFuture;

  @override
  void initState() {
    super.initState();
    _refreshWorkouts();
  }

  void _refreshWorkouts() {
    _workoutsFuture = _loadWorkoutCards();
  }

  Future<List<_WorkoutCardData>> _loadWorkoutCards() async {
    final workouts = await widget.repository.getAllWorkouts();
    final exercises = await widget.repository.getAllExercises();

    final result = <_WorkoutCardData>[];

    for (final workout in workouts) {
      final workoutExercises =
          await widget.repository.getWorkoutExercises(workout.id);

      final scheduledDays =
          await widget.repository.getWorkoutDays(workout.id);

      final cardExercises = workoutExercises.map((item) {
        final exercise = exercises.firstWhere(
          (exercise) => exercise.id == item.exerciseId,
        );

        return WorkoutExerciseItem(
          name: exercise.name,
          sets: item.targetSets,
          reps: item.targetReps,
          rest: item.targetRest,
        );
      }).toList();

      result.add(
        _WorkoutCardData(
          id: workout.id,
          name: workout.name,
          scheduledDays: scheduledDays,
          exercises: cardExercises,
        ),
      );
    }

    return result;
  }

  Future<void> _createWorkout() async {
    final formKey = GlobalKey<FormState>();
    String name = '';

    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Workout'),
          content: Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Workout name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                name = value!.trim();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.pop(dialogContext, name);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted || newName == null) return;

    await widget.repository.addWorkout(name: newName);

    if (mounted) {
      setState(_refreshWorkouts);
    }
  }

  Future<void> _openWorkout(int workoutId) async {
    final workouts = await widget.repository.getAllWorkouts();

    if (!mounted) return;

    final workout = workouts.firstWhere(
      (item) => item.id == workoutId,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailsScreen(
          workout: workout,
          repository: widget.repository,
        ),
      ),
    );

    if (mounted) {
      setState(_refreshWorkouts);
    }
  }

  Future<void> _deleteWorkout(_WorkoutCardData workout) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Workout?'),
          content: Text(
            'Are you sure you want to delete "${workout.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final deleted =
        await widget.repository.deleteWorkout(workout.id);

    if (!mounted) return;

    if (deleted) {
      setState(_refreshWorkouts);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This workout has training history and cannot be deleted.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<_WorkoutCardData>>(
        future: _workoutsFuture,
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

          final workouts = snapshot.data ?? [];

          if (workouts.isEmpty) {
            return const Center(
              child: Text('No workouts yet.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];

              return WorkoutCard(
                workoutName: workout.name,
                scheduledDays: workout.scheduledDays,
                exercises: workout.exercises,
                onEdit: () => _openWorkout(workout.id),
                onAdd: () => _openWorkout(workout.id),
                onDelete: () => _deleteWorkout(workout),
                onStart: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Live workouts are coming next.'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkout,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _WorkoutCardData {
  final int id;
  final String name;
  final List<int> scheduledDays;
  final List<WorkoutExerciseItem> exercises;

  const _WorkoutCardData({
    required this.id,
    required this.name,
    required this.scheduledDays,
    required this.exercises,
  });
}
