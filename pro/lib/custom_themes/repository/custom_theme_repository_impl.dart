/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:collection/collection.dart';
import 'package:hive_ce/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/model/custom_theme_pack.dart';
import 'custom_theme_repository.dart';

export 'custom_theme_repository.dart';

part 'custom_theme_repository_impl.g.dart';

@Riverpod(keepAlive: true)
CustomThemeRepository customThemeRepository(Ref ref) => CustomThemeRepositoryImpl();

class CustomThemeRepositoryImpl implements CustomThemeRepository {
  Box<CustomThemePack> get _box => Hive.box<CustomThemePack>('custom_theme_packs');

  List<CustomThemePack> _sorted() => _box.values.sortedBy((p) => p.name.toLowerCase());

  @override
  Future<List<CustomThemePack>> findAll() async => _sorted();

  @override
  Future<CustomThemePack?> get(String uuid) async => _box.get(uuid);

  @override
  Future<void> save(CustomThemePack pack) => _box.put(pack.uuid, pack);

  @override
  Future<void> delete(String uuid) => _box.delete(uuid);

  @override
  Stream<List<CustomThemePack>> watchAll() async* {
    yield _sorted();
    await for (final _ in _box.watch()) {
      yield _sorted();
    }
  }
}
