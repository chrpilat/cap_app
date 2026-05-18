import 'package:flutter/material.dart';

class TpcInformationManagementScreen extends StatelessWidget {
  const TpcInformationManagementScreen({required this.conference, super.key});

  final String conference;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TPC information')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Upload/Edit TPC information for $conference.',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
