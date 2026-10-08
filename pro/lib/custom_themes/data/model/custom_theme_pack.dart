/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

import 'custom_theme_config.dart';

part 'custom_theme_pack.freezed.dart';
part 'custom_theme_pack.g.dart';

/// A user created theme (light + optional dark variant, optional logos).
@freezed
sealed class CustomThemePack with _$CustomThemePack {
  const CustomThemePack._();

  @JsonSerializable(explicitToJson: true)
  const factory CustomThemePack({
    required String uuid,
    required String name,
    required CustomThemeConfig lightConfig,
    CustomThemeConfig? darkConfig,
    String? logoPath,
    String? logoDarkPath,
  }) = _CustomThemePack;

  factory CustomThemePack.fromJson(Map<String, dynamic> json) => _$CustomThemePackFromJson(json);
}

class CustomThemePackAdapter extends TypeAdapter<CustomThemePack> {
  @override
  final int typeId = 44;

  @override
  CustomThemePack read(BinaryReader reader) =>
      CustomThemePack.fromJson((jsonDecode(reader.readString()) as Map).cast<String, dynamic>());

  @override
  void write(BinaryWriter writer, CustomThemePack obj) => writer.writeString(jsonEncode(obj.toJson()));
}
