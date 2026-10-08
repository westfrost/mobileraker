/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'get_filament.dart';

/// Only non-null fields are sent (PATCH semantics).
class UpdateSpool {
  const UpdateSpool({
    required this.id,
    this.firstUsed,
    this.lastUsed,
    this.filament,
    this.price,
    this.initialWeight,
    this.spoolWeight,
    this.usedWeight,
    this.location,
    this.lotNr,
    this.comment,
    this.archived,
    this.extra,
  });

  final int id;
  final DateTime? firstUsed;
  final DateTime? lastUsed;
  final GetFilament? filament;
  final num? price;
  final num? initialWeight;
  final num? spoolWeight;
  final num? usedWeight;
  final String? location;
  final String? lotNr;
  final String? comment;
  final bool? archived;
  final Map<String, String>? extra;

  Map<String, dynamic> toJson() => {
        if (filament != null) 'filament_id': filament!.id,
        if (firstUsed != null) 'first_used': firstUsed!.toUtc().toIso8601String(),
        if (lastUsed != null) 'last_used': lastUsed!.toUtc().toIso8601String(),
        if (price != null) 'price': price,
        if (initialWeight != null) 'initial_weight': initialWeight,
        if (spoolWeight != null) 'spool_weight': spoolWeight,
        if (usedWeight != null) 'used_weight': usedWeight,
        if (location != null) 'location': location,
        if (lotNr != null) 'lot_nr': lotNr,
        if (comment != null) 'comment': comment,
        if (archived != null) 'archived': archived,
        if (extra != null) 'extra': extra,
      };

  @override
  String toString() => 'UpdateSpool($id, ${toJson()})';
}
