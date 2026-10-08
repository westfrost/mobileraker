/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

/// The entity types Spoolman knows. [apiName] is used in the `/v1/field/<type>` endpoint.
enum SpoolmanEntityType {
  spool('spool'),
  filament('filament'),
  vendor('vendor');

  const SpoolmanEntityType(this.apiName);

  final String apiName;
}
