
import 'package:material_ui/material_ui.dart';

class WorkoutExerciseItem {
  final String name;
  final int sets;
  final int reps;
  final int rest;

  const WorkoutExerciseItem({
    required this.name,
    required this.sets,
    required this.reps,
    required this.rest,
  });
}

class WorkoutCard extends StatelessWidget {
  final String workoutName;
  final List<int> scheduledDays;
  final List<WorkoutExerciseItem> exercises;

  final VoidCallback onEdit;
  final VoidCallback onAdd;
  final VoidCallback onDelete;
  final VoidCallback onStart;

  const WorkoutCard({
    super.key,
    required this.workoutName,
    required this.scheduledDays,
    required this.exercises,
    required this.onEdit,
    required this.onAdd,
    required this.onDelete,
    required this.onStart,
  });

  static const List<String> weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout name and action buttons
            Row(
              children: [
                Expanded(
                  child: Text(
                    workoutName,
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_box_outlined),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Weekday indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final day = index + 1;
                final isScheduled = scheduledDays.contains(day);

                return Text(
                  weekdays[index],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isScheduled
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isScheduled
                        ? colors.primary
                        : colors.onSurface,
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Exercise table
            Row(
              children: const [
                Expanded(flex: 3, child: Text('Exercise')),
                Expanded(flex: 2, child: Text('Sets')),
                Expanded(flex: 2, child: Text('Reps')),
                Expanded(flex: 2, child: Text('Weight')),
                Expanded(flex: 2, child: Text('Rest')),
              ],
            ),

            const SizedBox(height: 8),

            ...exercises.map((exercise) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        exercise.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('${exercise.sets}'),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('${exercise.reps}'),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text('—'),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('${exercise.rest}s'),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Start button
            Center(
              child: SizedBox(
                width: 120,
                child: FilledButton(
                  onPressed: onStart,
                  child: const Text('Start'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
