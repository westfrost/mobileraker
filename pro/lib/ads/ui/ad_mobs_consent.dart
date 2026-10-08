/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 * No ads -> no ad consent flow.
 */

import 'package:flutter/widgets.dart';

class AdMobsConsent extends StatelessWidget {
  const AdMobsConsent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
