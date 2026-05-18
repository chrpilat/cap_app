import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/search_results_notifier.dart';
import '../domain/search_result.dart';
import '../domain/search_results_state.dart';

class SearchResultsPanel extends ConsumerWidget {
  const SearchResultsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const darkText = Color(0xFF0B1F3B);
    final state = ref.watch(searchResultsProvider);
    final selectedProfile = state.selectedProfileName == null
        ? null
        : _findByName(state.results, state.selectedProfileName!);

    if (!state.hasRunSearch) {
      return const ColoredBox(color: Color(0xFFF5F7FA), child: SizedBox.expand());
    }

    return ColoredBox(
      color: const Color(0xFFF5F7FA),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${state.results.length} Results',
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Sort by:',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<SearchSortBy>(
                  value: state.sortBy,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    ref.read(searchResultsProvider.notifier).setSortBy(value);
                  },
                  items: const [
                    DropdownMenuItem(
                      value: SearchSortBy.matchDesc,
                      child: Text('Best Match'),
                    ),
                    DropdownMenuItem(
                      value: SearchSortBy.nameAsc,
                      child: Text('Name A-Z'),
                    ),
                    DropdownMenuItem(
                      value: SearchSortBy.affiliationAsc,
                      child: Text('Affiliation A-Z'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (selectedProfile != null) ...[
              _ProfileDetailCard(
                result: selectedProfile,
                onClose: () {
                  ref.read(searchResultsProvider.notifier).clearSelectedProfile();
                },
              ),
              const SizedBox(height: 14),
            ],
            _TableHeader(),
            Expanded(
              child: ListView.separated(
                itemCount: state.results.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: Color(0xFFD7DDE5)),
                itemBuilder: (context, index) {
                  final result = state.results[index];
                  return _ResultRow(
                    name: result.name,
                    affiliation: result.affiliation,
                    topics: result.topics.join(', '),
                    match: result.matchScore,
                    onMoreInfo: () {
                      ref
                          .read(searchResultsProvider.notifier)
                          .selectProfile(result.name);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFFE4EAF1);
    const textStyle = TextStyle(
      color: Color(0xFF344054),
      fontWeight: FontWeight.w700,
      fontSize: 13,
    );

    return Container(
      color: headerColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Name', style: textStyle)),
          Expanded(flex: 2, child: Text('Affiliation', style: textStyle)),
          Expanded(flex: 3, child: Text('Topics', style: textStyle)),
          Expanded(flex: 2, child: Text('Match', style: textStyle)),
          Expanded(flex: 2, child: Text('Actions', style: textStyle)),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.name,
    required this.affiliation,
    required this.topics,
    required this.match,
    required this.onMoreInfo,
  });

  final String name;
  final String affiliation;
  final String topics;
  final double match;
  final VoidCallback onMoreInfo;

  @override
  Widget build(BuildContext context) {
    const darkText = Color(0xFF0B1F3B);
    const seaBlue = Color(0xFF0D7EA2);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              affiliation,
              style: const TextStyle(color: darkText, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              topics,
              style: const TextStyle(color: darkText, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: match,
                      backgroundColor: const Color(0xFFDCE3EB),
                      valueColor: const AlwaysStoppedAnimation<Color>(seaBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(match * 100).round()}%',
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onMoreInfo,
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('More info'),
                  style: TextButton.styleFrom(
                    foregroundColor: seaBlue,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Actions',
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, size: 18),
                  color: const Color(0xFF475467),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailCard extends StatelessWidget {
  const _ProfileDetailCard({required this.result, required this.onClose});

  final SearchResult result;
  final VoidCallback onClose;

  static const _roleColorByName = <String, Color>{
    'External Reviewer': Color(0xFFE9F5FF),
    'TPC Member': Color(0xFFEAF7F0),
    'Track Chair': Color(0xFFFFF5E8),
    'Area Chair': Color(0xFFF3EEFF),
    'Program Chair': Color(0xFFFFECF1),
  };

  static const _roleTextColorByName = <String, Color>{
    'External Reviewer': Color(0xFF1D4E89),
    'TPC Member': Color(0xFF19683B),
    'Track Chair': Color(0xFF9A5A00),
    'Area Chair': Color(0xFF5B3AA5),
    'Program Chair': Color(0xFF9B1C47),
  };

  @override
  Widget build(BuildContext context) {
    const darkText = Color(0xFF0B1F3B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1D8E0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x110B1F3B),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.affiliation,
                      style: const TextStyle(
                        color: Color(0xFF475467),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Close details',
                onPressed: onClose,
                icon: const Icon(Icons.close),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Topics',
            style: TextStyle(
              color: darkText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: result.topics
                .map(
                  (topic) => Chip(
                    label: Text(topic),
                    backgroundColor: const Color(0xFFE9EDF3),
                    side: BorderSide.none,
                    labelStyle: const TextStyle(
                      color: Color(0xFF344054),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          const Text(
            'Conference Participation',
            style: TextStyle(
              color: darkText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: result.conferences.map((item) {
              final color = _roleColorByName[item.role] ?? const Color(0xFFE9EDF3);
              final textColor =
                  _roleTextColorByName[item.role] ?? const Color(0xFF344054);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: textColor.withOpacity(0.22)),
                ),
                child: Text(
                  '${item.conference} - ${item.role} (${item.completedReviews}/${item.assignedReviews})',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

SearchResult? _findByName(List<SearchResult> results, String name) {
  for (final result in results) {
    if (result.name == name) {
      return result;
    }
  }
  return null;
}
