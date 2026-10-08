// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_theme_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customThemeService)
final customThemeServiceProvider = CustomThemeServiceProvider._();

final class CustomThemeServiceProvider
    extends
        $FunctionalProvider<
          CustomThemeService,
          CustomThemeService,
          CustomThemeService
        >
    with $Provider<CustomThemeService> {
  CustomThemeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customThemeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customThemeServiceHash();

  @$internal
  @override
  $ProviderElement<CustomThemeService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomThemeService create(Ref ref) {
    return customThemeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomThemeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomThemeService>(value),
    );
  }
}

String _$customThemeServiceHash() =>
    r'3ceab0a1ca330b7a10feb4efdaf6d67d3525d5aa';

@ProviderFor(customThemePacks)
final customThemePacksProvider = CustomThemePacksProvider._();

final class CustomThemePacksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CustomThemePack>>,
          List<CustomThemePack>,
          Stream<List<CustomThemePack>>
        >
    with
        $FutureModifier<List<CustomThemePack>>,
        $StreamProvider<List<CustomThemePack>> {
  CustomThemePacksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customThemePacksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customThemePacksHash();

  @$internal
  @override
  $StreamProviderElement<List<CustomThemePack>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CustomThemePack>> create(Ref ref) {
    return customThemePacks(ref);
  }
}

String _$customThemePacksHash() => r'970f270088e045d90e495359d91b967260bc85e2';

/// The user's custom themes converted into app [ThemePack]s.

@ProviderFor(customThemePacksAsThemePack)
final customThemePacksAsThemePackProvider =
    CustomThemePacksAsThemePackProvider._();

/// The user's custom themes converted into app [ThemePack]s.

final class CustomThemePacksAsThemePackProvider
    extends
        $FunctionalProvider<List<ThemePack>, List<ThemePack>, List<ThemePack>>
    with $Provider<List<ThemePack>> {
  /// The user's custom themes converted into app [ThemePack]s.
  CustomThemePacksAsThemePackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customThemePacksAsThemePackProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customThemePacksAsThemePackHash();

  @$internal
  @override
  $ProviderElement<List<ThemePack>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<ThemePack> create(Ref ref) {
    return customThemePacksAsThemePack(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ThemePack> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ThemePack>>(value),
    );
  }
}

String _$customThemePacksAsThemePackHash() =>
    r'9410a8aacc314e2c47f4a2bcf52ba5e81f82e4ba';
