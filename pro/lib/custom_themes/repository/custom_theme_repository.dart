/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import '../data/model/custom_theme_pack.dart';

abstract interface class CustomThemeRepository {
  Future<List<CustomThemePack>> findAll();

  Future<CustomThemePack?> get(String uuid);

  Future<void> save(CustomThemePack pack);

  Future<void> delete(String uuid);

  Stream<List<CustomThemePack>> watchAll();
}
