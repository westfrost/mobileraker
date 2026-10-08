/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:common/data/dto/pagination_result.dart';
import 'package:common/ui/components/error_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dto/spoolman_dto_mixin.dart';
import '../dto/spoolman_filter.dart';
import '../service/spoolman_service.dart';
import 'spoolman_entry_tile.dart';

enum SpoolmanListType { spools, filaments, vendors }

const _kPageSize = 25;

/// Watches the first [count] entries of the list of [type].
AsyncValue<PaginationResult<SpoolmanIdentifiableDtoMixin>> watchSpoolmanList(
  WidgetRef ref,
  String machineUUID,
  SpoolmanListType type,
  int count,
  SpoolmanFilter filters,
) {
  return switch (type) {
    SpoolmanListType.spools => ref.watch(spoolListProvider(machineUUID, page: 0, pageSize: count, filters: filters)),
    SpoolmanListType.filaments =>
      ref.watch(filamentListProvider(machineUUID, page: 0, pageSize: count, filters: filters)),
    SpoolmanListType.vendors => ref.watch(vendorListProvider(machineUUID, page: 0, pageSize: count, filters: filters)),
  };
}

String _emptyText(SpoolmanListType type) => switch (type) {
      SpoolmanListType.spools => tr('pages.spoolman.no_spools'),
      SpoolmanListType.filaments => tr('pages.spoolman.no_filaments'),
      SpoolmanListType.vendors => tr('pages.spoolman.no_vendors'),
    };

/// Infinite scrolling Spoolman list with pull-to-refresh.
class SpoolmanScrollPagination extends HookConsumerWidget {
  const SpoolmanScrollPagination({
    super.key,
    required this.machineUUID,
    required this.type,
    this.onEntryTap,
    this.scrollController,
    this.padding,
    this.filters = const SpoolmanFilter.empty(),
  });

  final String machineUUID;
  final SpoolmanListType type;
  final ValueChanged<SpoolmanIdentifiableDtoMixin>? onEntryTap;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final SpoolmanFilter filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = useState(_kPageSize);
    useEffect(() {
      count.value = _kPageSize;
      return null;
    }, [type, filters]);

    final async = watchSpoolmanList(ref, machineUUID, type, count.value, filters);
    final data = async.value;

    Future<void> onRefresh() async {
      ref.read(spoolmanServiceProvider(machineUUID)).refresh();
      await Future.delayed(const Duration(milliseconds: 600));
    }

    if (data == null && async.hasError) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: padding,
          children: [
            ErrorCard(
              title: Text(type == SpoolmanListType.filaments
                  ? 'pages.spoolman.error_loading_filaments'.tr()
                  : 'pages.spoolman.error_loading_spools'.tr()),
              body: Text('${async.error}'),
            ),
          ],
        ),
      );
    }
    if (data == null) return const Center(child: CircularProgressIndicator.adaptive());

    final items = data.items;
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.extentAfter < 400 && data.hasNextPage && !async.isLoading) {
          count.value = count.value + _kPageSize;
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: items.isEmpty
            ? ListView(
                controller: scrollController,
                padding: padding,
                children: [
                  const SizedBox(height: 48),
                  Center(child: Text(_emptyText(type), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              )
            : ListView.builder(
                controller: scrollController,
                padding: padding,
                itemCount: items.length + (data.hasNextPage ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator.adaptive()),
                    );
                  }
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    child: SpoolmanEntryTile(
                      key: ValueKey('${type.name}-${items[index].id}'),
                      machineUUID: machineUUID,
                      entry: items[index],
                      onTap: onEntryTap,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
