// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_theme_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomThemePack _$CustomThemePackFromJson(Map<String, dynamic> json) =>
    _CustomThemePack(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      lightConfig: CustomThemeConfig.fromJson(
        json['lightConfig'] as Map<String, dynamic>,
      ),
      darkConfig: json['darkConfig'] == null
          ? null
          : CustomThemeConfig.fromJson(
              json['darkConfig'] as Map<String, dynamic>,
            ),
      logoPath: json['logoPath'] as String?,
      logoDarkPath: json['logoDarkPath'] as String?,
    );

Map<String, dynamic> _$CustomThemePackToJson(_CustomThemePack instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'lightConfig': instance.lightConfig.toJson(),
      'darkConfig': instance.darkConfig?.toJson(),
      'logoPath': instance.logoPath,
      'logoDarkPath': instance.logoDarkPath,
    };
