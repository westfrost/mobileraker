/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:collection';
import 'dart:ui';

import 'data/model/gcode_structure.dart';

class LayerMetaData {
  const LayerMetaData({
    required this.layer,
    required this.z,
    required this.moveStart,
    required this.moveEnd,
    required this.currentMove,
  });

  /// 0-based layer index.
  final int layer;
  final double z;
  final int moveStart;
  final int moveEnd;

  /// Moves `< currentMove` are done/shown as printed.
  final int currentMove;
}

/// Everything the visualizer needs to draw one layer. Paths are in printer coordinates (mm).
class LayerRenderData {
  const LayerRenderData({
    required this.metaData,
    required this.extrusions,
    required this.upcomingExtrusions,
    required this.travels,
    required this.retractions,
    required this.unretractions,
    this.previousLayer,
    this.nextLayer,
    this.toolPosition,
  });

  final LayerMetaData metaData;
  final Path extrusions;
  final Path upcomingExtrusions;
  final Path travels;
  final List<Offset> retractions;
  final List<Offset> unretractions;
  final Path? previousLayer;
  final Path? nextLayer;
  final Offset? toolPosition;
}

/// Creates [LayerRenderData] for a [GCodeStructure]. Caches full-layer paths.
class GCodeLayerRenderer {
  GCodeLayerRenderer(this.structure);

  final GCodeStructure structure;

  final LinkedHashMap<int, Path> _layerCache = LinkedHashMap();

  Path _fullLayerExtrusions(int layerIndex) {
    final cached = _layerCache.remove(layerIndex);
    if (cached != null) {
      _layerCache[layerIndex] = cached;
      return cached;
    }
    final layer = structure.layers[layerIndex];
    final path = _extrusionPath(layer.moveStart, layer.moveEnd);
    _layerCache[layerIndex] = path;
    if (_layerCache.length > 12) _layerCache.remove(_layerCache.keys.first);
    return path;
  }

  Path _extrusionPath(int from, int to) {
    final s = structure;
    final path = Path();
    var penDown = false;
    for (var i = from; i < to; i++) {
      if (s.types[i] != GCodeMoveType.extrude) {
        penDown = false;
        continue;
      }
      if (!penDown) {
        path.moveTo(s.fromX(i), s.fromY(i));
        penDown = true;
      }
      path.lineTo(s.xs[i], s.ys[i]);
    }
    return path;
  }

  LayerRenderData _build(int layerIndex, int currentMove) {
    final s = structure;
    if (s.layers.isEmpty) {
      return LayerRenderData(
        metaData: const LayerMetaData(layer: 0, z: 0, moveStart: 0, moveEnd: 0, currentMove: 0),
        extrusions: Path(),
        upcomingExtrusions: Path(),
        travels: Path(),
        retractions: const [],
        unretractions: const [],
      );
    }
    final idx = layerIndex.clamp(0, s.layers.length - 1);
    final layer = s.layers[idx];
    final current = currentMove.clamp(layer.moveStart, layer.moveEnd);

    final travels = Path();
    final retractions = <Offset>[];
    final unretractions = <Offset>[];
    for (var i = layer.moveStart; i < current; i++) {
      switch (s.types[i]) {
        case GCodeMoveType.travel:
          travels
            ..moveTo(s.fromX(i), s.fromY(i))
            ..lineTo(s.xs[i], s.ys[i]);
        case GCodeMoveType.retract:
          retractions.add(Offset(s.xs[i], s.ys[i]));
        case GCodeMoveType.unretract:
          unretractions.add(Offset(s.xs[i], s.ys[i]));
      }
    }

    final done = current >= layer.moveEnd;
    return LayerRenderData(
      metaData: LayerMetaData(
        layer: idx,
        z: layer.z,
        moveStart: layer.moveStart,
        moveEnd: layer.moveEnd,
        currentMove: current,
      ),
      extrusions: done ? _fullLayerExtrusions(idx) : _extrusionPath(layer.moveStart, current),
      upcomingExtrusions: done ? Path() : _extrusionPath(current, layer.moveEnd),
      travels: travels,
      retractions: retractions,
      unretractions: unretractions,
      previousLayer: idx > 0 ? _fullLayerExtrusions(idx - 1) : null,
      nextLayer: idx + 1 < s.layers.length ? _fullLayerExtrusions(idx + 1) : null,
      toolPosition: current > 0 ? Offset(s.xs[current - 1], s.ys[current - 1]) : null,
    );
  }

  /// Layer [layerIndex], optionally only up to (excluding) move [stopAtMove].
  LayerRenderData createRenderDataForLayer({required int layerIndex, int? stopAtMove}) {
    final layers = structure.layers;
    final end = layers.isEmpty ? 0 : layers[layerIndex.clamp(0, layers.length - 1)].moveEnd;
    return _build(layerIndex, stopAtMove ?? end);
  }

  /// Live view: the layer currently being printed at gcode byte [filePosition].
  LayerRenderData createRenderDataForFilePosition(int filePosition) {
    final done = structure.movesBeforeFilePosition(filePosition);
    final layer = structure.layerOfMove(done > 0 ? done - 1 : 0);
    return _build(layer, done);
  }
}
