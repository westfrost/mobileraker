// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_layout_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardLayoutService)
final dashboardLayoutServiceProvider = DashboardLayoutServiceProvider._();

final class DashboardLayoutServiceProvider
    extends
        $FunctionalProvider<
          DashboardLayoutService,
          DashboardLayoutService,
          DashboardLayoutService
        >
    with $Provider<DashboardLayoutService> {
  DashboardLayoutServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardLayoutServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardLayoutServiceHash();

  @$internal
  @override
  $ProviderElement<DashboardLayoutService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DashboardLayoutService create(Ref ref) {
    return dashboardLayoutService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardLayoutService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardLayoutService>(value),
    );
  }
}

String _$dashboardLayoutServiceHash() =>
    r'7b37bfc49dba66c0a10b2b70195e6f17848e5533';

/// The layout used for the dashboard of [machineUUID]. Falls back to the built-in default.

@ProviderFor(dashboardLayoutForMachine)
final dashboardLayoutForMachineProvider = DashboardLayoutForMachineFamily._();

/// The layout used for the dashboard of [machineUUID]. Falls back to the built-in default.

final class DashboardLayoutForMachineProvider
    extends
        $FunctionalProvider<
          AsyncValue<DashboardLayout>,
          DashboardLayout,
          FutureOr<DashboardLayout>
        >
    with $FutureModifier<DashboardLayout>, $FutureProvider<DashboardLayout> {
  /// The layout used for the dashboard of [machineUUID]. Falls back to the built-in default.
  DashboardLayoutForMachineProvider._({
    required DashboardLayoutForMachineFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dashboardLayoutForMachineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dashboardLayoutForMachineHash();

  @override
  String toString() {
    return r'dashboardLayoutForMachineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DashboardLayout> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DashboardLayout> create(Ref ref) {
    final argument = this.argument as String;
    return dashboardLayoutForMachine(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardLayoutForMachineProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dashboardLayoutForMachineHash() =>
    r'9e5e5685aba424cd49875503795e9e864badb73d';

/// The layout used for the dashboard of [machineUUID]. Falls back to the built-in default.

final class DashboardLayoutForMachineFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DashboardLayout>, String> {
  DashboardLayoutForMachineFamily._()
    : super(
        retry: null,
        name: r'dashboardLayoutForMachineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The layout used for the dashboard of [machineUUID]. Falls back to the built-in default.

  DashboardLayoutForMachineProvider call(String machineUUID) =>
      DashboardLayoutForMachineProvider._(argument: machineUUID, from: this);

  @override
  String toString() => r'dashboardLayoutForMachineProvider';
}
