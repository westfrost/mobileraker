/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:freezed_annotation/freezed_annotation.dart';

import 'spoolman_converters.dart';
import 'spoolman_dto_mixin.dart';

part 'get_vendor.freezed.dart';
part 'get_vendor.g.dart';

@freezed
sealed class GetVendor with _$GetVendor, SpoolmanIdentifiableDtoMixin {
  const GetVendor._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetVendor({
    required int id,
    @SpoolmanDateTimeConverter() required DateTime registered,
    required String name,
    String? comment,
    @JsonKey(name: 'empty_spool_weight') double? spoolWeight,
    String? externalId,
    @JsonKey(fromJson: extraFromJson) @Default({}) Map<String, String> extra,
  }) = _GetVendor;

  factory GetVendor.fromJson(Map<String, dynamic> json) => _$GetVendorFromJson(json);
}
