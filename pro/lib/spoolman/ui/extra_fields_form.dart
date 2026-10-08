/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dto/spoolman_entity_type_enum.dart';
import '../dto/spoolman_extra_field.dart';
import '../service/spoolman_service.dart';

const _kExtraPrefix = 'spoolman_extra::';

extension SpoolmanExtraFieldsFormData on Map<String, dynamic> {
  /// Collects the values of all [ExtraFieldsFormSection] fields as Spoolman expects them
  /// (key -> JSON encoded value). Empty fields are left out.
  Map<String, String> extractExtraFields() {
    return {
      for (final MapEntry(:key, :value) in entries)
        if (key.startsWith(_kExtraPrefix) && value is String) key.substring(_kExtraPrefix.length): value,
    };
  }
}

/// Renders form fields for the Spoolman extra fields of [type]. Must be placed inside a FormBuilder.
class ExtraFieldsFormSection extends ConsumerWidget {
  const ExtraFieldsFormSection({
    super.key,
    required this.machineUUID,
    required this.type,
    this.extraValues,
    this.header,
  });

  final String machineUUID;
  final SpoolmanEntityType type;
  final Map<String, String>? extraValues;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fields = ref.watch(spoolmanExtraFieldsProvider(machineUUID, type)).value ?? const [];
    if (fields.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ?header,
        for (final field in fields) _ExtraField(field: field, raw: extraValues?[field.key] ?? field.defaultValue),
      ],
    );
  }
}

class _ExtraField extends StatelessWidget {
  const _ExtraField({required this.field, required this.raw});

  final SpoolmanExtraField field;
  final String? raw;

  String get _name => '$_kExtraPrefix${field.key}';

  InputDecoration get _decoration => InputDecoration(
        labelText: field.name,
        suffixText: field.unit?.isNotEmpty == true ? field.unit : null,
      );

  @override
  Widget build(BuildContext context) {
    final value = SpoolmanExtraField.decode(raw);

    final Widget child = switch (field.type) {
      SpoolmanExtraFieldType.boolean => FormBuilderSwitch(
          name: _name,
          title: Text(field.name),
          initialValue: value == true,
          // Only send `false` if the value existed before, so untouched fields don't count as changes.
          valueTransformer: (v) => (v == true || raw != null) ? jsonEncode(v == true) : null,
        ),
      SpoolmanExtraFieldType.choice when field.multiChoice => FormBuilderFilterChips<String>(
          name: _name,
          decoration: _decoration,
          initialValue: value is List ? [for (final v in value) '$v'] : const [],
          options: [for (final c in field.choices) FormBuilderChipOption(value: c)],
          valueTransformer: (v) => v == null || v.isEmpty ? null : jsonEncode(v),
        ),
      SpoolmanExtraFieldType.choice => FormBuilderDropdown<String>(
          name: _name,
          decoration: _decoration,
          initialValue: value is String && field.choices.contains(value) ? value : null,
          items: [for (final c in field.choices) DropdownMenuItem(value: c, child: Text(c))],
          valueTransformer: (v) => v == null ? null : jsonEncode(v),
        ),
      SpoolmanExtraFieldType.datetime => FormBuilderDateTimePicker(
          name: _name,
          decoration: _decoration,
          initialValue: value is String ? DateTime.tryParse(value)?.toLocal() : null,
          valueTransformer: (v) => v == null ? null : jsonEncode(v.toUtc().toIso8601String()),
        ),
      SpoolmanExtraFieldType.integer || SpoolmanExtraFieldType.float => FormBuilderTextField(
          name: _name,
          decoration: _decoration,
          initialValue: value is num ? '$value' : null,
          keyboardType: TextInputType.numberWithOptions(
            decimal: field.type == SpoolmanExtraFieldType.float,
            signed: true,
          ),
          valueTransformer: (v) {
            final text = v?.trim().replaceAll(',', '.');
            if (text == null || text.isEmpty) return null;
            final num? parsed =
                field.type == SpoolmanExtraFieldType.integer ? int.tryParse(text) : double.tryParse(text);
            return parsed == null ? null : jsonEncode(parsed);
          },
        ),
      SpoolmanExtraFieldType.integerRange || SpoolmanExtraFieldType.floatRange => FormBuilderTextField(
          name: _name,
          decoration: _decoration.copyWith(hintText: 'min ; max'),
          initialValue: value is List ? value.join(' ; ') : null,
          valueTransformer: (v) {
            final parts = (v ?? '').split(';').map((e) => e.trim().replaceAll(',', '.')).toList();
            if (parts.every((e) => e.isEmpty)) return null;
            num? parse(String s) =>
                field.type == SpoolmanExtraFieldType.integerRange ? int.tryParse(s) : double.tryParse(s);
            return jsonEncode([parse(parts.elementAtOrNull(0) ?? ''), parse(parts.elementAtOrNull(1) ?? '')]);
          },
        ),
      _ => FormBuilderTextField(
          name: _name,
          decoration: _decoration,
          initialValue: value?.toString(),
          valueTransformer: (v) => v == null || v.isEmpty ? null : jsonEncode(v),
        ),
    };

    return Padding(padding: const EdgeInsets.only(bottom: 8), child: child);
  }
}
