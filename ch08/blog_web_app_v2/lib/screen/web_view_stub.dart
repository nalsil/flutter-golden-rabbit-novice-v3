import 'package:flutter/material.dart';

class WebViewWidget extends StatefulWidget {
  final String url;

  const WebViewWidget({super.key, required this.url});

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('WebView not supported on this platform'),
    );
  }
}
