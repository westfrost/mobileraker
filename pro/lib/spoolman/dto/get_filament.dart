/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'get_vendor.dart';
import 'spoolman_converters.dart';
import 'spoolman_dto_mixin.dart';

part 'get_filament.freezed.dart';
part 'get_filament.g.dart';

@freezed
sealed class GetFilament with _$GetFilament, SpoolmanIdentifiableDtoMixin {
  const GetFilament._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetFilament({
    required int id,
    @SpoolmanDateTimeConverter() required DateTime registered,
    String? name,
    GetVendor? vendor,
    String? material,
    double? price,
    required double density,
    required double diameter,
    double? weight,
    double? spoolWeight,
    String? articleNumber,
    String? comment,
    int? settingsExtruderTemp,
    int? settingsBedTemp,
    String? colorHex,
    String? multiColorHexes,
    String? multiColorDirection,
    String? externalId,
    @JsonKey(fromJson: extraFromJson) @Default({}) Map<String, String> extra,
  }) = _GetFilament;

  factory GetFilament.fromJson(Map<String, dynamic> json) => _$GetFilamentFromJson(json);

  /// The filament color, if Spoolman knows it. Supports `RRGGBB` and `RRGGBBAA`.
  Color? get color => parseSpoolmanHex(colorHex ?? multiColorHexes?.split(',').firstOrNull);

  /// All colors of a multi color filament (or the single color).
  List<Color> get colors {
    final multi = multiColorHexes?.split(',').map(parseSpoolmanHex).nonNulls.toList();
    if (multi != null && multi.isNotEmpty) return multi;
    return [?color];
  }
}

Color? parseSpoolmanHex(String? hex) {
  if (hex == null) return null;
  var clean = hex.trim().replaceFirst('#', '');
  if (clean.length == 6) clean = 'FF$clean';
  if (clean.length == 8 && hex.trim().replaceFirst('#', '').length == 8) {
    // Spoolman uses RRGGBBAA, Flutter wants AARRGGBB
    clean = clean.substring(6) + clean.substring(0, 6);
  }
  final value = int.tryParse(clean, radix: 16);
  return value == null ? null : Color(value);
}
