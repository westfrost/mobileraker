/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:flutter/material.dart';

import '../../data/model/custom_theme_config.dart';
import '../../data/model/custom_theme_pack.dart';

/// Card tile for a custom theme with a small color preview of the light/dark variants.
class CustomThemeListTile extends StatelessWidget {
  const CustomThemeListTile({super.key, required this.pack, this.onEdit, this.onMore});

  final CustomThemePack pack;
  final VoidCallback? onEdit;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onEdit,
        onLongPress: onMore,
        leading: _Swatches(light: pack.lightConfig, dark: pack.darkConfig),
        title: Text(pack.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          [
            pack.darkConfig != null ? 'Light + Dark' : 'Light',
            if (pack.lightConfig.fontFamily != null) pack.lightConfig.fontFamily!,
          ].join(' · '),
          style: themeData.textTheme.bodySmall,
        ),
        trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: onMore),
      ),
    );
  }
}

class _Swatches extends StatelessWidget {
  const _Swatches({required this.light, this.dark});

  final CustomThemeConfig light;
  final CustomThemeConfig? dark;

  @override
  Widget build(BuildContext context) {
    Widget dot(int? color) => Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: color == null ? Colors.transparent : Color(color),
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
          ),
        );

    return SizedBox(
      width: 48,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          dot(light.primaryColor),
          dot(light.secondaryColor ?? light.primaryColor),
          dot(dark?.primaryColor ?? light.tertiaryColor),
          dot(dark?.secondaryColor ?? light.surfaceColor),
        ],
      ),
    );
  }
}
