class GithubRepoRef {
  const GithubRepoRef({
    required this.owner,
    required this.repo,
  });

  final String owner;
  final String repo;

  bool get isValid => owner.isNotEmpty && repo.isNotEmpty;

  static final _githubUrlPattern = RegExp(
    r'(?:https?://)?(?:www\.)?github\.com/([^/\s]+)/([^/\s#?]+)',
    caseSensitive: false,
  );

  static GithubRepoRef parse({
    required String owner,
    required String repo,
  }) {
    var normalizedOwner = _cleanupSegment(owner);
    var normalizedRepo = _cleanupSegment(repo);

    final combined = '$normalizedOwner/$normalizedRepo'.trim();
    final urlInCombined = _githubUrlPattern.firstMatch(combined);
    if (urlInCombined != null) {
      return GithubRepoRef(
        owner: urlInCombined.group(1)!,
        repo: _cleanupSegment(urlInCombined.group(2)!),
      );
    }

    final urlInOwner = _githubUrlPattern.firstMatch(normalizedOwner);
    if (urlInOwner != null) {
      normalizedOwner = urlInOwner.group(1)!;
      if (normalizedRepo.isEmpty) {
        normalizedRepo = _cleanupSegment(urlInOwner.group(2)!);
      }
    }

    final urlInRepo = _githubUrlPattern.firstMatch(normalizedRepo);
    if (urlInRepo != null) {
      return GithubRepoRef(
        owner: urlInRepo.group(1)!,
        repo: _cleanupSegment(urlInRepo.group(2)!),
      );
    }

    if (normalizedOwner.isEmpty && normalizedRepo.contains('/')) {
      final parts = normalizedRepo.split('/').where((part) => part.isNotEmpty);
      final segments = parts.toList();
      if (segments.length >= 2) {
        return GithubRepoRef(
          owner: segments.first,
          repo: _cleanupSegment(segments.sublist(1).join('/')),
        );
      }
    }

    if (normalizedRepo.contains('/') && normalizedOwner.isNotEmpty) {
      final parts = normalizedRepo.split('/').where((part) => part.isNotEmpty);
      final segments = parts.toList();
      if (segments.length == 1) {
        normalizedRepo = segments.first;
      }
    }

    return GithubRepoRef(
      owner: normalizedOwner,
      repo: normalizedRepo,
    );
  }

  static String _cleanupSegment(String value) {
    var result = value.trim();
    if (result.startsWith('@')) {
      result = result.substring(1);
    }
    if (result.endsWith('/')) {
      result = result.substring(0, result.length - 1);
    }
    if (result.endsWith('.git')) {
      result = result.substring(0, result.length - 4);
    }
    return result;
  }
}
