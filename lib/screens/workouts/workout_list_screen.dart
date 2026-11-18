import 'package:material_ui/material_ui.dart';

import '../../repositories/workout_repository.dart';
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
              onPressed: () {
                Navigator.pop(dialogContext);
              },
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

    if (!mounted) return;

    if (newName != null) {
      await widget.repository.addWorkout(name: newName);

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WorkoutLog'),
      ),
      body: FutureBuilder(
        future: widget.repository.getAllWorkouts(),
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
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];

              return ListTile(
                title: Text(workout.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutDetailsScreen(
                        workout: workout,
                        repository: widget.repository,
                      ),
                    ),
                  ).then((_) {
                    if (mounted) {
                      setState(() {});
                    }
                  });
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