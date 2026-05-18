import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/filter_notifier.dart';
import '../application/search_results_notifier.dart';

class FiltersPanel extends ConsumerStatefulWidget {
  const FiltersPanel({super.key});

  @override
  ConsumerState<FiltersPanel> createState() => _FiltersPanelState();
}

class _FiltersPanelState extends ConsumerState<FiltersPanel> {
  static const double _sectionInset = 24;
  final TextEditingController _keywordsController = TextEditingController();
  final TextEditingController _nameEmailController = TextEditingController();
  final TextEditingController _affiliationController = TextEditingController();

  static const _pastRoleOptions = [
    'External Reviewer',
    'TPC Member',
    'Track Chair',
    'Area Chair',
    'Program Chair',
  ];

  @override
  void dispose() {
    _keywordsController.dispose();
    _nameEmailController.dispose();
    _affiliationController.dispose();
    super.dispose();
  }

  void _onKeywordChanged(String value) {
    if (!value.contains(',')) {
      return;
    }

    final lastCommaIndex = value.lastIndexOf(',');
    final completedPart = value.substring(0, lastCommaIndex);
    final remainder = value.substring(lastCommaIndex + 1).trimLeft();

    ref.read(filterProvider.notifier).addKeywordsFromCommaInput(completedPart);

    _keywordsController.value = TextEditingValue(
      text: remainder,
      selection: TextSelection.collapsed(offset: remainder.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    const panelBackground = Colors.white;
    const chipBackground = Color(0xFFE3E8EE);
    const chipText = Color(0xFF344054);
    const darkText = Color(0xFF0B1F3B);
    const seaBlue = Color(0xFF0D7EA2);
    final filterState = ref.watch(filterProvider);
    final keywords = filterState.keywords;

    return ColoredBox(
      color: panelBackground,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(_sectionInset, _sectionInset, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        color: darkText,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Clear filters',
                    onPressed: () {
                      ref.read(filterProvider.notifier).clearAll();
                      _keywordsController.clear();
                      _nameEmailController.clear();
                      _affiliationController.clear();
                    },
                    icon: const Icon(Icons.filter_alt_off_outlined),
                    color: darkText,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Keywords/Topics',
                style: TextStyle(
                  color: darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _keywordsController,
                onChanged: _onKeywordChanged,
                decoration: _inputDecoration(
                  hintText: 'e.g., graph neural networks, privacy',
                ),
              ),
              if (keywords.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: keywords
                      .map(
                        (keyword) => Chip(
                          label: Text(
                            keyword,
                            style: const TextStyle(color: chipText),
                          ),
                          backgroundColor: chipBackground,
                          side: BorderSide.none,
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            ref
                                .read(filterProvider.notifier)
                                .removeKeyword(keyword);
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 18),
              const Text(
                'Name / Email',
                style: TextStyle(
                  color: darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameEmailController,
                onChanged: ref.read(filterProvider.notifier).setNameOrEmail,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 18),
              const Text(
                'Affiliation',
                style: TextStyle(
                  color: darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _affiliationController,
                onChanged: ref.read(filterProvider.notifier).setAffiliation,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 18),
              const Text(
                'Past Roles',
                style: TextStyle(
                  color: darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ..._pastRoleOptions.map(
                (role) => CheckboxListTile(
                  value: filterState.pastRoles.contains(role),
                  onChanged: (value) {
                    ref
                        .read(filterProvider.notifier)
                        .togglePastRole(role, value ?? false);
                  },
                  title: Text(
                    role,
                    style: const TextStyle(
                      color: darkText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: seaBlue,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(searchResultsProvider.notifier)
                            .runSearch(filterState);
                      },
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Run Search'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: seaBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border, size: 18),
                      label: const Text('Save Preset'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: darkText,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: darkText, width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF667085)),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCAD1DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCAD1DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF0B1F3B), width: 1.3),
      ),
    );
  }
}
