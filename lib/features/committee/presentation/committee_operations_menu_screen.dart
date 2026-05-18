import 'package:flutter/material.dart';

import '../../shared/presentation/action_card.dart';
import 'home_screen.dart';
import 'tpc_information_management_screen.dart';

class CommitteeOperationsMenuScreen extends StatefulWidget {
  const CommitteeOperationsMenuScreen({super.key});

  @override
  State<CommitteeOperationsMenuScreen> createState() =>
      _CommitteeOperationsMenuScreenState();
}

class _CommitteeOperationsMenuScreenState
    extends State<CommitteeOperationsMenuScreen> {
  static const List<String> _conferences = [
    'ICML 2026',
    'NeurIPS 2026',
    'ICLR 2027',
    'AAAI 2027',
  ];

  String? _selectedConference;

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0B1F3B);
    final canProceed =
        _selectedConference != null && _selectedConference!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text('Committee operations')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select conference and action',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<String>(
                  initialValue: _selectedConference,
                  items: _conferences
                      .map(
                        (conference) => DropdownMenuItem<String>(
                          value: conference,
                          child: Text(conference),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedConference = value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Conference',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ActionCard(
                        icon: Icons.search_outlined,
                        title: 'Search TPC member',
                        description: 'Search and inspect TPC members.',
                        onTap: canProceed
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => HomeScreen(
                                      showBackButton: true,
                                      selectedConference: _selectedConference!,
                                    ),
                                  ),
                                );
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Select a conference before continuing.',
                                    ),
                                  ),
                                );
                              },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ActionCard(
                        icon: Icons.edit_note_outlined,
                        title: 'Upload/Edit TPC information',
                        description:
                            'Load, update, and maintain TPC information.',
                        onTap: canProceed
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TpcInformationManagementScreen(
                                          conference: _selectedConference!,
                                        ),
                                  ),
                                );
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Select a conference before continuing.',
                                    ),
                                  ),
                                );
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
