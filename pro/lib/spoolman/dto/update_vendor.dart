/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

/// Only non-null fields are sent (PATCH semantics).
class UpdateVendor {
  const UpdateVendor({required this.id, this.name, this.spoolWeight, this.externalId, this.comment, this.extra});

  final int id;
  final String? name;
  final num? spoolWeight;
  final String? externalId;
  final String? comment;
  final Map<String, String>? extra;

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (spoolWeight != null) 'empty_spool_weight': spoolWeight,
        if (externalId != null) 'external_id': externalId,
        if (comment != null) 'comment': comment,
        if (extra != null) 'extra': extra,
      };

  @override
  String toString() => 'UpdateVendor($id, ${toJson()})';
}
