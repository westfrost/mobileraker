/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

class SpoolmanServerInfo {
  const SpoolmanServerInfo({required this.version, this.debugMode = false, this.dbType, this.gitCommit});

  factory SpoolmanServerInfo.fromJson(Map<String, dynamic> json) => SpoolmanServerInfo(
        version: '${json['version'] ?? '0.0.0'}',
        debugMode: json['debug_mode'] == true,
        dbType: json['db_type'] as String?,
        gitCommit: json['git_commit'] as String?,
      );

  final String version;
  final bool debugMode;
  final String? dbType;
  final String? gitCommit;

  List<int> get _parts => version.split('.').map((e) => int.tryParse(e.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0).toList();

  int compareVersion(int major, int minor, int patch) {
    final p = _parts;
    final mine = [p.elementAtOrNull(0) ?? 0, p.elementAtOrNull(1) ?? 0, p.elementAtOrNull(2) ?? 0];
    for (final (i, v) in [major, minor, patch].indexed) {
      if (mine[i] != v) return mine[i].compareTo(v);
    }
    return 0;
  }
}
