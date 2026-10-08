// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spoolman_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(spoolmanService)
final spoolmanServiceProvider = SpoolmanServiceFamily._();

final class SpoolmanServiceProvider
    extends
        $FunctionalProvider<SpoolmanService, SpoolmanService, SpoolmanService>
    with $Provider<SpoolmanService> {
  SpoolmanServiceProvider._({
    required SpoolmanServiceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spoolmanServiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spoolmanServiceHash();

  @override
  String toString() {
    return r'spoolmanServiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<SpoolmanService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SpoolmanService create(Ref ref) {
    final argument = this.argument as String;
    return spoolmanService(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpoolmanService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpoolmanService>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpoolmanServiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spoolmanServiceHash() => r'cd70dad1b1d2bb7d581a45b4b68eb276671061cb';

final class SpoolmanServiceFamily extends $Family
    with $FunctionalFamilyOverride<SpoolmanService, String> {
  SpoolmanServiceFamily._()
    : super(
        retry: null,
        name: r'spoolmanServiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpoolmanServiceProvider call(String machineUUID) =>
      SpoolmanServiceProvider._(argument: machineUUID, from: this);

  @override
  String toString() => r'spoolmanServiceProvider';
}

@ProviderFor(_allSpools)
final _allSpoolsProvider = _AllSpoolsFamily._();

final class _AllSpoolsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GetSpool>>,
          List<GetSpool>,
          FutureOr<List<GetSpool>>
        >
    with $FutureModifier<List<GetSpool>>, $FutureProvider<List<GetSpool>> {
  _AllSpoolsProvider._({
    required _AllSpoolsFamily super.from,
    required (String, SpoolmanFilter) super.argument,
  }) : super(
         retry: null,
         name: r'_allSpoolsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_allSpoolsHash();

  @override
  String toString() {
    return r'_allSpoolsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<GetSpool>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GetSpool>> create(Ref ref) {
    final argument = this.argument as (String, SpoolmanFilter);
    return _allSpools(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is _AllSpoolsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_allSpoolsHash() => r'82e6295320e0f55059cfed5afdc6a016b0834e31';

final class _AllSpoolsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GetSpool>>,
          (String, SpoolmanFilter)
        > {
  _AllSpoolsFamily._()
    : super(
        retry: null,
        name: r'_allSpoolsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _AllSpoolsProvider call(String machineUUID, SpoolmanFilter filters) =>
      _AllSpoolsProvider._(argument: (machineUUID, filters), from: this);

  @override
  String toString() => r'_allSpoolsProvider';
}

@ProviderFor(_allFilaments)
final _allFilamentsProvider = _AllFilamentsFamily._();

final class _AllFilamentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GetFilament>>,
          List<GetFilament>,
          FutureOr<List<GetFilament>>
        >
    with
        $FutureModifier<List<GetFilament>>,
        $FutureProvider<List<GetFilament>> {
  _AllFilamentsProvider._({
    required _AllFilamentsFamily super.from,
    required (String, SpoolmanFilter) super.argument,
  }) : super(
         retry: null,
         name: r'_allFilamentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_allFilamentsHash();

  @override
  String toString() {
    return r'_allFilamentsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<GetFilament>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GetFilament>> create(Ref ref) {
    final argument = this.argument as (String, SpoolmanFilter);
    return _allFilaments(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is _AllFilamentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_allFilamentsHash() => r'07fb4cdcb5520cd55fc44e443ecc3762046675f1';

final class _AllFilamentsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GetFilament>>,
          (String, SpoolmanFilter)
        > {
  _AllFilamentsFamily._()
    : super(
        retry: null,
        name: r'_allFilamentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _AllFilamentsProvider call(String machineUUID, SpoolmanFilter filters) =>
      _AllFilamentsProvider._(argument: (machineUUID, filters), from: this);

  @override
  String toString() => r'_allFilamentsProvider';
}

@ProviderFor(_allVendors)
final _allVendorsProvider = _AllVendorsFamily._();

final class _AllVendorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GetVendor>>,
          List<GetVendor>,
          FutureOr<List<GetVendor>>
        >
    with $FutureModifier<List<GetVendor>>, $FutureProvider<List<GetVendor>> {
  _AllVendorsProvider._({
    required _AllVendorsFamily super.from,
    required (String, SpoolmanFilter) super.argument,
  }) : super(
         retry: null,
         name: r'_allVendorsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_allVendorsHash();

  @override
  String toString() {
    return r'_allVendorsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<GetVendor>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GetVendor>> create(Ref ref) {
    final argument = this.argument as (String, SpoolmanFilter);
    return _allVendors(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is _AllVendorsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_allVendorsHash() => r'33c998adc4443d323783badb8c041bbdc15688cf';

final class _AllVendorsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GetVendor>>,
          (String, SpoolmanFilter)
        > {
  _AllVendorsFamily._()
    : super(
        retry: null,
        name: r'_allVendorsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _AllVendorsProvider call(String machineUUID, SpoolmanFilter filters) =>
      _AllVendorsProvider._(argument: (machineUUID, filters), from: this);

  @override
  String toString() => r'_allVendorsProvider';
}

@ProviderFor(spoolList)
final spoolListProvider = SpoolListFamily._();

final class SpoolListProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginationResult<GetSpool>>,
          PaginationResult<GetSpool>,
          FutureOr<PaginationResult<GetSpool>>
        >
    with
        $FutureModifier<PaginationResult<GetSpool>>,
        $FutureProvider<PaginationResult<GetSpool>> {
  SpoolListProvider._({
    required SpoolListFamily super.from,
    required (String, {int? page, int? pageSize, SpoolmanFilter? filters})
    super.argument,
  }) : super(
         retry: null,
         name: r'spoolListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spoolListHash();

  @override
  String toString() {
    return r'spoolListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PaginationResult<GetSpool>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginationResult<GetSpool>> create(Ref ref) {
    final argument =
        this.argument
            as (String, {int? page, int? pageSize, SpoolmanFilter? filters});
    return spoolList(
      ref,
      argument.$1,
      page: argument.page,
      pageSize: argument.pageSize,
      filters: argument.filters,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpoolListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spoolListHash() => r'5e41553121a65907daff7cd513a4fa679e30de67';

final class SpoolListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginationResult<GetSpool>>,
          (String, {int? page, int? pageSize, SpoolmanFilter? filters})
        > {
  SpoolListFamily._()
    : super(
        retry: null,
        name: r'spoolListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpoolListProvider call(
    String machineUUID, {
    int? page,
    int? pageSize,
    SpoolmanFilter? filters,
  }) => SpoolListProvider._(
    argument: (machineUUID, page: page, pageSize: pageSize, filters: filters),
    from: this,
  );

  @override
  String toString() => r'spoolListProvider';
}

@ProviderFor(filamentList)
final filamentListProvider = FilamentListFamily._();

final class FilamentListProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginationResult<GetFilament>>,
          PaginationResult<GetFilament>,
          FutureOr<PaginationResult<GetFilament>>
        >
    with
        $FutureModifier<PaginationResult<GetFilament>>,
        $FutureProvider<PaginationResult<GetFilament>> {
  FilamentListProvider._({
    required FilamentListFamily super.from,
    required (String, {int? page, int? pageSize, SpoolmanFilter? filters})
    super.argument,
  }) : super(
         retry: null,
         name: r'filamentListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filamentListHash();

  @override
  String toString() {
    return r'filamentListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PaginationResult<GetFilament>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginationResult<GetFilament>> create(Ref ref) {
    final argument =
        this.argument
            as (String, {int? page, int? pageSize, SpoolmanFilter? filters});
    return filamentList(
      ref,
      argument.$1,
      page: argument.page,
      pageSize: argument.pageSize,
      filters: argument.filters,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilamentListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filamentListHash() => r'08d3a0bfd421543dc12a10d04f640b5bea603ec2';

final class FilamentListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginationResult<GetFilament>>,
          (String, {int? page, int? pageSize, SpoolmanFilter? filters})
        > {
  FilamentListFamily._()
    : super(
        retry: null,
        name: r'filamentListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilamentListProvider call(
    String machineUUID, {
    int? page,
    int? pageSize,
    SpoolmanFilter? filters,
  }) => FilamentListProvider._(
    argument: (machineUUID, page: page, pageSize: pageSize, filters: filters),
    from: this,
  );

  @override
  String toString() => r'filamentListProvider';
}

@ProviderFor(vendorList)
final vendorListProvider = VendorListFamily._();

final class VendorListProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginationResult<GetVendor>>,
          PaginationResult<GetVendor>,
          FutureOr<PaginationResult<GetVendor>>
        >
    with
        $FutureModifier<PaginationResult<GetVendor>>,
        $FutureProvider<PaginationResult<GetVendor>> {
  VendorListProvider._({
    required VendorListFamily super.from,
    required (String, {int? page, int? pageSize, SpoolmanFilter? filters})
    super.argument,
  }) : super(
         retry: null,
         name: r'vendorListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vendorListHash();

  @override
  String toString() {
    return r'vendorListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PaginationResult<GetVendor>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginationResult<GetVendor>> create(Ref ref) {
    final argument =
        this.argument
            as (String, {int? page, int? pageSize, SpoolmanFilter? filters});
    return vendorList(
      ref,
      argument.$1,
      page: argument.page,
      pageSize: argument.pageSize,
      filters: argument.filters,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VendorListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vendorListHash() => r'6fc94987f5e17d2a90dc16da1fdc61b78dad4963';

final class VendorListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginationResult<GetVendor>>,
          (String, {int? page, int? pageSize, SpoolmanFilter? filters})
        > {
  VendorListFamily._()
    : super(
        retry: null,
        name: r'vendorListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VendorListProvider call(
    String machineUUID, {
    int? page,
    int? pageSize,
    SpoolmanFilter? filters,
  }) => VendorListProvider._(
    argument: (machineUUID, page: page, pageSize: pageSize, filters: filters),
    from: this,
  );

  @override
  String toString() => r'vendorListProvider';
}

@ProviderFor(spool)
final spoolProvider = SpoolFamily._();

final class SpoolProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetSpool?>,
          GetSpool?,
          FutureOr<GetSpool?>
        >
    with $FutureModifier<GetSpool?>, $FutureProvider<GetSpool?> {
  SpoolProvider._({
    required SpoolFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'spoolProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spoolHash();

  @override
  String toString() {
    return r'spoolProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GetSpool?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<GetSpool?> create(Ref ref) {
    final argument = this.argument as (String, int);
    return spool(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SpoolProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spoolHash() => r'9681239b2503864f30e33ef8754c2dcd7efa4289';

final class SpoolFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GetSpool?>, (String, int)> {
  SpoolFamily._()
    : super(
        retry: null,
        name: r'spoolProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpoolProvider call(String machineUUID, int id) =>
      SpoolProvider._(argument: (machineUUID, id), from: this);

  @override
  String toString() => r'spoolProvider';
}

@ProviderFor(filament)
final filamentProvider = FilamentFamily._();

final class FilamentProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetFilament?>,
          GetFilament?,
          FutureOr<GetFilament?>
        >
    with $FutureModifier<GetFilament?>, $FutureProvider<GetFilament?> {
  FilamentProvider._({
    required FilamentFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'filamentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filamentHash();

  @override
  String toString() {
    return r'filamentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GetFilament?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetFilament?> create(Ref ref) {
    final argument = this.argument as (String, int);
    return filament(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is FilamentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filamentHash() => r'b20b190448004a6a8141b7eb8d5f1639157c60c2';

final class FilamentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GetFilament?>, (String, int)> {
  FilamentFamily._()
    : super(
        retry: null,
        name: r'filamentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilamentProvider call(String machineUUID, int id) =>
      FilamentProvider._(argument: (machineUUID, id), from: this);

  @override
  String toString() => r'filamentProvider';
}

@ProviderFor(vendor)
final vendorProvider = VendorFamily._();

final class VendorProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetVendor?>,
          GetVendor?,
          FutureOr<GetVendor?>
        >
    with $FutureModifier<GetVendor?>, $FutureProvider<GetVendor?> {
  VendorProvider._({
    required VendorFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'vendorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vendorHash();

  @override
  String toString() {
    return r'vendorProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GetVendor?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<GetVendor?> create(Ref ref) {
    final argument = this.argument as (String, int);
    return vendor(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is VendorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vendorHash() => r'38ee14590987ee27c3b47d23c6cf9326440437d5';

final class VendorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GetVendor?>, (String, int)> {
  VendorFamily._()
    : super(
        retry: null,
        name: r'vendorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VendorProvider call(String machineUUID, int id) =>
      VendorProvider._(argument: (machineUUID, id), from: this);

  @override
  String toString() => r'vendorProvider';
}

/// Id of the spool Moonraker currently tracks usage for (null = none).

@ProviderFor(activeSpoolId)
final activeSpoolIdProvider = ActiveSpoolIdFamily._();

/// Id of the spool Moonraker currently tracks usage for (null = none).

final class ActiveSpoolIdProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, Stream<int?>>
    with $FutureModifier<int?>, $StreamProvider<int?> {
  /// Id of the spool Moonraker currently tracks usage for (null = none).
  ActiveSpoolIdProvider._({
    required ActiveSpoolIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeSpoolIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeSpoolIdHash();

  @override
  String toString() {
    return r'activeSpoolIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int?> create(Ref ref) {
    final argument = this.argument as String;
    return activeSpoolId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveSpoolIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeSpoolIdHash() => r'397943353a0506b9d843327f7d82ca912dd47825';

/// Id of the spool Moonraker currently tracks usage for (null = none).

final class ActiveSpoolIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int?>, String> {
  ActiveSpoolIdFamily._()
    : super(
        retry: null,
        name: r'activeSpoolIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Id of the spool Moonraker currently tracks usage for (null = none).

  ActiveSpoolIdProvider call(String machineUUID) =>
      ActiveSpoolIdProvider._(argument: machineUUID, from: this);

  @override
  String toString() => r'activeSpoolIdProvider';
}

@ProviderFor(activeSpool)
final activeSpoolProvider = ActiveSpoolFamily._();

final class ActiveSpoolProvider
    extends
        $FunctionalProvider<AsyncValue<GetSpool?>, GetSpool?, Stream<GetSpool?>>
    with $FutureModifier<GetSpool?>, $StreamProvider<GetSpool?> {
  ActiveSpoolProvider._({
    required ActiveSpoolFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeSpoolProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeSpoolHash();

  @override
  String toString() {
    return r'activeSpoolProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<GetSpool?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<GetSpool?> create(Ref ref) {
    final argument = this.argument as String;
    return activeSpool(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveSpoolProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeSpoolHash() => r'a44dff82533c0b004b1edc9b7feba797b69daaae';

final class ActiveSpoolFamily extends $Family
    with $FunctionalFamilyOverride<Stream<GetSpool?>, String> {
  ActiveSpoolFamily._()
    : super(
        retry: null,
        name: r'activeSpoolProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActiveSpoolProvider call(String machineUUID) =>
      ActiveSpoolProvider._(argument: machineUUID, from: this);

  @override
  String toString() => r'activeSpoolProvider';
}

@ProviderFor(_spoolmanCurrencyAsync)
final _spoolmanCurrencyAsyncProvider = _SpoolmanCurrencyAsyncFamily._();

final class _SpoolmanCurrencyAsyncProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  _SpoolmanCurrencyAsyncProvider._({
    required _SpoolmanCurrencyAsyncFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_spoolmanCurrencyAsyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_spoolmanCurrencyAsyncHash();

  @override
  String toString() {
    return r'_spoolmanCurrencyAsyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String;
    return _spoolmanCurrencyAsync(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is _SpoolmanCurrencyAsyncProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_spoolmanCurrencyAsyncHash() =>
    r'a78ce9bc784873483a1bc72ded5951256d42c837';

final class _SpoolmanCurrencyAsyncFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String> {
  _SpoolmanCurrencyAsyncFamily._()
    : super(
        retry: null,
        name: r'_spoolmanCurrencyAsyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _SpoolmanCurrencyAsyncProvider call(String machineUUID) =>
      _SpoolmanCurrencyAsyncProvider._(argument: machineUUID, from: this);

  @override
  String toString() => r'_spoolmanCurrencyAsyncProvider';
}

/// Currency code configured in Spoolman (e.g. `EUR`, `DKK`). Null while loading/unknown.

@ProviderFor(spoolmanCurrency)
final spoolmanCurrencyProvider = SpoolmanCurrencyFamily._();

/// Currency code configured in Spoolman (e.g. `EUR`, `DKK`). Null while loading/unknown.

final class SpoolmanCurrencyProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Currency code configured in Spoolman (e.g. `EUR`, `DKK`). Null while loading/unknown.
  SpoolmanCurrencyProvider._({
    required SpoolmanCurrencyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spoolmanCurrencyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spoolmanCurrencyHash();

  @override
  String toString() {
    return r'spoolmanCurrencyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as String;
    return spoolmanCurrency(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpoolmanCurrencyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spoolmanCurrencyHash() => r'9053eb1804c3dd1e4fd7ec625f453cbe33d98101';

/// Currency code configured in Spoolman (e.g. `EUR`, `DKK`). Null while loading/unknown.

final class SpoolmanCurrencyFamily extends $Family
    with $FunctionalFamilyOverride<String?, String> {
  SpoolmanCurrencyFamily._()
    : super(
        retry: null,
        name: r'spoolmanCurrencyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Currency code configured in Spoolman (e.g. `EUR`, `DKK`). Null while loading/unknown.

  SpoolmanCurrencyProvider call(String machineUUID) =>
      SpoolmanCurrencyProvider._(argument: machineUUID, from: this);

  @override
  String toString() => r'spoolmanCurrencyProvider';
}

@ProviderFor(spoolmanExtraFields)
final spoolmanExtraFieldsProvider = SpoolmanExtraFieldsFamily._();

final class SpoolmanExtraFieldsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SpoolmanExtraField>>,
          List<SpoolmanExtraField>,
          FutureOr<List<SpoolmanExtraField>>
        >
    with
        $FutureModifier<List<SpoolmanExtraField>>,
        $FutureProvider<List<SpoolmanExtraField>> {
  SpoolmanExtraFieldsProvider._({
    required SpoolmanExtraFieldsFamily super.from,
    required (String, SpoolmanEntityType) super.argument,
  }) : super(
         retry: null,
         name: r'spoolmanExtraFieldsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spoolmanExtraFieldsHash();

  @override
  String toString() {
    return r'spoolmanExtraFieldsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SpoolmanExtraField>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SpoolmanExtraField>> create(Ref ref) {
    final argument = this.argument as (String, SpoolmanEntityType);
    return spoolmanExtraFields(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SpoolmanExtraFieldsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spoolmanExtraFieldsHash() =>
    r'0cba74770929e93f66d07b50126120fdce3fd667';

final class SpoolmanExtraFieldsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SpoolmanExtraField>>,
          (String, SpoolmanEntityType)
        > {
  SpoolmanExtraFieldsFamily._()
    : super(
        retry: null,
        name: r'spoolmanExtraFieldsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpoolmanExtraFieldsProvider call(
    String machineUUID,
    SpoolmanEntityType type,
  ) => SpoolmanExtraFieldsProvider._(argument: (machineUUID, type), from: this);

  @override
  String toString() => r'spoolmanExtraFieldsProvider';
}

@ProviderFor(spoolmanServerInfo)
final spoolmanServerInfoProvider = SpoolmanServerInfoFamily._();

final class SpoolmanServerInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<SpoolmanServerInfo>,
          SpoolmanServerInfo,
          FutureOr<SpoolmanServerInfo>
        >
    with
        $FutureModifier<SpoolmanServerInfo>,
        $FutureProvider<SpoolmanServerInfo> {
  SpoolmanServerInfoProvider._({
    required SpoolmanServerInfoFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spoolmanServerInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spoolmanServerInfoHash();

  @override
  String toString() {
    return r'spoolmanServerInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SpoolmanServerInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SpoolmanServerInfo> create(Ref ref) {
    final argument = this.argument as String;
    return spoolmanServerInfo(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpoolmanServerInfoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spoolmanServerInfoHash() =>
    r'97ee54ab428750dc2c86ac2b9f2816f4bb101544';

final class SpoolmanServerInfoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SpoolmanServerInfo>, String> {
  SpoolmanServerInfoFamily._()
    : super(
        retry: null,
        name: r'spoolmanServerInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpoolmanServerInfoProvider call(String machineUUID) =>
      SpoolmanServerInfoProvider._(argument: machineUUID, from: this);

  @override
  String toString() => r'spoolmanServerInfoProvider';
}
