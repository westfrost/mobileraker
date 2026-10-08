/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dto/spoolman_entity_type_enum.dart';
import '../service/spoolman_service.dart';
import 'property_with_title.dart';

/// Shows the user defined Spoolman extra fields of an entity. Renders nothing if there are none.
class ExtraFieldsView extends ConsumerWidget {
  const ExtraFieldsView({super.key, required this.machineUUID, required this.type, required this.extra});

  final String machineUUID;
  final SpoolmanEntityType type;
  final Map<String, String>? extra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fields = ref.watch(spoolmanExtraFieldsProvider(machineUUID, type)).value ?? const [];
    if (fields.isEmpty) return const SizedBox.shrink();

    final values = extra ?? const {};
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        children: [
          for (final field in fields)
            FractionallySizedBox(
              widthFactor: 0.5,
              child: PropertyWithTitle.text(title: field.name, property: field.format(values[field.key])),
            ),
        ],
      ),
    );
  }
}
