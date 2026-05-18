import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/filter_state.dart';

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>(
  (ref) => FilterNotifier(),
);

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void addKeywordsFromCommaInput(String rawValue) {
    final tokens = rawValue
        .split(',')
        .map((token) => token.trim())
        .where((token) => token.isNotEmpty);

    var next = state.keywords;
    for (final token in tokens) {
      if (!next.contains(token)) {
        next = [...next, token];
      }
    }
    state = state.copyWith(keywords: next);
  }

  void removeKeyword(String keyword) {
    state = state.copyWith(
      keywords: state.keywords.where((item) => item != keyword).toList(),
    );
  }

  void setNameOrEmail(String value) {
    state = state.copyWith(nameOrEmail: value);
  }

  void setAffiliation(String value) {
    state = state.copyWith(affiliation: value);
  }

  void togglePastRole(String role, bool selected) {
    final next = {...state.pastRoles};
    if (selected) {
      next.add(role);
    } else {
      next.remove(role);
    }
    state = state.copyWith(pastRoles: next);
  }

  void clearAll() {
    state = const FilterState();
  }
}
