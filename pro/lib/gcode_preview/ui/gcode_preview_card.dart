/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:common/data/dto/config/config_file.dart';
import 'package:common/data/dto/files/gcode_file.dart';
import 'package:common/data/dto/machine/print_state_enum.dart';
import 'package:common/service/app_router.dart';
import 'package:common/service/moonraker/printer_service.dart';
import 'package:common/util/extensions/async_ext.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/ui/pro_routes.dart';
import '../data/model/gcode_structure.dart';
import '../gcode_layer_renderer.dart';
import '../providers.dart';
import 'gcode_layer_visualizer.dart';

/// Dashboard card with a live top-down preview of the layer currently printing.
class GCodePreviewCard extends HookConsumerWidget {
  const GCodePreviewCard({super.key, required this.machineUUID});

  static Widget preview() => const _GCodePreviewCardPreview();

  final String machineUUID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final model = ref.watch(
      printerProvider(machineUUID).selectAs(
        (p) => (
          file: p.currentFile,
          config: p.configFile,
          active: p.print.state == PrintState.printing || p.print.state == PrintState.paused,
        ),
      ),
    );
    final data = model.value;
    final started = useState(false);
    final filePath = data?.file?.absolutPath;
    // Reset when another file is printed (keep it running if it is already loaded).
    useEffect(() {
      final f = data?.file;
      started.value = f != null && ref.exists(gcodeStructureProvider(machineUUID, f));
      return null;
    }, [filePath]);

    if (data == null || !data.active || data.file == null) return const SizedBox.shrink();
    final file = data.file!;

    final kinematics = data.config.configPrinter?.kinematics ?? 'cartesian';
    final supported = !kinematics.contains('delta') && !kinematics.contains('polar');

    Widget body;
    if (!supported) {
      body = Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: const Text('pages.dashboard.control.gcode_preview_card.kinematic_not_supported').tr(),
      );
    } else if (!started.value) {
      body = Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              tr('pages.dashboard.control.gcode_preview_card.start_preview.hint'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('pages.dashboard.control.gcode_preview_card.start_preview.btn').tr(),
              onPressed: () => started.value = true,
            ),
          ],
        ),
      );
    } else {
      body = _LiveBody(machineUUID: machineUUID, file: file, config: data.config);
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.layers_outlined),
            title: const Text('pages.dashboard.control.gcode_preview_card.title').tr(),
            subtitle: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: started.value && supported
                ? IconButton(
                    icon: const Icon(Icons.open_in_full),
                    onPressed: () => ref.read(goRouterProvider).pushNamed(
                          ProRoutes.fileManager_exlorer_gcodePreview.name,
                          pathParameters: {'path': file.parentPath},
                          queryParameters: {'machineUUID': machineUUID, 'live': 'true'},
                          extra: file,
                        ),
                  )
                : null,
          ),
          body,
        ],
      ),
    );
  }
}

class _LiveBody extends HookConsumerWidget {
  const _LiveBody({required this.machineUUID, required this.file, required this.config});

  final String machineUUID;
  final GCodeFile file;
  final ConfigFile config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(gcodeStructureProvider(machineUUID, file));
    final themeData = Theme.of(context);

    return switch (async) {
      AsyncData(:final value) => _LiveView(machineUUID: machineUUID, structure: value, config: config),
      AsyncError(:final error) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('$error', style: TextStyle(color: themeData.colorScheme.error)),
        ),
      AsyncLoading(:final progress) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: LinearProgressIndicator(value: progress?.toDouble()),
        ),
    };
  }
}

class _LiveView extends HookConsumerWidget {
  const _LiveView({required this.machineUUID, required this.structure, required this.config});

  final String machineUUID;
  final GCodeStructure structure;
  final ConfigFile config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renderer = useMemoized(() => GCodeLayerRenderer(structure), [structure]);
    final follow = useState(true);
    final manualLayer = useState<int?>(null);

    final filePos = ref.watch(
      printerProvider(machineUUID).selectRequireValue((d) => d.virtualSdCard?.filePosition ?? 0),
    );
    final live = useMemoized(() => renderer.createRenderDataForFilePosition(filePos), [filePos, renderer]);
    final shown = follow.value || manualLayer.value == null
        ? live
        : renderer.createRenderDataForLayer(layerIndex: manualLayer.value!);

    final themeData = Theme.of(context);
    final maxLayer = structure.maxLayer;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: Center(child: GCodeLayerVisualizer(printerConfig: config, currentLayer: shown)),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${tr('components.gcode_preview.layer.one')} ${shown.metaData.layer + 1}/$maxLayer · '
                  'Z ${shown.metaData.z.toStringAsFixed(2)} mm',
                  style: themeData.textTheme.bodySmall,
                ),
              ),
              FilterChip(
                label: const Text('pages.dashboard.control.gcode_preview_card.follow').tr(),
                selected: follow.value,
                onSelected: (v) {
                  follow.value = v;
                  if (!v) manualLayer.value = live.metaData.layer;
                },
              ),
            ],
          ),
          if (!follow.value && maxLayer > 1)
            Slider(
              value: (manualLayer.value ?? live.metaData.layer).toDouble().clamp(0, (maxLayer - 1).toDouble()),
              max: (maxLayer - 1).toDouble(),
              onChanged: (v) => manualLayer.value = v.round(),
            ),
        ],
      ),
    );
  }
}

class _GCodePreviewCardPreview extends StatelessWidget {
  const _GCodePreviewCardPreview();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.layers_outlined),
            title: const Text('pages.dashboard.control.gcode_preview_card.title').tr(),
            subtitle: const Text('benchy.gcode'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(painter: _PreviewPainter(Theme.of(context).colorScheme)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewPainter extends CustomPainter {
  _PreviewPainter(this.scheme);

  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(6)),
      Paint()..color = scheme.surfaceContainerHighest,
    );
    final paint = Paint()
      ..color = scheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final c = size.center(Offset.zero);
    for (var r = size.shortestSide * 0.1; r < size.shortestSide * 0.35; r += size.shortestSide * 0.04) {
      canvas.drawCircle(c, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
