/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 *
 * Custom dashboard layouts: layouts live in the `dashboard_layouts` Hive box (common module),
 * a machine references its layout by uuid (Machine.dashboardLayout).
 */

import 'package:common/data/model/hive/dashboard_component.dart';
import 'package:common/data/model/hive/dashboard_component_type.dart';
import 'package:common/data/model/hive/dashboard_layout.dart';
import 'package:common/data/model/hive/dashboard_tab.dart';
import 'package:common/data/repository/dashboard_layout_hive_repository.dart';
import 'package:common/exceptions/mobileraker_exception.dart';
import 'package:common/service/machine_service.dart';
import 'package:common/util/extensions/ref_extension.dart';
import 'package:common/util/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'dashboard_layout_service.g.dart';

const kDefaultLayoutUuid = 'default';

@Riverpod(keepAlive: true)
DashboardLayoutService dashboardLayoutService(Ref ref) => DashboardLayoutService(ref);

/// The layout used for the dashboard of [machineUUID]. Falls back to the built-in default.
@riverpod
Future<DashboardLayout> dashboardLayoutForMachine(Ref ref, String machineUUID) async {
  ref.keepAliveFor();
  final service = ref.watch(dashboardLayoutServiceProvider);
  final machine = await ref.watch(machineProvider(machineUUID).future);
  final layoutUuid = machine?.dashboardLayout;
  if (layoutUuid == null || layoutUuid == kDefaultLayoutUuid) return service.defaultDashboardLayout();

  final layout = await ref.read(dashboardLayoutHiveRepositoryProvider).read(id: layoutUuid);
  if (layout == null) {
    talker.warning('[DashboardLayout] Layout $layoutUuid of $machineUUID not found, using default');
    return service.defaultDashboardLayout();
  }
  return layout;
}

class DashboardLayoutService {
  DashboardLayoutService(this._ref);

  final Ref _ref;

  DashboardLayoutHiveRepository get _repo => _ref.read(dashboardLayoutHiveRepositoryProvider);

  DashboardComponent _c(DashboardComponentType type) => DashboardComponent.create(type: type);

  /// The built-in layout. `created == null` marks it as not persisted.
  DashboardLayout defaultDashboardLayout() {
    return DashboardLayout(
      uuid: kDefaultLayoutUuid,
      name: 'Default',
      tabs: [
        DashboardTab.create(
          name: 'General',
          icon: 'nozzle',
          components: [
            _c(DashboardComponentType.machineStatus),
            _c(DashboardComponentType.temperatureSensorPreset),
            _c(DashboardComponentType.webcam),
            _c(DashboardComponentType.controlXYZ),
            _c(DashboardComponentType.zOffset),
            _c(DashboardComponentType.spoolman),
          ],
        ),
        DashboardTab.create(
          name: 'Control',
          icon: 'sliders',
          components: [
            _c(DashboardComponentType.macroGroup),
            _c(DashboardComponentType.controlExtruder),
            _c(DashboardComponentType.fans),
            _c(DashboardComponentType.pins),
            _c(DashboardComponentType.powerApi),
            _c(DashboardComponentType.groupedSliders),
            _c(DashboardComponentType.multipliers),
            _c(DashboardComponentType.limits),
            _c(DashboardComponentType.firmwareRetraction),
            _c(DashboardComponentType.bedMesh),
          ],
        ),
      ],
    );
  }

  DashboardLayout emptyDashboardLayout() =>
      DashboardLayout.create(name: 'New Layout', tabs: [emptyDashboardTab('nozzle'), emptyDashboardTab('sliders')]);

  DashboardTab emptyDashboardTab([String icon = 'dashboard']) =>
      DashboardTab.create(name: 'New Page', icon: icon, components: []);

  /// Creates a fresh copy of an exported layout (new uuids everywhere).
  DashboardLayout importFromJson(Map<String, dynamic> json) {
    final parsed = DashboardLayout.fromJson(json);
    return DashboardLayout.create(
      name: parsed.name,
      tabs: [
        for (final tab in parsed.tabs)
          DashboardTab.create(
            name: tab.name,
            icon: tab.icon,
            components: [
              for (final c in tab.components)
                DashboardComponent.create(
                  type: c.type,
                  showWhilePrinting: c.showWhilePrinting,
                  showBeforePrinterReady: c.showBeforePrinterReady,
                ),
            ],
          ),
      ],
    );
  }

  Future<List<DashboardLayout>> availableLayouts() => _repo.all();

  /// A layout needs at least one page and at least one card.
  bool validateLayout(DashboardLayout layout, [bool throwIfError = false]) {
    final valid = layout.tabs.isNotEmpty && layout.tabs.any((t) => t.components.isNotEmpty);
    if (!valid && throwIfError) {
      throw const MobilerakerException('Layout must contain at least one page with at least one card');
    }
    return valid;
  }

  /// Persists [layout] (creating it if needed) and assigns it to the machine.
  Future<void> saveDashboardLayoutForMachine(String machineUUID, DashboardLayout layout) async {
    validateLayout(layout, true);
    final effective = await persistLayout(layout);

    final machineService = _ref.read(machineServiceProvider);
    final machine = await machineService.fetchMachine(machineUUID);
    if (machine == null) throw MobilerakerException('Machine $machineUUID not found');
    if (machine.dashboardLayout != effective.uuid) {
      await machineService.updateMachine(machine.copyWith(dashboardLayout: effective.uuid));
    }
    _ref.invalidate(dashboardLayoutForMachineProvider);
  }

  /// Creates or updates the layout and returns the stored version.
  Future<DashboardLayout> persistLayout(DashboardLayout layout) async {
    final exists = layout.uuid != kDefaultLayoutUuid && await _repo.read(id: layout.uuid) != null;
    if (exists) {
      final updated = layout.copyWith(lastModified: DateTime.now());
      await _repo.update(updated);
      talker.info('[DashboardLayout] Updated ${layout.name} (${layout.uuid})');
      return updated;
    }
    final toCreate = layout.uuid == kDefaultLayoutUuid ? layout.copyWith(uuid: const Uuid().v4()) : layout;
    await _repo.create(toCreate);
    talker.info('[DashboardLayout] Created ${toCreate.name} (${toCreate.uuid})');
    return await _repo.read(id: toCreate.uuid) ?? toCreate;
  }

  Future<void> removeLayout(DashboardLayout layout) async {
    if (layout.uuid == kDefaultLayoutUuid) return;
    if (await _repo.read(id: layout.uuid) == null) return;
    await _repo.delete(layout.uuid);
    talker.info('[DashboardLayout] Removed ${layout.name} (${layout.uuid})');
    _ref.invalidate(dashboardLayoutForMachineProvider);
  }
}
