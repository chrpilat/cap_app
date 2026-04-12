import 'package:flutter/material.dart';

import '../features/filters/presentation/filters_panel.dart';
import '../features/search/presentation/search_results_panel.dart';

class ConferenceArchivePlatformApp extends StatelessWidget {
  const ConferenceArchivePlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conference Archive Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B1F3B)),
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0B1F3B);
    const seaBlue = Color(0xFF0D7EA2);

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Conference Archive Platform',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.upload_file_outlined,
                            size: 18,
                          ),
                          label: const Text('Import CSV'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: darkBlue,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: darkBlue, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download_outlined, size: 18),
                          label: const Text('Export CSV'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: darkBlue,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: darkBlue, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.groups_2_outlined, size: 18),
                          label: const Text('TPC Members'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: seaBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(height: 1.5, color: const Color(0xFF8A95A6)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: FiltersPanel(),
                  ),
                ),
                SizedBox(
                  width: 1.5,
                  child: ColoredBox(color: Color(0xFFD1D8E0)),
                ),
                Expanded(flex: 3, child: SearchResultsPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
