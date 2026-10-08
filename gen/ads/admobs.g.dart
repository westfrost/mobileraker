// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admobs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Always resolves to `null` – no ads in this build.

@ProviderFor(bannerAd)
final bannerAdProvider = BannerAdFamily._();

/// Always resolves to `null` – no ads in this build.

final class BannerAdProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdWithView?>,
          AdWithView?,
          FutureOr<AdWithView?>
        >
    with $FutureModifier<AdWithView?>, $FutureProvider<AdWithView?> {
  /// Always resolves to `null` – no ads in this build.
  BannerAdProvider._({
    required BannerAdFamily super.from,
    required (AdSize, AdBlockUnit) super.argument,
  }) : super(
         retry: null,
         name: r'bannerAdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bannerAdHash();

  @override
  String toString() {
    return r'bannerAdProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<AdWithView?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdWithView?> create(Ref ref) {
    final argument = this.argument as (AdSize, AdBlockUnit);
    return bannerAd(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BannerAdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bannerAdHash() => r'e679e47c07ea01ca8a47bf649b83db28ca9d49dd';

/// Always resolves to `null` – no ads in this build.

final class BannerAdFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<AdWithView?>,
          (AdSize, AdBlockUnit)
        > {
  BannerAdFamily._()
    : super(
        retry: null,
        name: r'bannerAdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Always resolves to `null` – no ads in this build.

  BannerAdProvider call(AdSize size, AdBlockUnit unit) =>
      BannerAdProvider._(argument: (size, unit), from: this);

  @override
  String toString() => r'bannerAdProvider';
}

/// No consent form needed because nothing is tracked or advertised.

@ProviderFor(isConsentFormAvailable)
final isConsentFormAvailableProvider = IsConsentFormAvailableProvider._();

/// No consent form needed because nothing is tracked or advertised.

final class IsConsentFormAvailableProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// No consent form needed because nothing is tracked or advertised.
  IsConsentFormAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isConsentFormAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isConsentFormAvailableHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isConsentFormAvailable(ref);
  }
}

String _$isConsentFormAvailableHash() =>
    r'd68e451d94ad55e47cc692d798f51fcf95d2959a';
