/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dto/spoolman_dto_mixin.dart';
import '../dto/spoolman_filter.dart';
import 'spoolman_entry_tile.dart';
import 'spoolman_scroll_pagination.dart';

/// Non-scrolling Spoolman list used inside cards: shows [initialCount] entries and a "Load more" button.
class SpoolmanStaticPagination extends HookConsumerWidget {
  const SpoolmanStaticPagination({
    super.key,
    required this.machineUUID,
    required this.type,
    this.initialCount = 5,
    this.exclude,
    this.filters = const SpoolmanFilter.empty(),
    this.onEntryTap,
  });

  final String machineUUID;
  final SpoolmanListType type;
  final int initialCount;

  /// Entry that should not be shown (e.g. the spool whose detail page is open).
  final SpoolmanIdentifiableDtoMixin? exclude;
  final SpoolmanFilter filters;
  final ValueChanged<SpoolmanIdentifiableDtoMixin>? onEntryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = useState(initialCount);
    // Fetch one more so excluding an entry still fills the page.
    final fetchCount = count.value + (exclude == null ? 0 : 1);
    final async = ref.watch(spoolmanListProviderFor(machineUUID, type, fetchCount, filters));
    final data = async.value;
    final themeData = Theme.of(context);

    if (data == null) {
      if (async.hasError) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text('${async.error}', style: TextStyle(color: themeData.colorScheme.error)),
        );
      }
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final items = data.items
        .where((e) => exclude == null || e.runtimeType != exclude.runtimeType || e.id != exclude!.id)
        .take(count.value)
        .toList();

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          switch (type) {
            SpoolmanListType.spools => tr('pages.spoolman.no_spools'),
            SpoolmanListType.filaments => tr('pages.spoolman.no_filaments'),
            SpoolmanListType.vendors => tr('pages.spoolman.no_vendors'),
          },
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          SpoolmanEntryTile(
            key: ValueKey('${type.name}-${item.id}'),
            machineUUID: machineUUID,
            entry: item,
            onTap: onEntryTap,
          ),
        if (data.hasNextPage)
          Center(
            child: TextButton(
              onPressed: async.isLoading ? null : () => count.value += initialCount,
              child: const Text('general.load_more').tr(),
            ),
          ),
      ],
    );
  }
}
