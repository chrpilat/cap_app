class FilterState {
  const FilterState({
    List<String>? keywords,
    String? nameOrEmail,
    String? affiliation,
    Set<String>? pastRoles,
  }) : _keywords = keywords,
       _nameOrEmail = nameOrEmail,
       _affiliation = affiliation,
       _pastRoles = pastRoles;

  final List<String>? _keywords;
  final String? _nameOrEmail;
  final String? _affiliation;
  final Set<String>? _pastRoles;

  List<String> get keywords => _keywords ?? const <String>[];
  String get nameOrEmail => _nameOrEmail ?? '';
  String get affiliation => _affiliation ?? '';
  Set<String> get pastRoles => _pastRoles ?? const <String>{};

  FilterState copyWith({
    List<String>? keywords,
    String? nameOrEmail,
    String? affiliation,
    Set<String>? pastRoles,
  }) {
    return FilterState(
      keywords: keywords ?? this.keywords,
      nameOrEmail: nameOrEmail ?? this.nameOrEmail,
      affiliation: affiliation ?? this.affiliation,
      pastRoles: pastRoles ?? this.pastRoles,
    );
  }
}
