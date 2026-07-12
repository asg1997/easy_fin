import 'dart:convert';

import 'package:easy_fin/models/report_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _templatesKey = 'report_templates';

final reportTemplatesStorageProvider = Provider<ReportTemplatesStorage>(
  (ref) => const ReportTemplatesStorage(),
);

class ReportTemplatesStorage {
  const ReportTemplatesStorage();

  Future<List<ReportTemplate>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_templatesKey);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) => ReportTemplate.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> save(ReportTemplate template) async {
    final templates = await getAll();
    final index = templates.indexWhere((item) => item.id == template.id);
    if (index >= 0) {
      templates[index] = template;
    } else {
      templates.add(template);
    }
    await _writeAll(templates);
  }

  Future<void> delete(ReportTemplateId id) async {
    final templates = await getAll();
    templates.removeWhere((item) => item.id == id);
    await _writeAll(templates);
  }

  Future<void> _writeAll(List<ReportTemplate> templates) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _templatesKey,
      jsonEncode(templates.map((item) => item.toJson()).toList()),
    );
  }
}
