/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:freezed_annotation/freezed_annotation.dart';

import 'get_filament.dart';
import 'spoolman_converters.dart';
import 'spoolman_dto_mixin.dart';

part 'get_spool.freezed.dart';
part 'get_spool.g.dart';

@freezed
sealed class GetSpool with _$GetSpool, SpoolmanIdentifiableDtoMixin {
  const GetSpool._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetSpool({
    required int id,
    @SpoolmanDateTimeConverter() required DateTime registered,
    @SpoolmanNullableDateTimeConverter() DateTime? firstUsed,
    @SpoolmanNullableDateTimeConverter() DateTime? lastUsed,
    required GetFilament filament,
    double? price,
    double? remainingWeight,
    double? initialWeight,
    double? spoolWeight,
    @Default(0) double usedWeight,
    double? remainingLength,
    @Default(0) double usedLength,
    String? location,
    String? lotNr,
    String? comment,
    @Default(false) bool archived,
    @JsonKey(fromJson: extraFromJson) @Default({}) Map<String, String> extra,
  }) = _GetSpool;

  factory GetSpool.fromJson(Map<String, dynamic> json) => _$GetSpoolFromJson(json);

  /// Net weight of filament on a full spool.
  double? get effectiveInitialWeight => initialWeight ?? filament.weight;

  /// Fraction (0..1) of filament that is still on the spool, null if unknown.
  double? get progress {
    final initial = effectiveInitialWeight;
    if (initial == null || initial <= 0) return null;
    final remaining = remainingWeight ?? (initial - usedWeight);
    return (remaining / initial).clamp(0.0, 1.0);
  }
}
