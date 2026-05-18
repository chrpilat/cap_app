import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = 'https://uowewrduqobdmndixqas.supabase.co';
  const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVvd2V3cmR1cW9iZG1uZGl4cWFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIzMTI0NzYsImV4cCI6MjA4Nzg4ODQ3Nn0.RwGhyug9zmQirz2bgsdvQIremvomhJYKpUI8_eT5C84';
  final hasSupabaseConfig =
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  if (hasSupabaseConfig) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  runApp(
    ProviderScope(
      child: ConferenceArchivePlatformApp(hasSupabaseConfig: hasSupabaseConfig),
    ),
  );
}
