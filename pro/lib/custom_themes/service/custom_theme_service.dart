/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:io';

import 'package:common/ui/theme/theme_pack.dart';
import 'package:common/util/logger.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/model/custom_theme_config.dart';
import '../data/model/custom_theme_pack.dart';
import '../repository/custom_theme_repository_impl.dart';

part 'custom_theme_service.g.dart';

@Riverpod(keepAlive: true)
CustomThemeService customThemeService(Ref ref) => CustomThemeService(ref.watch(customThemeRepositoryProvider));

@Riverpod(keepAlive: true)
Stream<List<CustomThemePack>> customThemePacks(Ref ref) => ref.watch(customThemeRepositoryProvider).watchAll();

/// The user's custom themes converted into app [ThemePack]s.
@Riverpod(keepAlive: true)
List<ThemePack> customThemePacksAsThemePack(Ref ref) {
  final packs = ref.watch(customThemePacksProvider).value ?? const <CustomThemePack>[];
  final result = <ThemePack>[];
  for (final pack in packs) {
    try {
      result.add(buildThemePack(pack));
    } catch (e, s) {
      talker.error('[CustomThemes] Could not build theme ${pack.name}', e, s);
    }
  }
  return result;
}

class CustomThemeService {
  CustomThemeService(this._repository);

  final CustomThemeRepository _repository;

  Future<void> save(CustomThemePack pack) {
    talker.info('[CustomThemes] Saving ${pack.name}');
    return _repository.save(pack);
  }

  Future<void> delete(CustomThemePack pack) async {
    talker.info('[CustomThemes] Deleting ${pack.name}');
    await _repository.delete(pack.uuid);
    // Clean up copied logo files.
    for (final path in [pack.logoPath, pack.logoDarkPath].nonNulls) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
  }

  Future<List<CustomThemePack>> all() => _repository.findAll();
}

// ----------------------------------------------------------------------------
// Theme building
// ----------------------------------------------------------------------------

const _surfaceModes = [
  FlexSurfaceMode.level,
  FlexSurfaceMode.levelSurfacesLowScaffold,
  FlexSurfaceMode.highScaffoldLevelSurface,
  FlexSurfaceMode.highSurfaceLowScaffold,
  FlexSurfaceMode.highScaffoldLowSurface,
];

const _appBarStyles = [
  FlexAppBarStyle.surface,
  FlexAppBarStyle.primary,
  FlexAppBarStyle.material,
  FlexAppBarStyle.background,
  FlexAppBarStyle.scaffoldBackground,
];

const _bottomSheetShape = RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)));

String? _resolveFont(String? family) {
  if (family == null || family.isEmpty) return null;
  try {
    return GoogleFonts.getFont(family).fontFamily;
  } catch (_) {
    return family;
  }
}

ImageProvider? _logo(String? path) {
  if (path == null || path.isEmpty) return null;
  final file = File(path);
  if (!file.existsSync()) return null;
  if (path.toLowerCase().endsWith('.svg')) return Svg(path, source: SvgSource.file);
  return FileImage(file);
}

ThemeData _buildTheme(CustomThemeConfig config, Brightness brightness) {
  Color? c(int? v) => v == null ? null : Color(v);

  final colors = FlexSchemeColor.from(
    primary: Color(config.primaryColor),
    secondary: c(config.secondaryColor),
    tertiary: c(config.tertiaryColor),
    appBarColor: c(config.appBarColor),
    brightness: brightness,
  );
  final surfaceMode = _surfaceModes[config.surfaceModeIndex.clamp(0, _surfaceModes.length - 1)];
  final appBarStyle = config.appBarColor != null
      ? FlexAppBarStyle.custom
      : _appBarStyles[config.appBarStyleIndex.clamp(0, _appBarStyles.length - 1)];
  final usedColors = config.usedColors.clamp(1, 7);
  final blendLevel = config.blendLevel.clamp(0, 40);
  final fontFamily = _resolveFont(config.fontFamily);

  var theme = brightness == Brightness.light
      ? FlexThemeData.light(
          colors: colors,
          usedColors: usedColors,
          surfaceMode: surfaceMode,
          blendLevel: blendLevel,
          appBarStyle: appBarStyle,
          lightIsWhite: config.lightIsWhite,
          useMaterial3: config.useMaterial3,
          keyColors: FlexKeyColors(useKeyColors: config.useMaterial3, keepPrimary: true),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          fontFamily: fontFamily,
        )
      : FlexThemeData.dark(
          colors: colors,
          usedColors: usedColors,
          surfaceMode: surfaceMode,
          blendLevel: blendLevel,
          appBarStyle: appBarStyle,
          darkIsTrueBlack: config.darkIsTrueBlack,
          useMaterial3: config.useMaterial3,
          keyColors: FlexKeyColors(useKeyColors: config.useMaterial3, keepPrimary: true),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          fontFamily: fontFamily,
        );

  if (config.surfaceColor != null || config.onSurfaceColor != null) {
    final scheme = theme.colorScheme.copyWith(
      surface: c(config.surfaceColor),
      onSurface: c(config.onSurfaceColor),
    );
    theme = theme.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: c(config.surfaceColor) ?? theme.scaffoldBackgroundColor,
    );
  }

  return theme.copyWith(
    inputDecorationTheme: theme.inputDecorationTheme.copyWith(filled: false),
    cardTheme: theme.cardTheme.copyWith(elevation: 3),
    bottomSheetTheme: theme.bottomSheetTheme.copyWith(
      shape: _bottomSheetShape,
      constraints: const BoxConstraints(maxWidth: 640),
    ),
    extensions: [brightness == Brightness.light ? CustomColors.light : CustomColors.dark],
  );
}

/// Converts a stored custom theme into a [ThemePack] the app can use.
ThemePack buildThemePack(CustomThemePack pack) {
  return ThemePack(
    name: pack.name,
    lightTheme: _buildTheme(pack.lightConfig, Brightness.light),
    darkTheme: pack.darkConfig == null ? null : _buildTheme(pack.darkConfig!, Brightness.dark),
    brandingIcon: _logo(pack.logoPath),
    brandingIconDark: _logo(pack.logoDarkPath),
  );
}
