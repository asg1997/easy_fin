import 'dart:convert';

import 'package:http/http.dart' as http;

class GitHubApiException implements Exception {
  GitHubApiException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'GitHubApiException($statusCode): $body';
}

class GitHubFileContent {
  const GitHubFileContent({
    required this.bytes,
    required this.sha,
  });

  final List<int> bytes;
  final String sha;
}

class GitHubRepositoryInfo {
  const GitHubRepositoryInfo({
    required this.defaultBranch,
    required this.sizeKb,
  });

  final String? defaultBranch;
  final int sizeKb;

  bool get isEmpty => sizeKb == 0;
}

class GithubApiClient {
  static const _userAgent = 'easy-fin-app';
  static const _initFilePath = 'data/.gitkeep';

  Future<String?> getAuthenticatedLogin(String token) async {
    final response = await http.get(
      Uri.https('api.github.com', '/user'),
      headers: _headers(token),
    );

    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json['login'] as String?;
  }

  Future<GitHubRepositoryInfo> getRepository({
    required String owner,
    required String repo,
    required String token,
  }) async {
    final uri = Uri.https('api.github.com', '/repos/$owner/$repo');
    final response = await http.get(uri, headers: _headers(token));

    if (response.statusCode == 401) {
      throw GitHubApiException(response.statusCode, 'Неверный токен');
    }
    if (response.statusCode == 403) {
      throw GitHubApiException(
        response.statusCode,
        'Нет доступа к репозиторию или превышен лимит запросов',
      );
    }
    if (response.statusCode == 404) {
      final login = await getAuthenticatedLogin(token);
      final details = StringBuffer(
        'Репозиторий $owner/$repo не найден или нет доступа.',
      );
      if (login != null) {
        details
          ..write(' Токен выдан для «$login».')
          ..write(' Проверьте поле «Логин GitHub»');
        if (login.toLowerCase() != owner.toLowerCase()) {
          details.write(' (сейчас: «$owner»)');
        }
        details.write('.');
      } else {
        details.write(' Проверьте логин и имя репозитория.');
      }
      details.write(
        ' Для приватного repo у токена должно быть право repo. '
        'В поле репозитория — только имя, без github.com.',
      );
      if (token.startsWith('github_pat_')) {
        details.write(
          ' Fine-grained токен (github_pat_): в настройках токена на GitHub '
          'выберите репозиторий $owner/$repo и включите '
          'Contents (Read and write) и Metadata (Read). '
          'Проще: создайте classic токен с правом repo.',
        );
      }
      throw GitHubApiException(response.statusCode, details.toString());
    }
    if (response.statusCode != 200) {
      throw GitHubApiException(response.statusCode, response.body);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return GitHubRepositoryInfo(
      defaultBranch: json['default_branch'] as String?,
      sizeKb: json['size'] as int? ?? 0,
    );
  }

  Future<bool> branchExists({
    required String owner,
    required String repo,
    required String branch,
    required String token,
  }) async {
    final uri = Uri.https(
      'api.github.com',
      '/repos/$owner/$repo/git/ref/heads/$branch',
    );
    final response = await http.get(uri, headers: _headers(token));

    if (response.statusCode == 200) return true;
    if (response.statusCode == 404) return false;
    if (response.statusCode == 409) return false;

    throw GitHubApiException(response.statusCode, response.body);
  }

  Future<void> initializeEmptyBranch({
    required String owner,
    required String repo,
    required String branch,
    required String token,
  }) async {
    await putFile(
      owner: owner,
      repo: repo,
      path: _initFilePath,
      branch: branch,
      token: token,
      bytes: utf8.encode('\n'),
      message: 'Initialize Easy Fin sync',
    );
  }

  Future<GitHubFileContent?> getFile({
    required String owner,
    required String repo,
    required String path,
    required String branch,
    required String token,
  }) async {
    final uri = Uri.https(
      'api.github.com',
      '/repos/$owner/$repo/contents/$path',
      {'ref': branch},
    );

    final response = await http.get(
      uri,
      headers: _headers(token),
    );

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw GitHubApiException(response.statusCode, response.body);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final content = json['content'] as String;
    final normalized = content.replaceAll('\n', '');
    final bytes = base64Decode(normalized);
    return GitHubFileContent(
      bytes: bytes,
      sha: json['sha'] as String,
    );
  }

  Future<String> putFile({
    required String owner,
    required String repo,
    required String path,
    required String branch,
    required String token,
    required List<int> bytes,
    required String message,
    String? sha,
  }) async {
    final uri = Uri.https(
      'api.github.com',
      '/repos/$owner/$repo/contents/$path',
    );

    final body = <String, dynamic>{
      'message': message,
      'content': base64Encode(bytes),
      'branch': branch,
      if (sha != null) 'sha': sha,
    };

    final response = await http.put(
      uri,
      headers: _headers(token),
      body: jsonEncode(body),
    );

    if (response.statusCode == 409) {
      throw GitHubApiException(response.statusCode, response.body);
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw GitHubApiException(response.statusCode, response.body);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final content = json['content'] as Map<String, dynamic>;
    return content['sha'] as String;
  }

  Future<String> testConnection({
    required String owner,
    required String repo,
    required String branch,
    required String token,
  }) async {
    final info = await getRepository(owner: owner, repo: repo, token: token);
    final hasBranch = await branchExists(
      owner: owner,
      repo: repo,
      branch: branch,
      token: token,
    );

    if (hasBranch) {
      return 'Подключение успешно';
    }

    if (info.isEmpty) {
      return 'Подключение успешно. Репозиторий пустой — '
          'нажмите «Синхронизировать» для первой загрузки.';
    }

    final defaultBranch = info.defaultBranch;
    if (defaultBranch != null && defaultBranch != branch) {
      throw GitHubApiException(
        404,
        'Ветка «$branch» не найдена. В репозитории используется «$defaultBranch».',
      );
    }

    throw GitHubApiException(
      404,
      'Ветка «$branch» не найдена. Проверьте имя ветки в настройках.',
    );
  }

  Map<String, String> _headers(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      'User-Agent': _userAgent,
      'Content-Type': 'application/json',
    };
  }
}
