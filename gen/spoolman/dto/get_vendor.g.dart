// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetVendor _$GetVendorFromJson(Map<String, dynamic> json) => _GetVendor(
  id: (json['id'] as num).toInt(),
  registered: const SpoolmanDateTimeConverter().fromJson(
    json['registered'] as String,
  ),
  name: json['name'] as String,
  comment: json['comment'] as String?,
  spoolWeight: (json['empty_spool_weight'] as num?)?.toDouble(),
  externalId: json['external_id'] as String?,
  extra: json['extra'] == null ? const {} : extraFromJson(json['extra']),
);

Map<String, dynamic> _$GetVendorToJson(
  _GetVendor instance,
) => <String, dynamic>{
  'id': instance.id,
  'registered': const SpoolmanDateTimeConverter().toJson(instance.registered),
  'name': instance.name,
  'comment': instance.comment,
  'empty_spool_weight': instance.spoolWeight,
  'external_id': instance.externalId,
  'extra': instance.extra,
};
