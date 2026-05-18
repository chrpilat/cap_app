import 'search_result.dart';

enum SearchSortBy {
  matchDesc,
  nameAsc,
  affiliationAsc,
}

class SearchResultsState {
  const SearchResultsState({
    this.hasRunSearch = false,
    this.sortBy = SearchSortBy.matchDesc,
    this.results = const [],
    this.selectedProfileName,
  });

  final bool hasRunSearch;
  final SearchSortBy sortBy;
  final List<SearchResult> results;
  final String? selectedProfileName;

  SearchResultsState copyWith({
    bool? hasRunSearch,
    SearchSortBy? sortBy,
    List<SearchResult>? results,
    String? selectedProfileName,
    bool clearSelectedProfile = false,
  }) {
    return SearchResultsState(
      hasRunSearch: hasRunSearch ?? this.hasRunSearch,
      sortBy: sortBy ?? this.sortBy,
      results: results ?? this.results,
      selectedProfileName: clearSelectedProfile
          ? null
          : selectedProfileName ?? this.selectedProfileName,
    );
  }
}
