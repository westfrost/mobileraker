/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'create_filament.dart';
import 'get_vendor.dart';

/// Only non-null fields are sent (PATCH semantics).
class UpdateFilament {
  const UpdateFilament({
    required this.id,
    this.name,
    this.vendor,
    this.material,
    this.price,
    this.density,
    this.diameter,
    this.weight,
    this.spoolWeight,
    this.articleNumber,
    this.settingsExtruderTemp,
    this.settingsBedTemp,
    this.colorHex,
    this.comment,
    this.extra,
  });

  final int id;
  final String? name;
  final GetVendor? vendor;
  final String? material;
  final num? price;
  final num? density;
  final num? diameter;
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
        if (density != null) 'density': density,
        if (diameter != null) 'diameter': diameter,
        if (weight != null) 'weight': weight,
        if (spoolWeight != null) 'spool_weight': spoolWeight,
        if (articleNumber != null) 'article_number': articleNumber,
        if (settingsExtruderTemp != null) 'settings_extruder_temp': settingsExtruderTemp!.round(),
        if (settingsBedTemp != null) 'settings_bed_temp': settingsBedTemp!.round(),
        if (colorHex != null) 'color_hex': normalizeHex(colorHex!),
        if (comment != null) 'comment': comment,
        if (extra != null) 'extra': extra,
      };

  @override
  String toString() => 'UpdateFilament($id, ${toJson()})';
}
