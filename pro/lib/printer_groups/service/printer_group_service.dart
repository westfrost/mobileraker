/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:common/service/machine_service.dart';
import 'package:common/util/logger.dart';
import 'package:hive_ce/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/model/printer_group.dart';

part 'printer_group_service.g.dart';

const _kBoxName = 'printer_groups';

@Riverpod(keepAlive: true)
PrinterGroupService printerGroupService(Ref ref) => PrinterGroupService(ref);

/// All printer groups, sorted by name. Updates whenever a group is saved or deleted.
@Riverpod(keepAlive: true)
Stream<List<PrinterGroup>> printerGroups(Ref ref) async* {
  final box = Hive.box<PrinterGroup>(_kBoxName);
  List<PrinterGroup> current() => box.values.sortedBy((g) => g.name.toLowerCase());
  yield current();
  await for (final _ in box.watch()) {
    yield current();
  }
}

class PrinterGroupService {
  PrinterGroupService(this._ref);

  final Ref _ref;

  Box<PrinterGroup> get _box => Hive.box<PrinterGroup>(_kBoxName);

  /// Removes printers from groups once they are deleted from the app.
  void initialize() {
    _ref.listen(allMachinesProvider, (_, next) {
      final machines = next.value;
      if (machines == null) return;
      final known = machines.map((m) => m.uuid).toSet();
      for (final group in _box.values.toList()) {
        final remaining = group.machineUUIDs.where(known.contains).toList();
        if (remaining.length != group.machineUUIDs.length) {
          talker.info('[PrinterGroupService] Removing deleted printers from group ${group.name}');
          save(group.copyWith(machineUUIDs: remaining));
        }
      }
    }, fireImmediately: true);
  }

  Future<void> save(PrinterGroup group) async {
    talker.info('[PrinterGroupService] Saving $group');
    await _box.put(group.uuid, group.copyWith(lastModified: DateTime.now()));
  }

  Future<void> delete(PrinterGroup group) async {
    talker.info('[PrinterGroupService] Deleting $group');
    await _box.delete(group.uuid);
  }

  List<PrinterGroup> groupsOfMachine(String machineUUID) =>
      _box.values.where((g) => g.machineUUIDs.contains(machineUUID)).toList();
}
