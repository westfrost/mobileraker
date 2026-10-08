/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 *
 * WebRTC webcams are shown through the streaming server's own browser player
 * (camera-streamer, go2rtc, MediaMTX) inside a WebView. This avoids a native
 * WebRTC stack while supporting all common Klipper camera servers.
 */

import 'package:common/data/enums/webcam_service_type.dart';
import 'package:common/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebRtc extends HookWidget {
  const WebRtc({
    super.key,
    required this.camUri,
    this.dio,
    required this.service,
    this.stackContent = const [],
    this.rotation = 0,
    this.transform,
    this.imageBuilder,
    this.onHidePressed,
  });

  final Uri camUri;
  final Dio? dio;
  final WebcamServiceType service;
  final List<Widget> stackContent;
  final int rotation;
  final Matrix4? transform;
  final Widget Function(BuildContext context, Widget image)? imageBuilder;
  final VoidCallback? onHidePressed;

  /// Maps the configured stream/signaling URL to the HTML player page of the server.
  static Uri playerUri(Uri uri, WebcamServiceType service) {
    final path = uri.path;
    switch (service) {
      case WebcamServiceType.webRtcGo2Rtc:
        // Mainsail/Fluidd store the signaling endpoint (`/api/webrtc?src=cam`), go2rtc ships `stream.html`.
        if (path.endsWith('/api/webrtc') || path.endsWith('/api/ws')) {
          final base = path.substring(0, path.lastIndexOf('/api/'));
          return uri.replace(path: '$base/stream.html', queryParameters: {...uri.queryParameters, 'mode': 'webrtc'});
        }
        return uri;
      case WebcamServiceType.webRtcMediaMtx:
        // WHEP endpoint `/<cam>/whep` -> player page `/<cam>/`
        if (path.endsWith('/whep')) return uri.replace(path: path.substring(0, path.length - 4));
        return uri;
      default:
        return uri;
    }
  }

  static const _fitVideoJs = '''
    (function() {
      try {
        document.documentElement.style.background = 'black';
        document.body.style.margin = '0';
        document.body.style.background = 'black';
        document.body.style.overflow = 'hidden';
        var vids = document.querySelectorAll('video');
        vids.forEach(function(v) {
          v.style.position = 'fixed'; v.style.inset = '0';
          v.style.width = '100vw'; v.style.height = '100vh';
          v.style.objectFit = 'contain'; v.style.background = 'black';
          v.controls = false; v.muted = true; v.playsInline = true;
          var p = v.play(); if (p && p.catch) p.catch(function(){});
        });
        Array.from(document.body.children).forEach(function(c) {
          if (c.tagName !== 'VIDEO' && !c.querySelector('video')) c.style.display = 'none';
        });
      } catch (e) {}
    })();
  ''';

  @override
  Widget build(BuildContext context) {
    final error = useState<String?>(null);
    final loading = useState(true);
    final uri = playerUri(camUri, service);

    final controller = useMemoized(() {
      final c = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (_) async {
            loading.value = false;
            // Players attach the <video> asynchronously; apply styling a few times.
            for (final delay in const [0, 500, 1500, 3000]) {
              await Future.delayed(Duration(milliseconds: delay));
              try {
                await c.runJavaScript(_fitVideoJs);
              } catch (_) {}
            }
          },
          onWebResourceError: (e) {
            if (e.isForMainFrame == false) return;
            talker.warning('[WebRtc] Error loading $uri: ${e.description}');
            error.value = e.description;
          },
        ));
      final platform = c.platform;
      if (platform is AndroidWebViewController) {
        platform.setMediaPlaybackRequiresUserGesture(false);
      }
      talker.info('[WebRtc] Loading player $uri (service: ${service.name})');
      c.loadRequest(uri);
      return c;
    }, [uri.toString()]);

    Widget view = WebViewWidget(controller: controller);
    if (transform != null) view = Transform(alignment: Alignment.center, transform: transform!, child: view);
    if (rotation % 360 != 0) view = RotatedBox(quarterTurns: (rotation ~/ 90) % 4, child: view);

    Widget image = AspectRatio(
      aspectRatio: rotation % 180 == 0 ? 16 / 9 : 9 / 16,
      child: ColoredBox(color: Colors.black, child: view),
    );
    if (imageBuilder != null) image = imageBuilder!(context, image);

    return Stack(
      alignment: Alignment.center,
      children: [
        image,
        if (loading.value && error.value == null) const CircularProgressIndicator.adaptive(),
        if (error.value != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.videocam_off_outlined, color: Colors.white70),
                const SizedBox(height: 6),
                Text(error.value!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                TextButton(
                  onPressed: () {
                    error.value = null;
                    loading.value = true;
                    controller.loadRequest(uri);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ...stackContent,
      ],
    );
  }
}
