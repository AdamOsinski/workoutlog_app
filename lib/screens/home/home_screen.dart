
import 'package:flutter/material.dart';

import '../../repositories/workout_repository.dart';
import '../workouts/workout_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final WorkoutRepository workoutRepository;

  const HomeScreen({
    super.key,
    required this.workoutRepository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      WorkoutListScreen(
        repository: widget.workoutRepository,
      ),
      const _PlaceholderScreen(
        title: 'Log',
        icon: Icons.history,
      ),
      const _PlaceholderScreen(
        title: 'Progress',
        icon: Icons.insights,
      ),
      const _PlaceholderScreen(
        title: 'Settings',
        icon: Icons.settings,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Log',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Icon(
          icon,
          size: 64,
        ),
      ),
    );
  }
}
