import 'package:flutter/material.dart';

import '../features/auth/presentation/auth_gate.dart';

class ConferenceArchivePlatformApp extends StatelessWidget {
  const ConferenceArchivePlatformApp({
    required this.hasSupabaseConfig,
    super.key,
  });

  final bool hasSupabaseConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conference Archive Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B1F3B)),
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home:
          hasSupabaseConfig
              ? const AuthGate()
              : const MissingSupabaseConfigScreen(),
    );
  }
}

class MissingSupabaseConfigScreen extends StatelessWidget {
  const MissingSupabaseConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Set SUPABASE_URL and SUPABASE_ANON_KEY in main.dart to enable login.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
