/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:json_annotation/json_annotation.dart';

/// Spoolman sends timestamps in UTC; the app shows them in local time.
class SpoolmanDateTimeConverter implements JsonConverter<DateTime, String> {
  const SpoolmanDateTimeConverter();

  @override
  DateTime fromJson(String json) => _parse(json);

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

class SpoolmanNullableDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const SpoolmanNullableDateTimeConverter();

  @override
  DateTime? fromJson(String? json) => json == null ? null : _parse(json);

  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}

DateTime _parse(String raw) {
  // Spoolman omits the timezone designator in some versions, the values are always UTC.
  final hasTz = raw.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(raw);
  return DateTime.parse(hasTz ? raw : '${raw}Z').toLocal();
}

/// Extra fields are a map of key -> JSON encoded value (always strings).
Map<String, String> extraFromJson(Object? json) {
  if (json is! Map) return const {};
  return {for (final MapEntry(:key, :value) in json.entries) '$key': value is String ? value : '$value'};
}
