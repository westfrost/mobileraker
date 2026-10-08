/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:common/ui/components/spool_widget.dart';
import 'package:common/util/extensions/number_format_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dto/get_filament.dart';
import '../dto/get_spool.dart';
import '../dto/get_vendor.dart';
import '../dto/spoolman_dto_mixin.dart';
import '../service/spoolman_service.dart';

/// One row in a Spoolman list (spool, filament or vendor).
class SpoolmanEntryTile extends ConsumerWidget {
  const SpoolmanEntryTile({super.key, required this.machineUUID, required this.entry, this.onTap, this.trailing});

  final String machineUUID;
  final SpoolmanIdentifiableDtoMixin entry;
  final ValueChanged<SpoolmanIdentifiableDtoMixin>? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final numberFormat = NumberFormat.decimalPatternDigits(locale: context.locale.toStringWithSeparator(), decimalDigits: 0);
    final tap = onTap == null ? null : () => onTap!(entry);

    switch (entry) {
      case GetSpool spool:
        final isActive = ref.watch(activeSpoolIdProvider(machineUUID)).value == spool.id;
        final fil = spool.filament;
        final title = [if (fil.name != null) fil.name!, if (fil.material != null) '(${fil.material})'].join(' ');
        final remaining = spool.remainingWeight;
        return ListTile(
          onTap: tap,
          leading: SpoolWidget(color: fil.colorHex, height: 40),
          title: Text(title.isEmpty ? '#${spool.id}' : title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                [
                  '#${spool.id}',
                  if (fil.vendor != null) fil.vendor!.name,
                  if (spool.location?.isNotEmpty == true) spool.location!,
                ].join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (spool.progress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: spool.progress,
                      minHeight: 5,
                      color: fil.color,
                      backgroundColor: themeData.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
            ],
          ),
          trailing: trailing ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (remaining != null) Text(numberFormat.formatGrams(remaining), style: themeData.textTheme.bodyMedium),
                  if (isActive)
                    Text(tr('general.active'),
                        style: themeData.textTheme.labelSmall?.copyWith(color: themeData.colorScheme.primary)),
                  if (spool.archived)
                    Text(tr('general.archived'),
                        style: themeData.textTheme.labelSmall?.copyWith(color: themeData.disabledColor)),
                ],
              ),
        );
      case GetFilament filament:
        return ListTile(
          onTap: tap,
          leading: SpoolWidget(color: filament.colorHex, height: 40),
          title: Text(
            [if (filament.name != null) filament.name!, if (filament.material != null) '(${filament.material})']
                    .join(' ')
                    .ifEmpty('#${filament.id}'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            ['#${filament.id}', if (filament.vendor != null) filament.vendor!.name].join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: trailing ??
              (filament.weight != null ? Text(numberFormat.formatGrams(filament.weight!)) : null),
        );
      case GetVendor vendor:
        return ListTile(
          onTap: tap,
          leading: const CircleAvatar(child: Icon(Icons.factory_outlined)),
          title: Text(vendor.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('#${vendor.id}'),
          trailing: trailing,
        );
      default:
        return ListTile(title: Text('#${entry.id}'), onTap: tap);
    }
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
