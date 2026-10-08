/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

/// Common interface of every Spoolman entity that has an id (spool, filament, vendor).
mixin SpoolmanIdentifiableDtoMixin {
  int get id;
}
