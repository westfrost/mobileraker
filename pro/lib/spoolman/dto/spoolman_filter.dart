/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:collection/collection.dart';

/// Query filters passed to Spoolman list endpoints (e.g. `filament.id`, `location`, `allow_archived`).
/// Value-equal so it can be used as a provider family parameter.
class SpoolmanFilter {
  const SpoolmanFilter(this.filters);

  const SpoolmanFilter.empty() : filters = const {};

  final Map<String, dynamic> filters;

  bool get isEmpty => filters.isEmpty;

  SpoolmanFilter merge(SpoolmanFilter other) => SpoolmanFilter({...filters, ...other.filters});

  /// Converts the filter into query parameters understood by the Spoolman REST API.
  Map<String, String> toQueryParameters() => {
        for (final MapEntry(:key, :value) in filters.entries)
          if (value != null) key: value is bool ? value.toString() : '$value',
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpoolmanFilter && const DeepCollectionEquality().equals(other.filters, filters);

  @override
  int get hashCode => const DeepCollectionEquality().hash(filters);

  @override
  String toString() => 'SpoolmanFilter($filters)';
}
