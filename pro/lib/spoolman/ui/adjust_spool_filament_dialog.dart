/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:common/service/ui/dialog_service_interface.dart';
import 'package:common/ui/dialog/mobileraker_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Asks for an amount of filament to consume (positive) or add back (negative).
/// Completes with a record `(num amount, 'g' | 'mm')`.
class AdjustSpoolFilamentDialog extends HookWidget {
  const AdjustSpoolFilamentDialog({super.key, required this.request, required this.completer});

  final DialogRequest request;
  final DialogCompleter completer;

  @override
  Widget build(BuildContext context) {
    final useWeight = useState(true);
    final controller = useTextEditingController();
    final text = useValueListenable(controller).text;
    final parsed = num.tryParse(text.trim().replaceAll(',', '.'));
    final themeData = Theme.of(context);

    void submit() {
      if (parsed == null || parsed == 0) return;
      // Length is entered in meters for convenience, Spoolman wants mm.
      completer(DialogResponse.confirmed(useWeight.value ? (parsed, 'g') : (parsed * 1000, 'mm')));
    }

    return MobilerakerDialog(
      actionText: tr('dialogs.adjust_spool_filament.submit_label'),
      onAction: parsed == null || parsed == 0 ? null : submit,
      dismissText: tr('general.cancel'),
      onDismiss: () => completer(DialogResponse.aborted()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr('dialogs.adjust_spool_filament.title'), style: themeData.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(tr('dialogs.adjust_spool_filament.subtitle'), style: themeData.textTheme.bodySmall),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            onSubmitted: (_) => submit(),
            decoration: InputDecoration(
              labelText: tr('dialogs.adjust_spool_filament.input_label'),
              suffixText: useWeight.value ? 'g' : 'm',
              suffixIcon: IconButton(
                tooltip: useWeight.value
                    ? tr('dialogs.adjust_spool_filament.tooltip.length')
                    : tr('dialogs.adjust_spool_filament.tooltip.weight'),
                icon: Icon(useWeight.value ? Icons.straighten : Icons.scale_outlined),
                onPressed: () => useWeight.value = !useWeight.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
