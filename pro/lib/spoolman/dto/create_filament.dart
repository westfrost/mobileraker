/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'get_vendor.dart';

class CreateFilament {
  const CreateFilament({
    this.name,
    this.vendor,
    this.material,
    this.price,
    required this.density,
    required this.diameter,
    this.weight,
    this.spoolWeight,
    this.articleNumber,
    this.settingsExtruderTemp,
    this.settingsBedTemp,
    this.colorHex,
    this.comment,
    this.extra,
  });

  final String? name;
  final GetVendor? vendor;
  final String? material;
  final num? price;
  final num density;
  final num diameter;
  final num? weight;
  final num? spoolWeight;
  final String? articleNumber;
  final num? settingsExtruderTemp;
  final num? settingsBedTemp;
  final String? colorHex;
  final String? comment;
  final Map<String, String>? extra;

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (vendor != null) 'vendor_id': vendor!.id,
        if (material != null) 'material': material,
        if (price != null) 'price': price,
        'density': density,
        'diameter': diameter,
        if (weight != null) 'weight': weight,
        if (spoolWeight != null) 'spool_weight': spoolWeight,
        if (articleNumber != null) 'article_number': articleNumber,
        if (settingsExtruderTemp != null) 'settings_extruder_temp': settingsExtruderTemp!.round(),
        if (settingsBedTemp != null) 'settings_bed_temp': settingsBedTemp!.round(),
        if (colorHex != null) 'color_hex': normalizeHex(colorHex!),
        if (comment != null) 'comment': comment,
        if (extra != null && extra!.isNotEmpty) 'extra': extra,
      };

  @override
  String toString() => 'CreateFilament${toJson()}';
}

/// Spoolman expects `RRGGBB` (or `RRGGBBAA`) without a leading `#`.
/// Flutter/flex_color_scheme hex codes are `AARRGGBB`, so a fully opaque alpha is dropped.
String normalizeHex(String hex) {
  var clean = hex.trim().replaceFirst('#', '').toUpperCase();
  if (clean.length == 8) {
    final alpha = clean.substring(0, 2);
    final rgb = clean.substring(2);
    clean = alpha == 'FF' ? rgb : '$rgb$alpha';
  }
  return clean;
}
