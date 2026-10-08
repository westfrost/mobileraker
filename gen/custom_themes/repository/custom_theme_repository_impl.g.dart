// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_theme_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customThemeRepository)
final customThemeRepositoryProvider = CustomThemeRepositoryProvider._();

final class CustomThemeRepositoryProvider
    extends
        $FunctionalProvider<
          CustomThemeRepository,
          CustomThemeRepository,
          CustomThemeRepository
        >
    with $Provider<CustomThemeRepository> {
  CustomThemeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customThemeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customThemeRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomThemeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomThemeRepository create(Ref ref) {
    return customThemeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomThemeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomThemeRepository>(value),
    );
  }
}

String _$customThemeRepositoryHash() =>
    r'a49fa346800d8214da5147ca11b23c1f12938e7d';
