// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_filament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetFilament _$GetFilamentFromJson(Map<String, dynamic> json) => _GetFilament(
  id: (json['id'] as num).toInt(),
  registered: const SpoolmanDateTimeConverter().fromJson(
    json['registered'] as String,
  ),
  name: json['name'] as String?,
  vendor: json['vendor'] == null
      ? null
      : GetVendor.fromJson(json['vendor'] as Map<String, dynamic>),
  material: json['material'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  density: (json['density'] as num).toDouble(),
  diameter: (json['diameter'] as num).toDouble(),
  weight: (json['weight'] as num?)?.toDouble(),
  spoolWeight: (json['spool_weight'] as num?)?.toDouble(),
  articleNumber: json['article_number'] as String?,
  comment: json['comment'] as String?,
  settingsExtruderTemp: (json['settings_extruder_temp'] as num?)?.toInt(),
  settingsBedTemp: (json['settings_bed_temp'] as num?)?.toInt(),
  colorHex: json['color_hex'] as String?,
  multiColorHexes: json['multi_color_hexes'] as String?,
  multiColorDirection: json['multi_color_direction'] as String?,
  externalId: json['external_id'] as String?,
  extra: json['extra'] == null ? const {} : extraFromJson(json['extra']),
);

Map<String, dynamic> _$GetFilamentToJson(
  _GetFilament instance,
) => <String, dynamic>{
  'id': instance.id,
  'registered': const SpoolmanDateTimeConverter().toJson(instance.registered),
  'name': instance.name,
  'vendor': instance.vendor,
  'material': instance.material,
  'price': instance.price,
  'density': instance.density,
  'diameter': instance.diameter,
  'weight': instance.weight,
  'spool_weight': instance.spoolWeight,
  'article_number': instance.articleNumber,
  'comment': instance.comment,
  'settings_extruder_temp': instance.settingsExtruderTemp,
  'settings_bed_temp': instance.settingsBedTemp,
  'color_hex': instance.colorHex,
  'multi_color_hexes': instance.multiColorHexes,
  'multi_color_direction': instance.multiColorDirection,
  'external_id': instance.externalId,
  'extra': instance.extra,
};
