import 'package:flutter/material.dart';

class PersonalRoleHistoryScreen extends StatelessWidget {
  const PersonalRoleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal role history')),
      body: const Center(
        child: Text(
          'Your personal role history will be shown here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
