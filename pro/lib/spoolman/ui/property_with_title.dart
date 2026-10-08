/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:flutter/material.dart';

/// Small label + value block used in the Spoolman detail cards.
class PropertyWithTitle extends StatelessWidget {
  const PropertyWithTitle({super.key, required this.title, required this.property});

  PropertyWithTitle.text({super.key, required this.title, required String property})
      : property = Text(property, maxLines: 3, overflow: TextOverflow.ellipsis);

  final String title;
  final Widget property;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: themeData.textTheme.labelMedium?.copyWith(color: themeData.colorScheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          DefaultTextStyle.merge(style: themeData.textTheme.bodyMedium, child: property),
        ],
      ),
    );
  }
}
