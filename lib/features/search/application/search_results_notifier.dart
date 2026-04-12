import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../filters/domain/filter_state.dart';
import '../domain/search_result.dart';
import '../domain/search_results_state.dart';

final searchResultsProvider =
    StateNotifierProvider<SearchResultsNotifier, SearchResultsState>(
      (ref) => SearchResultsNotifier(),
    );

class SearchResultsNotifier extends StateNotifier<SearchResultsState> {
  SearchResultsNotifier() : super(const SearchResultsState());

  static const _mockResults = <SearchResult>[
    SearchResult(
      name: 'Arianna Romano',
      affiliation: 'Politecnico di Milano',
      topics: ['graph neural networks', 'privacy', 'federated learning'],
      matchScore: 0.71,
      roles: {'TPC Member', 'External Reviewer'},
      conferences: [
        ConferenceParticipation(
          conference: 'DAC 2026',
          role: 'TPC Member',
          completedReviews: 7,
          assignedReviews: 12,
        ),
        ConferenceParticipation(
          conference: 'NeurIPS 2025',
          role: 'External Reviewer',
          completedReviews: 3,
          assignedReviews: 3,
        ),
      ],
    ),
    SearchResult(
      name: 'Marco Conti',
      affiliation: 'Sapienza University of Rome',
      topics: ['distributed systems', 'privacy', 'security'],
      matchScore: 0.94,
      roles: {'Track Chair', 'TPC Member'},
      conferences: [
        ConferenceParticipation(
          conference: 'ICDCS 2026',
          role: 'Track Chair',
          completedReviews: 9,
          assignedReviews: 9,
        ),
        ConferenceParticipation(
          conference: 'DAC 2026',
          role: 'TPC Member',
          completedReviews: 10,
          assignedReviews: 11,
        ),
      ],
    ),
    SearchResult(
      name: 'Elena Bianchi',
      affiliation: 'University of Bologna',
      topics: ['recommender systems', 'data mining'],
      matchScore: 0.77,
      roles: {'External Reviewer'},
      conferences: [
        ConferenceParticipation(
          conference: 'RecSys 2025',
          role: 'External Reviewer',
          completedReviews: 4,
          assignedReviews: 5,
        ),
      ],
    ),
    SearchResult(
      name: 'Luca Ferri',
      affiliation: 'ETH Zurich',
      topics: ['program analysis', 'formal methods', 'security'],
      matchScore: 0.69,
      roles: {'Area Chair'},
      conferences: [
        ConferenceParticipation(
          conference: 'CCS 2026',
          role: 'Area Chair',
          completedReviews: 12,
          assignedReviews: 12,
        ),
      ],
    ),
    SearchResult(
      name: 'Alice Esposito',
      affiliation: 'University of Amsterdam',
      topics: ['ai ethics', 'privacy', 'governance'],
      matchScore: 0.72,
      roles: {'Program Chair', 'Track Chair'},
      conferences: [
        ConferenceParticipation(
          conference: 'AIES 2026',
          role: 'Program Chair',
          completedReviews: 14,
          assignedReviews: 14,
        ),
        ConferenceParticipation(
          conference: 'DAC 2026',
          role: 'Track Chair',
          completedReviews: 6,
          assignedReviews: 7,
        ),
      ],
    ),
    SearchResult(
      name: 'David Nguyen',
      affiliation: 'TU Munich',
      topics: ['graph neural networks', 'knowledge graphs'],
      matchScore: 0.88,
      roles: {'TPC Member'},
      conferences: [
        ConferenceParticipation(
          conference: 'DAC 2026',
          role: 'TPC Member',
          completedReviews: 11,
          assignedReviews: 12,
        ),
        ConferenceParticipation(
          conference: 'ISWC 2025',
          role: 'TPC Member',
          completedReviews: 5,
          assignedReviews: 6,
        ),
      ],
    ),
  ];

  void runSearch(FilterState filters) {
    var filtered = _mockResults.where((result) {
      final nameOrEmailQuery = filters.nameOrEmail.trim().toLowerCase();
      final affiliationQuery = filters.affiliation.trim().toLowerCase();

      final matchesNameOrEmail =
          nameOrEmailQuery.isEmpty ||
          result.name.toLowerCase().contains(nameOrEmailQuery);
      final matchesAffiliation =
          affiliationQuery.isEmpty ||
          result.affiliation.toLowerCase().contains(affiliationQuery);

      final matchesKeywords =
          filters.keywords.isEmpty ||
          filters.keywords.any((keyword) {
            final lowered = keyword.toLowerCase();
            return result.topics.any(
              (topic) => topic.toLowerCase().contains(lowered),
            );
          });

      final matchesRoles =
          filters.pastRoles.isEmpty ||
          result.roles.intersection(filters.pastRoles).isNotEmpty;

      return matchesNameOrEmail &&
          matchesAffiliation &&
          matchesKeywords &&
          matchesRoles;
    }).toList();

    final activeSort = state.sortBy;
    filtered = _sortResults(filtered, activeSort);
    state = state.copyWith(
      hasRunSearch: true,
      sortBy: activeSort,
      results: filtered,
      clearSelectedProfile: true,
    );
  }

  void setSortBy(SearchSortBy sortBy) {
    state = state.copyWith(
      sortBy: sortBy,
      results: _sortResults(state.results, sortBy),
    );
  }

  void selectProfile(String profileName) {
    state = state.copyWith(selectedProfileName: profileName);
  }

  void clearSelectedProfile() {
    state = state.copyWith(clearSelectedProfile: true);
  }

  List<SearchResult> _sortResults(
    List<SearchResult> input,
    SearchSortBy sortBy,
  ) {
    final sorted = [...input];
    switch (sortBy) {
      case SearchSortBy.matchDesc:
        sorted.sort((a, b) => b.matchScore.compareTo(a.matchScore));
        break;
      case SearchSortBy.nameAsc:
        sorted.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case SearchSortBy.affiliationAsc:
        sorted.sort(
          (a, b) => a.affiliation.toLowerCase().compareTo(
            b.affiliation.toLowerCase(),
          ),
        );
        break;
    }
    return sorted;
  }
}
