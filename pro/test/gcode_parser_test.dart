import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobileraker_pro/gcode_preview/data/model/gcode_structure.dart';
import 'package:mobileraker_pro/gcode_preview/gcode_layer_renderer.dart';
import 'package:mobileraker_pro/gcode_preview/gcode_parser.dart';

GCodeStructure parse(String gcode) => GCodeParser.parseBytes(Uint8List.fromList(utf8.encode(gcode)));

void main() {
  test('detects layers, extrusions, travels and retractions', () {
    final s = parse('''
; header
G90
M83
G28
G1 Z0.2 F600
G1 X10 Y10 F3000 ; travel
G1 X20 Y10 E1.0
G1 X20 Y20 E1.0
G1 E-0.8
G1 Z0.6 ; z hop
G1 X10 Y20
G1 Z0.4
G1 E0.8
G1 X10 Y10 E1.0
G1 X20 Y10 E1.0
''');
    expect(s.maxLayer, 2);
    expect(s.layers[0].z, closeTo(0.2, 1e-6));
    expect(s.layers[1].z, closeTo(0.4, 1e-6));
    final types = s.types.toList();
    expect(types.where((t) => t == GCodeMoveType.extrude).length, 4);
    expect(types.where((t) => t == GCodeMoveType.retract).length, 1);
    expect(types.where((t) => t == GCodeMoveType.unretract).length, 1);
    // The travel to the start of layer 2 belongs to layer 2
    expect(s.types[s.layers[1].moveStart], isNot(GCodeMoveType.extrude));
    expect(s.maxX, 20);
    expect(s.minY, 10);
  });

  test('absolute extrusion and G92 reset', () {
    final s = parse('''
G90
M82
G92 E0
G1 Z0.3
G1 X5 Y5
G1 X10 Y5 E2
G1 X10 Y10 E4
G92 E0
G1 X5 Y10 E2
''');
    expect(s.types.where((t) => t == GCodeMoveType.extrude).length, 3);
  });

  test('arcs are segmented', () {
    final s = parse('''
G90
M83
G1 Z0.2
G1 X10 Y0
G2 X-10 Y0 I-10 J0 E5
''');
    expect(s.moveCount, greaterThan(5));
    expect(s.xs.last, closeTo(-10, 1e-3));
  });

  test('live render data follows the file position', () {
    const gcode = 'G90\nM83\nG1 Z0.2\nG1 X1 Y1\nG1 X2 Y1 E1\nG1 X3 Y1 E1\nG1 Z0.4\nG1 X3 Y2 E1\n';
    final s = parse(gcode);
    final renderer = GCodeLayerRenderer(s);
    final pos = gcode.indexOf('G1 X3 Y1');
    final live = renderer.createRenderDataForFilePosition(pos);
    expect(live.metaData.layer, 0);
    expect(live.metaData.currentMove, 2);
    final end = renderer.createRenderDataForFilePosition(gcode.length);
    expect(end.metaData.layer, 1);
  });
}
