/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:collection/collection.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

/// Temperature preset that is broadcast to every printer of a group.
class GroupPreset {
  const GroupPreset({
    required this.uuid,
    required this.name,
    this.extruderTemp = 0,
    this.bedTemp = 0,
    this.customGCode,
  });

  factory GroupPreset.create({required String name, int extruderTemp = 0, int bedTemp = 0, String? customGCode}) =>
      GroupPreset(
        uuid: const Uuid().v4(),
        name: name,
        extruderTemp: extruderTemp,
        bedTemp: bedTemp,
        customGCode: customGCode,
      );

  final String uuid;
  final String name;
  final int extruderTemp;
  final int bedTemp;
  final String? customGCode;

  static const _unset = Object();

  GroupPreset copyWith({String? name, int? extruderTemp, int? bedTemp, Object? customGCode = _unset}) => GroupPreset(
        uuid: uuid,
        name: name ?? this.name,
        extruderTemp: extruderTemp ?? this.extruderTemp,
        bedTemp: bedTemp ?? this.bedTemp,
        customGCode: identical(customGCode, _unset) ? this.customGCode : customGCode as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupPreset &&
          other.uuid == uuid &&
          other.name == name &&
          other.extruderTemp == extruderTemp &&
          other.bedTemp == bedTemp &&
          other.customGCode == customGCode;

  @override
  int get hashCode => Object.hash(uuid, name, extruderTemp, bedTemp, customGCode);

  @override
  String toString() => 'GroupPreset($name, $extruderTemp/$bedTemp)';
}

/// A user defined group of printers for fleet actions (preheat, group console, fleet print).
class PrinterGroup {
  const PrinterGroup({
    required this.uuid,
    required this.name,
    required this.machineUUIDs,
    this.presets = const [],
    required this.created,
    required this.lastModified,
  });

  factory PrinterGroup.create({
    required String name,
    required List<String> machineUUIDs,
    List<GroupPreset> presets = const [],
  }) {
    final now = DateTime.now();
    return PrinterGroup(
      uuid: const Uuid().v4(),
      name: name,
      machineUUIDs: machineUUIDs,
      presets: presets,
      created: now,
      lastModified: now,
    );
  }

  final String uuid;
  final String name;
  final List<String> machineUUIDs;
  final List<GroupPreset> presets;
  final DateTime created;
  final DateTime lastModified;

  bool get hasPresets => presets.isNotEmpty;

  PrinterGroup copyWith({
    String? name,
    List<String>? machineUUIDs,
    List<GroupPreset>? presets,
    DateTime? lastModified,
  }) =>
      PrinterGroup(
        uuid: uuid,
        name: name ?? this.name,
        machineUUIDs: machineUUIDs ?? this.machineUUIDs,
        presets: presets ?? this.presets,
        created: created,
        lastModified: lastModified ?? DateTime.now(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrinterGroup &&
          other.uuid == uuid &&
          other.name == name &&
          const ListEquality().equals(other.machineUUIDs, machineUUIDs) &&
          const ListEquality().equals(other.presets, presets) &&
          other.lastModified == lastModified;

  @override
  int get hashCode =>
      Object.hash(uuid, name, const ListEquality().hash(machineUUIDs), const ListEquality().hash(presets), lastModified);

  @override
  String toString() => 'PrinterGroup($name, ${machineUUIDs.length} printers)';
}

// Hand written Hive adapters (type ids chosen to not clash with the common module).

class GroupPresetAdapter extends TypeAdapter<GroupPreset> {
  @override
  final int typeId = 41;

  @override
  GroupPreset read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return GroupPreset(
      uuid: map['uuid'] as String,
      name: map['name'] as String? ?? '',
      extruderTemp: (map['extruderTemp'] as num?)?.toInt() ?? 0,
      bedTemp: (map['bedTemp'] as num?)?.toInt() ?? 0,
      customGCode: map['customGCode'] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GroupPreset obj) {
    writer.writeMap({
      'uuid': obj.uuid,
      'name': obj.name,
      'extruderTemp': obj.extruderTemp,
      'bedTemp': obj.bedTemp,
      'customGCode': obj.customGCode,
    });
  }
}

class PrinterGroupAdapter extends TypeAdapter<PrinterGroup> {
  @override
  final int typeId = 42;

  @override
  PrinterGroup read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return PrinterGroup(
      uuid: map['uuid'] as String,
      name: map['name'] as String? ?? '',
      machineUUIDs: (map['machineUUIDs'] as List? ?? const []).cast<String>().toList(),
      presets: (map['presets'] as List? ?? const []).cast<GroupPreset>().toList(),
      created: DateTime.fromMillisecondsSinceEpoch((map['created'] as int?) ?? 0),
      lastModified: DateTime.fromMillisecondsSinceEpoch((map['lastModified'] as int?) ?? 0),
    );
  }

  @override
  void write(BinaryWriter writer, PrinterGroup obj) {
    writer.writeMap({
      'uuid': obj.uuid,
      'name': obj.name,
      'machineUUIDs': obj.machineUUIDs,
      'presets': obj.presets,
      'created': obj.created.millisecondsSinceEpoch,
      'lastModified': obj.lastModified.millisecondsSinceEpoch,
    });
  }
}
