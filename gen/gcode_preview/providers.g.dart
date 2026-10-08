// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Downloads and parses a gcode file. Progress: 0–0.5 download, 0.5–1 parsing.

@ProviderFor(GcodeStructure)
final gcodeStructureProvider = GcodeStructureFamily._();

/// Downloads and parses a gcode file. Progress: 0–0.5 download, 0.5–1 parsing.
final class GcodeStructureProvider
    extends $AsyncNotifierProvider<GcodeStructure, GCodeStructure> {
  /// Downloads and parses a gcode file. Progress: 0–0.5 download, 0.5–1 parsing.
  GcodeStructureProvider._({
    required GcodeStructureFamily super.from,
    required (String, GCodeFile) super.argument,
  }) : super(
         retry: null,
         name: r'gcodeStructureProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gcodeStructureHash();

  @override
  String toString() {
    return r'gcodeStructureProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  GcodeStructure create() => GcodeStructure();

  @override
  bool operator ==(Object other) {
    return other is GcodeStructureProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gcodeStructureHash() => r'b393db8c48b8b63bb422329754dd252816464620';

/// Downloads and parses a gcode file. Progress: 0–0.5 download, 0.5–1 parsing.

final class GcodeStructureFamily extends $Family
    with
        $ClassFamilyOverride<
          GcodeStructure,
          AsyncValue<GCodeStructure>,
          GCodeStructure,
          FutureOr<GCodeStructure>,
          (String, GCodeFile)
        > {
  GcodeStructureFamily._()
    : super(
        retry: null,
        name: r'gcodeStructureProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Downloads and parses a gcode file. Progress: 0–0.5 download, 0.5–1 parsing.

  GcodeStructureProvider call(String machineUUID, GCodeFile file) =>
      GcodeStructureProvider._(argument: (machineUUID, file), from: this);

  @override
  String toString() => r'gcodeStructureProvider';
}

/// Downloads and parses a gcode file. Progress: 0–0.5 download, 0.5–1 parsing.

abstract class _$GcodeStructure extends $AsyncNotifier<GCodeStructure> {
  late final _$args = ref.$arg as (String, GCodeFile);
  String get machineUUID => _$args.$1;
  GCodeFile get file => _$args.$2;

  FutureOr<GCodeStructure> build(String machineUUID, GCodeFile file);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GCodeStructure>, GCodeStructure>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GCodeStructure>, GCodeStructure>,
              AsyncValue<GCodeStructure>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
