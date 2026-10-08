/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:common/service/app_router.dart';
import 'package:common/service/moonraker/klippy_service.dart';
import 'package:common/service/ui/bottom_sheet_service_interface.dart';
import 'package:common/ui/components/spool_widget.dart';
import 'package:common/util/extensions/async_ext.dart';
import 'package:common/util/extensions/number_format_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/ui/pro_routes.dart';
import '../../service/ui/pro_sheet_type.dart';
import '../dto/get_filament.dart';
import '../dto/get_spool.dart';
import '../dto/get_vendor.dart';
import '../service/spoolman_service.dart';

/// Dashboard card showing the active Spoolman spool and letting the user switch it.
class SpoolmanCard extends HookConsumerWidget {
  const SpoolmanCard({super.key, required this.machineUUID});

  static Widget preview() => const _SpoolmanCardPreview();

  final String machineUUID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final hasSpoolman =
        ref.watch(klipperProvider(machineUUID).selectAs((value) => value.hasSpoolmanComponent)).value == true;
    if (!hasSpoolman) return const SizedBox.shrink();

    final active = ref.watch(activeSpoolProvider(machineUUID));

    return _SpoolmanCardBody(
      spool: active.value,
      loading: active.isLoading && !active.hasValue,
      error: active.hasError && !active.hasValue ? active.error : null,
      onSelect: () => ref.read(bottomSheetServiceProvider).show(
            BottomSheetConfig(type: ProSheetType.selectSpoolman, data: machineUUID),
          ),
      onOpen: (spool) => ref
          .read(goRouterProvider)
          .pushNamed(ProRoutes.spoolman_details_spool.name, extra: [machineUUID, spool]),
    );
  }
}

class _SpoolmanCardBody extends StatelessWidget {
  const _SpoolmanCardBody({
    required this.spool,
    required this.onSelect,
    required this.onOpen,
    this.loading = false,
    this.error,
  });

  final GetSpool? spool;
  final bool loading;
  final Object? error;
  final VoidCallback onSelect;
  final ValueChanged<GetSpool> onOpen;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final numberFormat =
        NumberFormat.decimalPatternDigits(locale: context.locale.toStringWithSeparator(), decimalDigits: 1);
    final s = spool;

    Widget content;
    if (loading) {
      content = const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    } else if (error != null) {
      content = ListTile(
        leading: Icon(Icons.error_outline, color: themeData.colorScheme.error),
        title: const Text('pages.dashboard.control.spoolman_card.provider_error_title').tr(),
        subtitle: Text('$error', maxLines: 3, overflow: TextOverflow.ellipsis),
      );
    } else if (s == null) {
      content = ListTile(
        leading: const SpoolWidget(height: 40),
        title: const Text('pages.dashboard.control.spoolman_card.no_spool').tr(),
      );
    } else {
      final fil = s.filament;
      final initial = s.effectiveInitialWeight;
      final remaining = s.remainingWeight ?? (initial == null ? null : initial - s.usedWeight);
      content = InkWell(
        onTap: () => onOpen(s),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              SpoolWidget(color: fil.colorHex, height: 56),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      [if (fil.name != null) fil.name!, if (fil.material != null) '(${fil.material})'].join(' '),
                      style: themeData.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      ['#${s.id}', if (fil.vendor != null) fil.vendor!.name, if (s.location != null) s.location!]
                          .join(' · '),
                      style: themeData.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (s.progress != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: s.progress,
                          minHeight: 6,
                          color: fil.color,
                          backgroundColor: themeData.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (remaining != null)
                          Expanded(
                            child: Text(
                              numberFormat.formatGrams(remaining),
                              style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        Text(
                          tr('pages.dashboard.control.spoolman_card.used',
                              args: [numberFormat.formatGrams(s.usedWeight)]),
                          style: themeData.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.spoke_outlined),
            title: const Text('pages.dashboard.control.spoolman_card.title').tr(),
            trailing: TextButton(
              onPressed: onSelect,
              child: const Text('pages.dashboard.control.spoolman_card.select_spool').tr(),
            ),
          ),
          AnimatedSize(duration: kThemeAnimationDuration, alignment: Alignment.topCenter, child: content),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SpoolmanCardPreview extends StatelessWidget {
  const _SpoolmanCardPreview();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final vendor = GetVendor(id: 1, registered: now, name: 'Prusament');
    final filament = GetFilament(
      id: 1,
      registered: now,
      name: 'Galaxy Black',
      material: 'PLA',
      vendor: vendor,
      density: 1.24,
      diameter: 1.75,
      weight: 1000,
      colorHex: '3D3E3D',
    );
    final spool = GetSpool(
      id: 7,
      registered: now,
      filament: filament,
      initialWeight: 1000,
      remainingWeight: 642,
      usedWeight: 358,
      location: 'Shelf A',
    );
    return _SpoolmanCardBody(spool: spool, onSelect: () {}, onOpen: (_) {});
  }
}
