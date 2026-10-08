/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:common/data/dto/job_queue/job_queue_entry.dart';
import 'package:common/data/dto/job_queue/job_queue_status.dart';
import 'package:common/service/selected_machine_service.dart';
import 'package:common/service/ui/dialog_service_interface.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../service/job_queue_service.dart';

/// Bottom sheet to manage Moonraker's job queue of the selected printer.
class JobQueueBottomSheet extends ConsumerWidget {
  const JobQueueBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machineUUID = ref.watch(selectedMachineProvider).value?.uuid;
    if (machineUUID == null) return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));

    final queue = ref.watch(jobQueueProvider(machineUUID));
    final service = ref.watch(jobQueueServiceProvider(machineUUID));
    final themeData = Theme.of(context);
    final status = queue.value;
    final isPaused = status?.queueState == QueueState.paused;
    final hasJobs = status?.queuedJobs.isNotEmpty == true;

    final topBar = PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ListTile(
        leading: const Icon(Icons.content_paste),
        title: Text(tr('pages.paywall.benefits.job_queue_perk.title')),
        subtitle: status == null ? null : Text(status.queueState.name),
        trailing: hasJobs
            ? IconButton(
                tooltip: tr('bottom_sheets.job_queue_sheet.remove_all'),
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () async {
                  final res = await ref.read(dialogServiceProvider).showDangerConfirm(
                        title: tr('bottom_sheets.job_queue_sheet.remove_all'),
                        body: tr('bottom_sheets.job_queue_sheet.remove_all_confirm'),
                        actionLabel: tr('general.clear'),
                      );
                  if (res?.confirmed == true) await service.clearQueue();
                },
              )
            : null,
      ),
    );

    Widget body;
    if (status == null) {
      body = SizedBox(
        height: 160,
        child: Center(
          child: queue.hasError ? Text('${queue.error}') : const CircularProgressIndicator.adaptive(),
        ),
      );
    } else if (!hasJobs) {
      body = Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          tr('bottom_sheets.job_queue_sheet.empty'),
          textAlign: TextAlign.center,
          style: themeData.textTheme.bodyMedium,
        ),
      );
    } else {
      final jobs = status.queuedJobs;
      body = ListView.builder(
        shrinkWrap: true,
        itemCount: jobs.length,
        itemBuilder: (context, i) => _JobTile(
          job: jobs[i],
          isNext: i == 0,
          onRemove: () => service.removeJobs([jobs[i]]),
          onJump: i == 0 ? null : () => service.jumpToFront(jobs[i]),
        ),
      );
    }

    final bottomBar = hasJobs
        ? SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(
                    isPaused
                        ? tr('bottom_sheets.job_queue_sheet.start_queue')
                        : tr('bottom_sheets.job_queue_sheet.pause_queue'),
                  ),
                  onPressed: isPaused ? service.startQueue : service.pauseQueue,
                ),
              ),
            ),
          )
        : null;

    return SheetContentScaffold(
      topBar: topBar,
      body: body,
      bottomBar: bottomBar,
      bottomBarVisibility: BottomBarVisibility.always(),
    );
  }
}

class _JobTile extends StatelessWidget {
  const _JobTile({required this.job, required this.isNext, required this.onRemove, this.onJump});

  final JobQueueEntry job;
  final bool isNext;
  final VoidCallback onRemove;
  final VoidCallback? onJump;

  @override
  Widget build(BuildContext context) {
    final name = job.filename.split('/').last;
    final folder = job.filename.contains('/') ? job.filename.substring(0, job.filename.lastIndexOf('/')) : null;
    return Dismissible(
      key: ValueKey(job.jobId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      child: ListTile(
        leading: Icon(isNext ? Icons.play_circle_outline : Icons.schedule),
        title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          isNext ? tr('bottom_sheets.job_queue_sheet.next') : (folder ?? ''),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onJump != null) IconButton(icon: const Icon(Icons.vertical_align_top), onPressed: onJump),
            IconButton(icon: const Icon(Icons.close), onPressed: onRemove),
          ],
        ),
      ),
    );
  }
}
