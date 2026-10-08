/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:common/service/setting_service.dart';

enum GCodeVisualizerSettingsKey implements KeyValueStoreKey {
  showGrid('gcv_show_grid', true),
  showAxes('gcv_show_axes', true),
  showNextLayer('gcv_show_next_layer', false),
  showPreviousLayer('gcv_show_prev_layer', true),
  extrusionWidthMultiplier('gcv_extrusion_width', 1.0),
  showExtrusion('gcv_show_extrusion', true),
  showRetraction('gcv_show_retraction', false),
  showTravel('gcv_show_travel', false);

  const GCodeVisualizerSettingsKey(this.key, [this.defaultValue]);

  @override
  final String key;

  @override
  final Object? defaultValue;
}
