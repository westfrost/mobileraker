/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:math';

import 'package:common/data/dto/config/config_file.dart';
import 'package:common/service/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/model/gcode_visualizer_settings_key.dart';
import '../gcode_layer_renderer.dart';

/// Top-down 2D rendering of one layer on the printer bed.
class GCodeLayerVisualizer extends ConsumerWidget {
  const GCodeLayerVisualizer({super.key, required this.printerConfig, required this.currentLayer});

  final ConfigFile printerConfig;
  final LayerRenderData currentLayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool setting(GCodeVisualizerSettingsKey key) =>
        ref.watch(boolSettingProvider(key, key.defaultValue as bool? ?? false));

    final widthMultiplier = ref.watch(doubleSettingProvider(GCodeVisualizerSettingsKey.extrusionWidthMultiplier));
    final colorScheme = Theme.of(context).colorScheme;

    final minX = printerConfig.minX;
    final minY = printerConfig.minY;
    final sizeX = max(printerConfig.sizeX, 1.0);
    final sizeY = max(printerConfig.sizeY, 1.0);

    return AspectRatio(
      aspectRatio: sizeX / sizeY,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _LayerPainter(
            data: currentLayer,
            minX: minX,
            minY: minY,
            sizeX: sizeX,
            sizeY: sizeY,
            showGrid: setting(GCodeVisualizerSettingsKey.showGrid),
            showAxes: setting(GCodeVisualizerSettingsKey.showAxes),
            showNext: setting(GCodeVisualizerSettingsKey.showNextLayer),
            showPrevious: setting(GCodeVisualizerSettingsKey.showPreviousLayer),
            showExtrusion: setting(GCodeVisualizerSettingsKey.showExtrusion),
            showRetraction: setting(GCodeVisualizerSettingsKey.showRetraction),
            showTravel: setting(GCodeVisualizerSettingsKey.showTravel),
            extrusionWidth: 0.45 * (widthMultiplier <= 0 ? 1.0 : widthMultiplier),
            colors: _Colors(
              bed: colorScheme.surfaceContainerHighest,
              grid: colorScheme.outlineVariant,
              extrusion: colorScheme.primary,
              upcoming: colorScheme.primary.withValues(alpha: 0.22),
              previous: colorScheme.onSurface.withValues(alpha: 0.18),
              next: colorScheme.secondary.withValues(alpha: 0.18),
              travel: colorScheme.onSurface.withValues(alpha: 0.45),
              retract: colorScheme.error,
              unretract: colorScheme.tertiary,
              tool: colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Colors {
  const _Colors({
    required this.bed,
    required this.grid,
    required this.extrusion,
    required this.upcoming,
    required this.previous,
    required this.next,
    required this.travel,
    required this.retract,
    required this.unretract,
    required this.tool,
  });

  final Color bed, grid, extrusion, upcoming, previous, next, travel, retract, unretract, tool;
}

class _LayerPainter extends CustomPainter {
  _LayerPainter({
    required this.data,
    required this.minX,
    required this.minY,
    required this.sizeX,
    required this.sizeY,
    required this.showGrid,
    required this.showAxes,
    required this.showNext,
    required this.showPrevious,
    required this.showExtrusion,
    required this.showRetraction,
    required this.showTravel,
    required this.extrusionWidth,
    required this.colors,
  });

  final LayerRenderData data;
  final double minX, minY, sizeX, sizeY;
  final bool showGrid, showAxes, showNext, showPrevious, showExtrusion, showRetraction, showTravel;
  final double extrusionWidth;
  final _Colors colors;

  Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / sizeX;

    // Bed
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(6)),
      Paint()..color = colors.bed,
    );

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    // Printer coordinates: origin bottom-left, y up.
    canvas.translate(0, size.height);
    canvas.scale(scale, -scale);
    canvas.translate(-minX, -minY);

    final px = 1 / scale; // one screen pixel in mm

    if (showGrid) {
      final grid = _stroke(colors.grid.withValues(alpha: 0.5), px);
      final step = sizeX > 400 ? 50.0 : 10.0;
      for (var gx = (minX / step).ceil() * step; gx <= minX + sizeX; gx += step) {
        canvas.drawLine(Offset(gx, minY), Offset(gx, minY + sizeY), grid);
      }
      for (var gy = (minY / step).ceil() * step; gy <= minY + sizeY; gy += step) {
        canvas.drawLine(Offset(minX, gy), Offset(minX + sizeX, gy), grid);
      }
    }

    if (showAxes) {
      final len = min(sizeX, sizeY) * 0.12;
      canvas.drawLine(Offset.zero, Offset(len, 0), _stroke(Colors.red, 2.5 * px));
      canvas.drawLine(Offset.zero, Offset(0, len), _stroke(Colors.green, 2.5 * px));
    }

    final width = max(extrusionWidth, px);

    if (showPrevious && data.previousLayer != null) {
      canvas.drawPath(data.previousLayer!, _stroke(colors.previous, width));
    }

    if (showExtrusion) {
      canvas.drawPath(data.upcomingExtrusions, _stroke(colors.upcoming, width));
      canvas.drawPath(data.extrusions, _stroke(colors.extrusion, width));
    }

    if (showNext && data.nextLayer != null) {
      canvas.drawPath(data.nextLayer!, _stroke(colors.next, width));
    }

    if (showTravel) {
      canvas.drawPath(data.travels, _stroke(colors.travel, max(px, 0.12)));
    }

    if (showRetraction) {
      final r = max(3 * px, extrusionWidth);
      final retract = Paint()..color = colors.retract;
      final unretract = Paint()..color = colors.unretract;
      for (final p in data.retractions) {
        canvas.drawCircle(p, r, retract);
      }
      for (final p in data.unretractions) {
        canvas.drawCircle(p, r * 0.8, unretract);
      }
    }

    final tool = data.toolPosition;
    if (tool != null && data.metaData.currentMove < data.metaData.moveEnd) {
      canvas.drawCircle(tool, 5 * px, Paint()..color = colors.tool);
      canvas.drawCircle(tool, 8 * px, _stroke(colors.tool, 1.5 * px));
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LayerPainter old) =>
      old.data != data ||
      old.showGrid != showGrid ||
      old.showAxes != showAxes ||
      old.showNext != showNext ||
      old.showPrevious != showPrevious ||
      old.showExtrusion != showExtrusion ||
      old.showRetraction != showRetraction ||
      old.showTravel != showTravel ||
      old.extrusionWidth != extrusionWidth ||
      old.sizeX != sizeX ||
      old.sizeY != sizeY ||
      old.colors.extrusion != colors.extrusion;
}
