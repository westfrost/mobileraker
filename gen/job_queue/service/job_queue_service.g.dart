// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_queue_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(jobQueueService)
final jobQueueServiceProvider = JobQueueServiceFamily._();

final class JobQueueServiceProvider
    extends
        $FunctionalProvider<JobQueueService, JobQueueService, JobQueueService>
    with $Provider<JobQueueService> {
  JobQueueServiceProvider._({
    required JobQueueServiceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'jobQueueServiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jobQueueServiceHash();

  @override
  String toString() {
    return r'jobQueueServiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<JobQueueService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JobQueueService create(Ref ref) {
    final argument = this.argument as String;
    return jobQueueService(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobQueueService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobQueueService>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JobQueueServiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jobQueueServiceHash() => r'fdff669125e007eb3084ec8f8bf77ae266977ddf';

final class JobQueueServiceFamily extends $Family
    with $FunctionalFamilyOverride<JobQueueService, String> {
  JobQueueServiceFamily._()
    : super(
        retry: null,
        name: r'jobQueueServiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  JobQueueServiceProvider call(String machineUUID) =>
      JobQueueServiceProvider._(argument: machineUUID, from: this);

  @override
  String toString() => r'jobQueueServiceProvider';
}

/// Live state of Moonraker's job queue for a machine.

@ProviderFor(jobQueue)
final jobQueueProvider = JobQueueFamily._();

/// Live state of Moonraker's job queue for a machine.

final class JobQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<JobQueueStatus>,
          JobQueueStatus,
          Stream<JobQueueStatus>
        >
    with $FutureModifier<JobQueueStatus>, $StreamProvider<JobQueueStatus> {
  /// Live state of Moonraker's job queue for a machine.
  JobQueueProvider._({
    required JobQueueFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'jobQueueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jobQueueHash();

  @override
  String toString() {
    return r'jobQueueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<JobQueueStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<JobQueueStatus> create(Ref ref) {
    final argument = this.argument as String;
    return jobQueue(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is JobQueueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jobQueueHash() => r'1bcb833420f8c6344af0e287c2892e40e642481b';

/// Live state of Moonraker's job queue for a machine.

final class JobQueueFamily extends $Family
    with $FunctionalFamilyOverride<Stream<JobQueueStatus>, String> {
  JobQueueFamily._()
    : super(
        retry: null,
        name: r'jobQueueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Live state of Moonraker's job queue for a machine.

  JobQueueProvider call(String machineUUID) =>
      JobQueueProvider._(argument: machineUUID, from: this);

  @override
  String toString() => r'jobQueueProvider';
}

@ProviderFor(jobQueueSelected)
final jobQueueSelectedProvider = JobQueueSelectedProvider._();

final class JobQueueSelectedProvider
    extends
        $FunctionalProvider<
          AsyncValue<JobQueueStatus?>,
          JobQueueStatus?,
          FutureOr<JobQueueStatus?>
        >
    with $FutureModifier<JobQueueStatus?>, $FutureProvider<JobQueueStatus?> {
  JobQueueSelectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobQueueSelectedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobQueueSelectedHash();

  @$internal
  @override
  $FutureProviderElement<JobQueueStatus?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<JobQueueStatus?> create(Ref ref) {
    return jobQueueSelected(ref);
  }
}

String _$jobQueueSelectedHash() => r'527755355f0ce0c231a528d3fea9667c0f12bbc2';
