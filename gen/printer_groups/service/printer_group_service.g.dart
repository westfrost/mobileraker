// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_group_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(printerGroupService)
final printerGroupServiceProvider = PrinterGroupServiceProvider._();

final class PrinterGroupServiceProvider
    extends
        $FunctionalProvider<
          PrinterGroupService,
          PrinterGroupService,
          PrinterGroupService
        >
    with $Provider<PrinterGroupService> {
  PrinterGroupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printerGroupServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$printerGroupServiceHash();

  @$internal
  @override
  $ProviderElement<PrinterGroupService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PrinterGroupService create(Ref ref) {
    return printerGroupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrinterGroupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrinterGroupService>(value),
    );
  }
}

String _$printerGroupServiceHash() =>
    r'0a95bad62acc171551a79a298e07460aecb5788a';

/// All printer groups, sorted by name. Updates whenever a group is saved or deleted.

@ProviderFor(printerGroups)
final printerGroupsProvider = PrinterGroupsProvider._();

/// All printer groups, sorted by name. Updates whenever a group is saved or deleted.

final class PrinterGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PrinterGroup>>,
          List<PrinterGroup>,
          Stream<List<PrinterGroup>>
        >
    with
        $FutureModifier<List<PrinterGroup>>,
        $StreamProvider<List<PrinterGroup>> {
  /// All printer groups, sorted by name. Updates whenever a group is saved or deleted.
  PrinterGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printerGroupsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$printerGroupsHash();

  @$internal
  @override
  $StreamProviderElement<List<PrinterGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PrinterGroup>> create(Ref ref) {
    return printerGroups(ref);
  }
}

String _$printerGroupsHash() => r'4da575f995612aa45e578f64005e52ad7522f3ee';
