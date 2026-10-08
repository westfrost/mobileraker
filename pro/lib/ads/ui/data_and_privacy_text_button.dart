/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 */

import 'package:flutter/widgets.dart';

/// No ad consent in this build, so nothing to show.
class DataAndPrivacyTextButton extends StatelessWidget {
  const DataAndPrivacyTextButton({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
