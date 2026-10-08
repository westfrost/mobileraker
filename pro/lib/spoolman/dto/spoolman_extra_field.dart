/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:convert';

import 'spoolman_entity_type_enum.dart';

enum SpoolmanExtraFieldType { text, integer, integerRange, float, floatRange, datetime, boolean, choice, unknown }

SpoolmanExtraFieldType _parseType(String? raw) => switch (raw) {
      'text' => SpoolmanExtraFieldType.text,
      'integer' => SpoolmanExtraFieldType.integer,
      'integer_range' => SpoolmanExtraFieldType.integerRange,
      'float' => SpoolmanExtraFieldType.float,
      'float_range' => SpoolmanExtraFieldType.floatRange,
      'datetime' => SpoolmanExtraFieldType.datetime,
      'boolean' => SpoolmanExtraFieldType.boolean,
      'choice' => SpoolmanExtraFieldType.choice,
      _ => SpoolmanExtraFieldType.unknown,
    };

/// A user defined custom field in Spoolman (`/v1/field/<entity>`).
class SpoolmanExtraField {
  const SpoolmanExtraField({
    required this.key,
    required this.name,
    required this.type,
    required this.entityType,
    this.unit,
    this.defaultValue,
    this.choices = const [],
    this.multiChoice = false,
    this.order = 0,
  });

  factory SpoolmanExtraField.fromJson(Map<String, dynamic> json, SpoolmanEntityType entityType) => SpoolmanExtraField(
        key: json['key'] as String,
        name: (json['name'] as String?) ?? json['key'] as String,
        type: _parseType(json['field_type'] as String?),
        entityType: entityType,
        unit: json['unit'] as String?,
        defaultValue: json['default_value'] as String?,
        choices: [for (final c in (json['choices'] as List?) ?? const []) '$c'],
        multiChoice: json['multi_choice'] == true,
        order: (json['order'] as num?)?.toInt() ?? 0,
      );

  final String key;
  final String name;
  final SpoolmanExtraFieldType type;
  final SpoolmanEntityType entityType;
  final String? unit;

  /// JSON encoded default value.
  final String? defaultValue;
  final List<String> choices;
  final bool multiChoice;
  final int order;

  /// Decodes a JSON encoded extra value, falling back to the raw string.
  static Object? decode(String? raw) {
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      return raw;
    }
  }

  /// Human readable representation of a stored value.
  String format(String? raw) {
    final value = decode(raw);
    if (value == null) return '–';
    final suffix = unit?.isNotEmpty == true ? ' $unit' : '';
    return switch (value) {
      List() when type == SpoolmanExtraFieldType.integerRange || type == SpoolmanExtraFieldType.floatRange =>
        '${value.firstOrNull ?? '?'} – ${value.elementAtOrNull(1) ?? '?'}$suffix',
      List() => value.join(', '),
      bool() => value ? '✓' : '✗',
      String() when type == SpoolmanExtraFieldType.datetime =>
        DateTime.tryParse(value)?.toLocal().toString().split('.').first ?? value,
      _ => '$value$suffix',
    };
  }
}
