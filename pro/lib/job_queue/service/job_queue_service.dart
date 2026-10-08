/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 *
 * Wraps Moonraker's [job_queue] component (server.job_queue.*).
 */

import 'dart:async';

import 'package:common/data/dto/job_queue/job_queue_entry.dart';
import 'package:common/data/dto/job_queue/job_queue_event.dart';
import 'package:common/data/dto/job_queue/job_queue_status.dart';
import 'package:common/network/jrpc_client_provider.dart';
import 'package:common/network/json_rpc_client.dart';
import 'package:common/service/selected_machine_service.dart';
import 'package:common/util/extensions/ref_extension.dart';
import 'package:common/util/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_queue_service.g.dart';

@riverpod
JobQueueService jobQueueService(Ref ref, String machineUUID) {
  ref.keepAliveFor(const Duration(minutes: 2));
  return JobQueueService(ref, machineUUID);
}

/// Live state of Moonraker's job queue for a machine.
@riverpod
Stream<JobQueueStatus> jobQueue(Ref ref, String machineUUID) async* {
  ref.keepAliveFor(const Duration(minutes: 1));
  final service = ref.watch(jobQueueServiceProvider(machineUUID));
  // Re-fetch once the connection is (re)established.
  final state = await ref.watch(jrpcClientStateProvider(machineUUID).future);
  if (state != ClientState.connected) return;

  final controller = StreamController<JobQueueStatus>();
  ref.onDispose(controller.close);

  ref.listen(jrpcMethodEventProvider(machineUUID, 'notify_job_queue_changed'), (_, next) {
    final params = next.value?['params'];
    final payload = params is List && params.isNotEmpty ? params.first : null;
    if (payload is! Map) return;
    try {
      final event = JobQueueEvent.fromJson(payload.cast<String, dynamic>());
      if (event.updatedQueue != null) {
        controller.add(JobQueueStatus(queuedJobs: event.updatedQueue!, queueState: event.queueState));
      } else {
        // state change only, fetch fresh status
        service.fetchStatus().then(controller.add, onError: (_) {});
      }
    } catch (e, s) {
      talker.warning('[JobQueue] Could not parse queue event', e, s);
    }
  });

  try {
    controller.add(await service.fetchStatus());
  } on JRpcError catch (e) {
    // Moonraker without [job_queue] -> report an empty, ready queue.
    talker.info('[JobQueue@$machineUUID] Job queue not available: ${e.message}');
    controller.add(JobQueueStatus(queueState: QueueState.ready));
  }
  yield* controller.stream;
}

@riverpod
Future<JobQueueStatus?> jobQueueSelected(Ref ref) async {
  final machine = await ref.watch(selectedMachineProvider.future);
  if (machine == null) return null;
  return ref.watch(jobQueueProvider(machine.uuid).future);
}

class JobQueueService {
  JobQueueService(this._ref, this.machineUUID);

  final Ref _ref;
  final String machineUUID;

  JsonRpcClient get _client => _ref.read(jrpcClientProvider(machineUUID));

  Future<JobQueueStatus> fetchStatus() async {
    final resp = await _client.sendJRpcMethod('server.job_queue.status');
    return JobQueueStatus.fromJson(resp.result);
  }

  Future<void> enqueueJob(String filename) => enqueueJobs([filename]);

  Future<void> enqueueJobs(List<String> filenames) async {
    talker.info('[JobQueue@$machineUUID] Enqueue $filenames');
    await _client.sendJRpcMethod('server.job_queue.post_job', params: {'filenames': filenames});
  }

  Future<void> removeJobs(List<JobQueueEntry> jobs) async {
    if (jobs.isEmpty) return;
    await _client.sendJRpcMethod('server.job_queue.delete_job', params: {'job_ids': [for (final j in jobs) j.jobId]});
  }

  Future<void> clearQueue() => _client.sendJRpcMethod('server.job_queue.delete_job', params: {'all': true});

  Future<void> startQueue() => _client.sendJRpcMethod('server.job_queue.start');

  Future<void> pauseQueue() => _client.sendJRpcMethod('server.job_queue.pause');

  /// Moves a job to the front of the queue.
  Future<void> jumpToFront(JobQueueEntry job) =>
      _client.sendJRpcMethod('server.job_queue.jump', params: {'job_id': job.jobId});
}
