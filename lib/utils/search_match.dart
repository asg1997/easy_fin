import 'package:flutter/widgets.dart';

/// Оценка совпадения текста с запросом. Меньше — лучше.
/// `null`, если [query] пустой или совпадения нет.
int? searchMatchScore(String text, String query) {
  if (query.isEmpty) return null;
  final haystack = text.toLowerCase();
  if (!haystack.contains(query)) return null;
  if (haystack == query) return 0;
  if (haystack.startsWith(query)) return 1;
  final index = haystack.indexOf(query);
  return 100 + index;
}

/// Лучшая оценка среди нескольких полей одной записи.
int? bestFieldMatchScore(Iterable<String> fields, String query) {
  int? best;
  for (final field in fields) {
    final score = searchMatchScore(field, query);
    if (score == null) continue;
    if (best == null || score < best) {
      best = score;
    }
  }
  return best;
}

/// Индекс лучшего совпадения среди кандидатов.
/// При равных оценках выбирается первый.
/// Каждый кандидат — список поисковых полей.
/// `null`, если запрос пустой или совпадений нет.
int? indexOfBestSearchMatch({
  required List<List<String>> candidates,
  required String query,
}) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty || candidates.isEmpty) return null;

  int? bestIndex;
  int? bestScore;
  for (var i = 0; i < candidates.length; i++) {
    final score = bestFieldMatchScore(candidates[i], normalized);
    if (score == null) continue;
    if (bestScore == null || score < bestScore) {
      bestScore = score;
      bestIndex = i;
    }
  }
  return bestIndex;
}

void ensureSearchHighlightVisible(GlobalKey? rowKey) {
  final context = rowKey?.currentContext;
  if (context == null) return;
  Scrollable.ensureVisible(
    context,
    alignment: 0.3,
    duration: const Duration(milliseconds: 100),
    curve: Curves.easeOut,
  );
}
