/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 *
 * Byte level gcode parser. Runs in a background isolate and reports progress.
 * Supports G0/G1, G2/G3 arcs, G10/G11 firmware retraction, G90/G91, M82/M83, G92.
 */

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'data/model/gcode_structure.dart';

class GCodeParser {
  /// Parses [path] in a background isolate. [onProgress] receives values from 0 to 1.
  static Future<GCodeStructure> parseFile(String path, {void Function(double progress)? onProgress}) async {
    final port = ReceivePort();
    final sendPort = port.sendPort;
    final sub = port.listen((message) {
      if (message is double) onProgress?.call(message);
    });
    try {
      return await _runInIsolate(path, sendPort);
    } finally {
      await sub.cancel();
      port.close();
    }
  }

  /// Synchronous entry point (also used by tests).
  static GCodeStructure parseBytes(Uint8List bytes) => _parse(bytes, null);
}

// Separate function so the isolate closure only captures sendable values.
Future<GCodeStructure> _runInIsolate(String path, SendPort sendPort) =>
    Isolate.run(() => _parse(File(path).readAsBytesSync(), sendPort));

class _Builder {
  Float32List xs = Float32List(4096);
  Float32List ys = Float32List(4096);
  Uint8List types = Uint8List(4096);
  Int32List pos = Int32List(4096);
  int length = 0;

  void add(double x, double y, int type, int filePos) {
    if (length == types.length) _grow();
    xs[length] = x;
    ys[length] = y;
    types[length] = type;
    pos[length] = filePos;
    length++;
  }

  void _grow() {
    final n = types.length * 2;
    xs = Float32List(n)..setRange(0, length, xs);
    ys = Float32List(n)..setRange(0, length, ys);
    types = Uint8List(n)..setRange(0, length, types);
    pos = Int32List(n)..setRange(0, length, pos);
  }
}

const _cSemicolon = 59; // ;
const _cNewline = 10;
const _cSpace = 32;
const _cTab = 9;
const _cCr = 13;
const _cMinus = 45;
const _cPlus = 43;
const _cDot = 46;
const _c0 = 48;
const _c9 = 57;

GCodeStructure _parse(Uint8List b, SendPort? progress) {
  final out = _Builder();
  final layers = <GCodeLayer>[];

  // Machine state
  double x = 0, y = 0, z = 0, e = 0;
  var absXYZ = true;
  var absE = true;

  // Layer detection
  double? layerZ;
  var layerStart = 0;
  var lastExtrusionMove = -1;

  double minX = double.infinity, maxX = double.negativeInfinity;
  double minY = double.infinity, maxY = double.negativeInfinity;

  // Parameters of the current line (NaN = not present)
  final params = Float64List(26);

  final total = b.length;
  var nextProgress = total ~/ 50;
  var i = 0;

  void startLayerIfNeeded(double atZ) {
    if (layerZ == null) {
      layerZ = atZ;
      return;
    }
    if ((atZ - layerZ!).abs() < 0.03) return;
    final newStart = lastExtrusionMove + 1;
    if (newStart > layerStart) {
      layers.add(GCodeLayer(z: layerZ!, moveStart: layerStart, moveEnd: newStart));
      layerStart = newStart;
    }
    layerZ = atZ;
  }

  void addMove(double nx, double ny, double dE, int lineStart) {
    final dx = nx - x, dy = ny - y;
    final xyMoved = dx * dx + dy * dy > 1e-10;
    int type;
    if (dE > 1e-6 && xyMoved) {
      type = GCodeMoveType.extrude;
    } else if (dE < -1e-6) {
      type = GCodeMoveType.retract;
    } else if (dE > 1e-6) {
      type = GCodeMoveType.unretract;
    } else if (xyMoved) {
      type = GCodeMoveType.travel;
    } else {
      return; // pure Z move or no-op
    }
    if (type == GCodeMoveType.extrude) {
      startLayerIfNeeded(z);
      lastExtrusionMove = out.length;
      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
      if (nx < minX) minX = nx;
      if (nx > maxX) maxX = nx;
      if (ny < minY) minY = ny;
      if (ny > maxY) maxY = ny;
    }
    out.add(nx, ny, type, lineStart);
  }

  while (i < total) {
    final lineStart = i;
    var lineEnd = i;
    while (lineEnd < total && b[lineEnd] != _cNewline) {
      lineEnd++;
    }
    i = lineEnd + 1;

    if (progress != null && lineStart >= nextProgress) {
      progress.send(lineStart / total);
      nextProgress += total ~/ 50;
    }

    // Skip leading whitespace
    var p = lineStart;
    while (p < lineEnd && (b[p] == _cSpace || b[p] == _cTab)) {
      p++;
    }
    if (p >= lineEnd) continue;
    // Optional line number N123
    if ((b[p] | 0x20) == 0x6e) {
      while (p < lineEnd && b[p] != _cSpace) {
        p++;
      }
      while (p < lineEnd && b[p] == _cSpace) {
        p++;
      }
      if (p >= lineEnd) continue;
    }

    final letter = b[p] & ~0x20; // upper case
    if (letter != 0x47 /*G*/ && letter != 0x4d /*M*/) continue;
    p++;
    var code = 0;
    var hasCode = false;
    while (p < lineEnd && b[p] >= _c0 && b[p] <= _c9) {
      code = code * 10 + (b[p] - _c0);
      p++;
      hasCode = true;
    }
    if (!hasCode) continue;
    // Sub codes like G29.1 are ignored
    if (p < lineEnd && b[p] == _cDot) continue;

    if (letter == 0x4d) {
      if (code == 82) absE = true;
      if (code == 83) absE = false;
      continue;
    }

    // G code
    switch (code) {
      case 0 || 1 || 2 || 3 || 92:
        break;
      case 90:
        absXYZ = true;
        absE = true;
        continue;
      case 91:
        absXYZ = false;
        absE = false;
        continue;
      case 10:
        out.add(x, y, GCodeMoveType.retract, lineStart);
        continue;
      case 11:
        out.add(x, y, GCodeMoveType.unretract, lineStart);
        continue;
      default:
        continue;
    }

    // Parse parameters
    params.fillRange(0, 26, double.nan);
    while (p < lineEnd) {
      final c = b[p];
      if (c == _cSemicolon || c == _cCr) break;
      final up = c & ~0x20;
      if (up < 0x41 || up > 0x5a) {
        p++;
        continue;
      }
      p++;
      // number
      var neg = false;
      if (p < lineEnd && (b[p] == _cMinus || b[p] == _cPlus)) {
        neg = b[p] == _cMinus;
        p++;
      }
      var intPart = 0.0;
      var any = false;
      while (p < lineEnd && b[p] >= _c0 && b[p] <= _c9) {
        intPart = intPart * 10 + (b[p] - _c0);
        p++;
        any = true;
      }
      if (p < lineEnd && b[p] == _cDot) {
        p++;
        var scale = 0.1;
        while (p < lineEnd && b[p] >= _c0 && b[p] <= _c9) {
          intPart += (b[p] - _c0) * scale;
          scale *= 0.1;
          p++;
          any = true;
        }
      }
      if (any) params[up - 0x41] = neg ? -intPart : intPart;
    }

    final px = params[23], py = params[24], pz = params[25], pe = params[4];

    if (code == 92) {
      if (!px.isNaN) x = px;
      if (!py.isNaN) y = py;
      if (!pz.isNaN) z = pz;
      if (!pe.isNaN) e = pe;
      continue;
    }

    final nx = px.isNaN ? x : (absXYZ ? px : x + px);
    final ny = py.isNaN ? y : (absXYZ ? py : y + py);
    final nz = pz.isNaN ? z : (absXYZ ? pz : z + pz);
    double dE = 0;
    if (!pe.isNaN) {
      dE = absE ? pe - e : pe;
      e = absE ? pe : e + pe;
    }
    z = nz;

    if (code == 2 || code == 3) {
      final ci = params[8], cj = params[9];
      final cr = params[17];
      double cx, cy;
      if (!ci.isNaN || !cj.isNaN) {
        cx = x + (ci.isNaN ? 0 : ci);
        cy = y + (cj.isNaN ? 0 : cj);
      } else if (!cr.isNaN) {
        // radius form: pick the center on the correct side
        final dx = nx - x, dy = ny - y;
        final d = sqrt(dx * dx + dy * dy);
        if (d < 1e-9) {
          addMove(nx, ny, dE, lineStart);
          x = nx;
          y = ny;
          continue;
        }
        final h = sqrt(max(0, cr * cr - d * d / 4));
        final mx = (x + nx) / 2, my = (y + ny) / 2;
        final sign = ((code == 2) ^ (cr < 0)) ? -1.0 : 1.0;
        cx = mx - sign * h * dy / d;
        cy = my + sign * h * dx / d;
      } else {
        addMove(nx, ny, dE, lineStart);
        x = nx;
        y = ny;
        continue;
      }
      final r = sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));
      var a0 = atan2(y - cy, x - cx);
      var a1 = atan2(ny - cy, nx - cx);
      if (code == 2) {
        // clockwise
        if (a1 >= a0) a1 -= 2 * pi;
      } else {
        if (a1 <= a0) a1 += 2 * pi;
      }
      final sweep = (a1 - a0).abs();
      final segments = max(2, min(64, (sweep * r / 0.8).ceil()));
      final dEseg = dE / segments;
      for (var s = 1; s <= segments; s++) {
        final a = a0 + (a1 - a0) * s / segments;
        final sx = s == segments ? nx : cx + r * cos(a);
        final sy = s == segments ? ny : cy + r * sin(a);
        addMove(sx, sy, dEseg, lineStart);
        x = sx;
        y = sy;
      }
      continue;
    }

    addMove(nx, ny, dE, lineStart);
    x = nx;
    y = ny;
  }

  final end = out.length;
  if (end > layerStart || layers.isEmpty) {
    layers.add(GCodeLayer(z: layerZ ?? 0, moveStart: layerStart, moveEnd: end));
  }
  progress?.send(1.0);

  if (minX == double.infinity) {
    minX = 0;
    maxX = 0;
    minY = 0;
    maxY = 0;
  }

  return GCodeStructure(
    xs: Float32List.sublistView(out.xs, 0, end),
    ys: Float32List.sublistView(out.ys, 0, end),
    types: Uint8List.sublistView(out.types, 0, end),
    filePositions: Int32List.sublistView(out.pos, 0, end),
    layers: layers,
    startX: 0,
    startY: 0,
    minX: minX,
    maxX: maxX,
    minY: minY,
    maxY: maxY,
  );
}
