class GithubSyncConfig {
  const GithubSyncConfig({
    required this.owner,
    required this.repo,
    this.branch = 'main',
    required this.isEnabled,
  });

  final String owner;
  final String repo;
  final String branch;
  final bool isEnabled;

  bool get isConfigured => owner.isNotEmpty && repo.isNotEmpty;

  GithubSyncConfig copyWith({
    String? owner,
    String? repo,
    String? branch,
    bool? isEnabled,
  }) {
    return GithubSyncConfig(
      owner: owner ?? this.owner,
      repo: repo ?? this.repo,
      branch: branch ?? this.branch,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
