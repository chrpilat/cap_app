class ConferenceParticipation {
  const ConferenceParticipation({
    required this.conference,
    required this.role,
    required this.completedReviews,
    required this.assignedReviews,
  });

  final String conference;
  final String role;
  final int completedReviews;
  final int assignedReviews;
}

class SearchResult {
  const SearchResult({
    required this.name,
    required this.affiliation,
    required this.topics,
    required this.matchScore,
    required this.roles,
    required this.conferences,
  });

  final String name;
  final String affiliation;
  final List<String> topics;
  final double matchScore;
  final Set<String> roles;
  final List<ConferenceParticipation> conferences;
}
