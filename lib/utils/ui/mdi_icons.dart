import 'package:flutter/widgets.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

/// Returns the Material Design Icon matching [name], e.g. `alert` or
/// `alert-outline`, or `null` when the name is unknown.
///
/// Replaces `MdiIcons.fromString` from the discontinued
/// `material_design_icons_flutter` package, which stopped compiling because
/// `IconData` became a `final class` and can no longer be extended.
IconData? mdiIconFromString(String? name) {
  if (name == null || name.isEmpty) {
    return null;
  }

  return _iconsByCamelCaseName[_toCamelCase(name)];
}

/// Icon names that are Dart reserved words are exported with an `Icon` suffix
/// by the old package, so keep those aliases working.
const _reservedWordIconNames = ['factory', 'null', 'switch', 'sync'];

final Map<String, IconData> _iconsByCamelCaseName = {
  for (final icon in MdiIcons.values) _toCamelCase(icon.metadata.name): icon,
  for (final name in _reservedWordIconNames)
    if (_iconsByKebabCaseName.containsKey(name))
      '${name}Icon': _iconsByKebabCaseName[name]!,
};

final Map<String, IconData> _iconsByKebabCaseName = {
  for (final icon in MdiIcons.values) icon.metadata.name: icon,
};

final _wordsRegExp = RegExp(
  r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+',
);

String _toCamelCase(String value) {
  final words = _wordsRegExp.allMatches(value);
  if (words.isEmpty) {
    return '';
  }

  final buffer = StringBuffer();
  for (final word in words) {
    final match = word.group(0)!;
    buffer.write(
      match.substring(0, 1).toUpperCase() + match.substring(1).toLowerCase(),
    );
  }

  final result = buffer.toString();
  return result.substring(0, 1).toLowerCase() + result.substring(1);
}
