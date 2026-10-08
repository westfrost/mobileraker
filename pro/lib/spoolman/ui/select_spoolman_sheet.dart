/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:common/service/ui/bottom_sheet_service_interface.dart';
import 'package:common/util/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../dto/get_spool.dart';
import '../dto/spoolman_filter.dart';
import '../service/spoolman_service.dart';
import 'spoolman_entry_tile.dart';

/// Bottom sheet to choose the active spool, either from the list or by scanning a Spoolman QR code.
class SelectSpoolmanSheet extends HookConsumerWidget {
  const SelectSpoolmanSheet({super.key, required this.machineUUID});

  final String machineUUID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showQr = useState(false);
    final activeId = ref.watch(activeSpoolIdProvider(machineUUID)).value;
    final height = MediaQuery.sizeOf(context).height * 0.6;

    Future<void> activate(GetSpool spool) async {
      await ref.read(spoolmanServiceProvider(machineUUID)).setActiveSpool(spool);
      if (context.mounted) context.pop(BottomSheetResult.confirmed(spool));
    }

    final topBar = PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: false,
              icon: const Icon(Icons.spoke_outlined),
              label: const Text('bottom_sheets.select_spool.header.spools').tr(),
            ),
            ButtonSegment(
              value: true,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('bottom_sheets.select_spool.header.qr').tr(),
            ),
          ],
          selected: {showQr.value},
          onSelectionChanged: (s) => showQr.value = s.first,
        ),
      ),
    );

    final body = SizedBox(
      height: height,
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: showQr.value
            ? _QrScanner(key: const ValueKey('qr'), machineUUID: machineUUID, onSpool: activate)
            : _SpoolList(key: const ValueKey('list'), machineUUID: machineUUID, onSpool: activate),
      ),
    );

    final bottomBar = activeId == null
        ? null
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.pause),
                  label: const Text('pages.spoolman.spoolman_actions.deactivate').tr(),
                  onPressed: () async {
                    await ref.read(spoolmanServiceProvider(machineUUID)).clearActiveSpool();
                    if (context.mounted) context.pop(BottomSheetResult.confirmed(null));
                  },
                ),
              ),
            ),
          );

    return SheetContentScaffold(
      topBar: topBar,
      body: body,
      bottomBar: bottomBar,
      bottomBarVisibility: BottomBarVisibility.always(),
    );
  }
}

class _SpoolList extends ConsumerWidget {
  const _SpoolList({super.key, required this.machineUUID, required this.onSpool});

  final String machineUUID;
  final ValueChanged<GetSpool> onSpool;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(spoolListProvider(machineUUID, filters: const SpoolmanFilter({'allow_archived': false})));
    final activeId = ref.watch(activeSpoolIdProvider(machineUUID)).value;

    return async.when(
      skipLoadingOnRefresh: true,
      data: (data) {
        if (data.items.isEmpty) {
          return Center(child: const Text('bottom_sheets.select_spool.no_spools').tr());
        }
        // Active spool first, then most recently used.
        final spools = [...data.items]..sort((a, b) {
            if (a.id == activeId) return -1;
            if (b.id == activeId) return 1;
            final la = a.lastUsed ?? a.registered;
            final lb = b.lastUsed ?? b.registered;
            return lb.compareTo(la);
          });
        return ListView.builder(
          itemCount: spools.length,
          itemBuilder: (context, i) => SpoolmanEntryTile(
            machineUUID: machineUUID,
            entry: spools[i],
            onTap: (_) => onSpool(spools[i]),
          ),
        );
      },
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: const Text('bottom_sheets.select_spool.error').tr(args: ['$e']),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _QrScanner extends HookConsumerWidget {
  const _QrScanner({super.key, required this.machineUUID, required this.onSpool});

  final String machineUUID;
  final ValueChanged<GetSpool> onSpool;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => MobileScannerController(formats: const [BarcodeFormat.qrCode]));
    useEffect(() => controller.dispose, [controller]);
    final message = useState<String?>(null);
    final busy = useState(false);

    Future<void> onDetect(BarcodeCapture capture) async {
      if (busy.value) return;
      final raw = capture.barcodes.map((b) => b.rawValue).nonNulls.firstOrNull;
      if (raw == null) return;
      final id = SpoolmanService.spoolIdFromQr(raw);
      if (id == null) return;
      busy.value = true;
      await controller.stop();
      try {
        final spool = await ref.read(spoolmanServiceProvider(machineUUID)).getSpool(id);
        if (spool == null) {
          message.value = tr('bottom_sheets.select_spool.spool_id_not_found', args: ['$id']);
          return;
        }
        onSpool(spool);
      } catch (e, s) {
        talker.error('[SelectSpoolmanSheet] QR lookup failed', e, s);
        message.value = tr('bottom_sheets.select_spool.error', args: ['$e']);
      } finally {
        busy.value = false;
      }
    }

    if (message.value != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: const EdgeInsets.all(16), child: Text(message.value!, textAlign: TextAlign.center)),
            FilledButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('bottom_sheets.select_spool.scan_again').tr(),
              onPressed: () {
                message.value = null;
                controller.start();
              },
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MobileScanner(
          controller: controller,
          onDetect: onDetect,
          errorBuilder: (context, error) => Center(
            child: const Text('bottom_sheets.select_spool.qr_error').tr(args: ['${error.errorCode.name}']),
          ),
          placeholderBuilder: (context) => Center(child: const Text('bottom_sheets.select_spool.qr_loading').tr()),
        ),
      ),
    );
  }
}
