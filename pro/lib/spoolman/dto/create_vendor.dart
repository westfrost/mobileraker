/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

class CreateVendor {
  const CreateVendor({required this.name, this.spoolWeight, this.externalId, this.comment, this.extra});

  final String name;
  final num? spoolWeight;
  final String? externalId;
  final String? comment;
  final Map<String, String>? extra;

  Map<String, dynamic> toJson() => {
        'name': name,
        if (spoolWeight != null) 'empty_spool_weight': spoolWeight,
        if (externalId != null && externalId!.isNotEmpty) 'external_id': externalId,
        if (comment != null && comment!.isNotEmpty) 'comment': comment,
        if (extra != null && extra!.isNotEmpty) 'extra': extra,
      };

  @override
  String toString() => 'CreateVendor${toJson()}';
}
