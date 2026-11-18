import 'package:material_ui/material_ui.dart';

import '../../models/resistance_type.dart';
import '../../repositories/exercise_repository.dart';

class CreateExerciseScreen extends StatefulWidget {
  final ExerciseRepository repository;

  const CreateExerciseScreen({
    super.key,
    required this.repository
  });

  @override
  State<CreateExerciseScreen> createState() =>
  _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  final _nameController = TextEditingController();

  ResistanceType _selectedType = ResistanceType.bodyweight;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _typeToString(ResistanceType type) {
    return type.name.toUpperCase();
  }

  Future<void> _saveExercise() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    await widget.repository.addExercise(
      name: name,
      resistanceType: _typeToString(_selectedType),
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<ResistanceType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Resistance type',
                border: OutlineInputBorder(),
              ),
              items: ResistanceType.values.map((type) {
                return DropdownMenuItem(value: type, child: Text(type.name));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveExercise,
                child: const Text('Save Exercise'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
