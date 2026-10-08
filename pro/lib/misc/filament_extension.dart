/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:common/util/extensions/number_format_extension.dart';
import 'package:easy_localization/easy_localization.dart';

import '../spoolman/dto/get_filament.dart';
import '../spoolman/dto/get_spool.dart';

extension MobilerakerFilamentDisplay on GetFilament {
  /// e.g. `Prusament – PLA Galaxy Black (1.75 mm, 1 kg)`
  String displayNameWithDetails(NumberFormat numberFormat) {
    final base = [
      if (vendor != null) vendor!.name,
      [if (material != null) material, if (name != null) name].join(' '),
    ].where((e) => e.trim().isNotEmpty).join(' – ');

    final details = [
      '${numberFormat.format(diameter)} mm',
      if (weight != null) numberFormat.formatGrams(weight!),
    ].join(', ');

    return '${base.isEmpty ? '#$id' : base} ($details)';
  }

  String get displayName {
    final parts = [if (vendor != null) vendor!.name, if (name != null) name!, if (material != null) '($material)'];
    return parts.isEmpty ? '#$id' : parts.join(' ');
  }
}

extension MobilerakerSpoolDisplay on GetSpool {
  String get displayName => '#$id ${filament.displayName}';
}
