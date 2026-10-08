// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_spool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetSpool _$GetSpoolFromJson(Map<String, dynamic> json) => _GetSpool(
  id: (json['id'] as num).toInt(),
  registered: const SpoolmanDateTimeConverter().fromJson(
    json['registered'] as String,
  ),
  firstUsed: const SpoolmanNullableDateTimeConverter().fromJson(
    json['first_used'] as String?,
  ),
  lastUsed: const SpoolmanNullableDateTimeConverter().fromJson(
    json['last_used'] as String?,
  ),
  filament: GetFilament.fromJson(json['filament'] as Map<String, dynamic>),
  price: (json['price'] as num?)?.toDouble(),
  remainingWeight: (json['remaining_weight'] as num?)?.toDouble(),
  initialWeight: (json['initial_weight'] as num?)?.toDouble(),
  spoolWeight: (json['spool_weight'] as num?)?.toDouble(),
  usedWeight: (json['used_weight'] as num?)?.toDouble() ?? 0,
  remainingLength: (json['remaining_length'] as num?)?.toDouble(),
  usedLength: (json['used_length'] as num?)?.toDouble() ?? 0,
  location: json['location'] as String?,
  lotNr: json['lot_nr'] as String?,
  comment: json['comment'] as String?,
  archived: json['archived'] as bool? ?? false,
  extra: json['extra'] == null ? const {} : extraFromJson(json['extra']),
);

Map<String, dynamic> _$GetSpoolToJson(_GetSpool instance) => <String, dynamic>{
  'id': instance.id,
  'registered': const SpoolmanDateTimeConverter().toJson(instance.registered),
  'first_used': const SpoolmanNullableDateTimeConverter().toJson(
    instance.firstUsed,
  ),
  'last_used': const SpoolmanNullableDateTimeConverter().toJson(
    instance.lastUsed,
  ),
  'filament': instance.filament,
  'price': instance.price,
  'remaining_weight': instance.remainingWeight,
  'initial_weight': instance.initialWeight,
  'spool_weight': instance.spoolWeight,
  'used_weight': instance.usedWeight,
  'remaining_length': instance.remainingLength,
  'used_length': instance.usedLength,
  'location': instance.location,
  'lot_nr': instance.lotNr,
  'comment': instance.comment,
  'archived': instance.archived,
  'extra': instance.extra,
};
