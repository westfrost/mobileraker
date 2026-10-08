/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:io';

import 'package:common/data/dto/files/gcode_file.dart';
import 'package:common/data/model/file_operation.dart';
import 'package:common/service/moonraker/file_service.dart';
import 'package:common/util/extensions/ref_extension.dart';
import 'package:common/util/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/model/gcode_structure.dart';
import 'gcode_parser.dart';

part 'providers.g.dart';

/// Downloads and parses a gcode file. Progress: 0–0.5 download, 0.5–1 parsing.
@riverpod
class GcodeStructure extends _$GcodeStructure {
  @override
  Future<GCodeStructure> build(String machineUUID, GCodeFile file) async {
    ref.keepAliveFor(const Duration(minutes: 10));

    final fileService = ref.read(fileServiceProvider(machineUUID));
    File? local;
    await for (final op in fileService.downloadFile(filePath: file.absolutPath, expectedFileSize: file.size)) {
      if (!ref.mounted) throw StateError('disposed');
      switch (op) {
        case FileOperationProgress(:final progress):
          state = AsyncLoading(progress: progress * 0.5);
        case FileDownloadComplete(file: final f):
          local = f;
        case FileOperationCanceled():
          throw StateError('Download canceled');
        default:
          break;
      }
    }
    if (local == null) throw StateError('Download of ${file.name} did not complete');

    talker.info('[GCodePreview] Parsing ${file.name} (${file.size} bytes)');
    final sw = Stopwatch()..start();
    var lastReported = 0.0;
    final structure = await GCodeParser.parseFile(
      local.path,
      onProgress: (p) {
        if (!ref.mounted || p - lastReported < 0.02) return;
        lastReported = p;
        state = AsyncLoading(progress: 0.5 + p * 0.5);
      },
    );
    talker.info(
      '[GCodePreview] Parsed ${file.name}: ${structure.moveCount} moves, ${structure.maxLayer} layers in ${sw.elapsedMilliseconds}ms',
    );
    return structure;
  }
}
