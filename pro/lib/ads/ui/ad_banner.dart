/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 * Ads are disabled in this build.
 */

import 'package:flutter/widgets.dart';

import '../ad_block_unit.dart';

/// Placeholder kept for API compatibility – renders nothing.
class InlineAdaptiveAdBanner extends StatelessWidget {
  const InlineAdaptiveAdBanner({
    super.key,
    required this.unit,
    this.constraints,
    this.animated = true,
    this.placeholder = false,
  });

  final AdBlockUnit unit;
  final BoxConstraints? constraints;
  final bool animated;
  final bool placeholder;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Placeholder kept for API compatibility – renders nothing.
class AdBanner extends StatelessWidget {
  const AdBanner({super.key, this.constraints});

  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
