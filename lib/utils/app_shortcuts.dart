import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

String shortcutLabel(String key) {
  final modifier =
      defaultTargetPlatform == TargetPlatform.macOS ? '⌘' : 'Ctrl+';
  return '$modifier$key';
}

SingleActivator appPrimaryShortcut(LogicalKeyboardKey key) {
  final isMac = defaultTargetPlatform == TargetPlatform.macOS;
  return SingleActivator(
    key,
    meta: isMac,
    control: !isMac,
  );
}

bool get isTextInputFocused {
  final primaryFocus = FocusManager.instance.primaryFocus;
  if (primaryFocus == null || !primaryFocus.hasFocus) {
    return false;
  }
  final focusContext = primaryFocus.context;
  if (focusContext == null) {
    return false;
  }
  return focusContext.findAncestorStateOfType<EditableTextState>() != null;
}
