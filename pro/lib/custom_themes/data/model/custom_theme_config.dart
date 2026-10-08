/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'custom_theme_config.freezed.dart';
part 'custom_theme_config.g.dart';

/// Colors and FlexColorScheme options of one brightness variant of a custom theme.
/// Colors are stored as ARGB ints.
@freezed
sealed class CustomThemeConfig with _$CustomThemeConfig {
  const CustomThemeConfig._();

  const factory CustomThemeConfig({
    required int primaryColor,
    int? secondaryColor,
    int? tertiaryColor,
    int? surfaceColor,
    int? onSurfaceColor,
    int? appBarColor,
    @Default(true) bool useMaterial3,
    String? fontFamily,
    @Default(0) int blendLevel,
    @Default(0) int surfaceModeIndex,
    @Default(4) int appBarStyleIndex,
    @Default(1) int usedColors,
    @Default(false) bool lightIsWhite,
    @Default(false) bool darkIsTrueBlack,
  }) = _CustomThemeConfig;

  factory CustomThemeConfig.fromJson(Map<String, dynamic> json) => _$CustomThemeConfigFromJson(json);
}

class CustomThemeConfigAdapter extends TypeAdapter<CustomThemeConfig> {
  @override
  final int typeId = 43;

  @override
  CustomThemeConfig read(BinaryReader reader) =>
      CustomThemeConfig.fromJson((jsonDecode(reader.readString()) as Map).cast<String, dynamic>());

  @override
  void write(BinaryWriter writer, CustomThemeConfig obj) => writer.writeString(jsonEncode(obj.toJson()));
}
