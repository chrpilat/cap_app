import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../committee/presentation/committee_operations_menu_screen.dart';
import '../personal_history/presentation/personal_role_history_screen.dart';
import '../shared/presentation/action_card.dart';

class PostLoginMenuScreen extends StatelessWidget {
  const PostLoginMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0B1F3B);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select an action',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Choose what you want to do in this session.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF4A5568)),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ActionCard(
                        icon: Icons.history_edu_outlined,
                        title: 'View personal role history',
                        description:
                            'Open your historical roles and participation timeline.',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PersonalRoleHistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ActionCard(
                        icon: Icons.groups_2_outlined,
                        title: 'Committee operations',
                        description:
                            'Manage and review committee workflows and data.',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CommitteeOperationsMenuScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async =>
                      Supabase.instance.client.auth.signOut(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
