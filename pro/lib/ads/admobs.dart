/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 * Ads are disabled in this build: no ad is ever requested or shown.
 */

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'ad_block_unit.dart';

part 'admobs.g.dart';

/// Always resolves to `null` – no ads in this build.
@riverpod
Future<AdWithView?> bannerAd(Ref ref, AdSize size, AdBlockUnit unit) async => null;

/// No consent form needed because nothing is tracked or advertised.
@riverpod
Future<bool> isConsentFormAvailable(Ref ref) async => false;
