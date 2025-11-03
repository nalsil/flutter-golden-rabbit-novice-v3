// ignore_for_file: avoid_web_libraries_in_flutter
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

class WebViewWidget extends StatefulWidget {
  final String url;

  const WebViewWidget({super.key, required this.url});

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  late String viewId;

  @override
  void initState() {
    super.initState();
    viewId = 'webview-${DateTime.now().millisecondsSinceEpoch}';

    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = widget.url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';

        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: viewId);
  }
}
