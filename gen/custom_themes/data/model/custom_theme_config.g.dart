// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_theme_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomThemeConfig _$CustomThemeConfigFromJson(Map<String, dynamic> json) =>
    _CustomThemeConfig(
      primaryColor: (json['primaryColor'] as num).toInt(),
      secondaryColor: (json['secondaryColor'] as num?)?.toInt(),
      tertiaryColor: (json['tertiaryColor'] as num?)?.toInt(),
      surfaceColor: (json['surfaceColor'] as num?)?.toInt(),
      onSurfaceColor: (json['onSurfaceColor'] as num?)?.toInt(),
      appBarColor: (json['appBarColor'] as num?)?.toInt(),
      useMaterial3: json['useMaterial3'] as bool? ?? true,
      fontFamily: json['fontFamily'] as String?,
      blendLevel: (json['blendLevel'] as num?)?.toInt() ?? 0,
      surfaceModeIndex: (json['surfaceModeIndex'] as num?)?.toInt() ?? 0,
      appBarStyleIndex: (json['appBarStyleIndex'] as num?)?.toInt() ?? 4,
      usedColors: (json['usedColors'] as num?)?.toInt() ?? 1,
      lightIsWhite: json['lightIsWhite'] as bool? ?? false,
      darkIsTrueBlack: json['darkIsTrueBlack'] as bool? ?? false,
    );

Map<String, dynamic> _$CustomThemeConfigToJson(_CustomThemeConfig instance) =>
    <String, dynamic>{
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'tertiaryColor': instance.tertiaryColor,
      'surfaceColor': instance.surfaceColor,
      'onSurfaceColor': instance.onSurfaceColor,
      'appBarColor': instance.appBarColor,
      'useMaterial3': instance.useMaterial3,
      'fontFamily': instance.fontFamily,
      'blendLevel': instance.blendLevel,
      'surfaceModeIndex': instance.surfaceModeIndex,
      'appBarStyleIndex': instance.appBarStyleIndex,
      'usedColors': instance.usedColors,
      'lightIsWhite': instance.lightIsWhite,
      'darkIsTrueBlack': instance.darkIsTrueBlack,
    };
