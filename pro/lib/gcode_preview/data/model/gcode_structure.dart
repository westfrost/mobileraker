/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:typed_data';

/// Kinds of moves stored in [GCodeStructure.types].
abstract final class GCodeMoveType {
  static const int travel = 0;
  static const int extrude = 1;
  static const int retract = 2;
  static const int unretract = 3;
}

class GCodeLayer {
  const GCodeLayer({required this.z, required this.moveStart, required this.moveEnd});

  final double z;

  /// First move of the layer (inclusive).
  final int moveStart;

  /// End of the layer (exclusive).
  final int moveEnd;

  int get moveCount => moveEnd - moveStart;

  @override
  String toString() => 'GCodeLayer(z: $z, $moveStart..$moveEnd)';
}

/// Parsed, render ready representation of a gcode file.
///
/// Move `i` goes from the end point of move `i-1` (or [startX]/[startY]) to `(xs[i], ys[i])`.
class GCodeStructure {
  GCodeStructure({
    required this.xs,
    required this.ys,
    required this.types,
    required this.filePositions,
    required this.layers,
    required this.startX,
    required this.startY,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  final Float32List xs;
  final Float32List ys;
  final Uint8List types;

  /// Byte offset of the gcode line that produced the move (monotonic).
  final Int32List filePositions;
  final List<GCodeLayer> layers;

  final double startX;
  final double startY;

  /// Bounds of all extrusion moves.
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  int get moveCount => types.length;

  int get maxLayer => layers.length;

  double fromX(int move) => move <= 0 ? startX : xs[move - 1];

  double fromY(int move) => move <= 0 ? startY : ys[move - 1];

  /// Index of the layer that contains [move].
  int layerOfMove(int move) {
    var lo = 0;
    var hi = layers.length - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) >> 1;
      if (layers[mid].moveStart <= move) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return lo;
  }

  /// Number of moves whose gcode line starts before [position].
  int movesBeforeFilePosition(int position) {
    var lo = 0;
    var hi = filePositions.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (filePositions[mid] < position) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }
}
