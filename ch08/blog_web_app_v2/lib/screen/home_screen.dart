import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:webview_flutter/webview_flutter.dart' as mobile_webview;
import 'package:webview_windows/webview_windows.dart';
import 'web_view_widget.dart' if (dart.library.io) 'web_view_stub.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late mobile_webview.WebViewController? mobileWebViewController;
  final webviewController = WebviewController();
  final String blogUrl = 'https://blog.codefactory.ai';
  bool isWindowsWebviewInitialized = false;
  int webReloadKey = 0;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      mobileWebViewController = mobile_webview.WebViewController()
        ..loadRequest(Uri.parse(blogUrl))
        ..setJavaScriptMode(mobile_webview.JavaScriptMode.unrestricted);
    } else if (!kIsWeb && Platform.isWindows) {
      mobileWebViewController = null;
      _initWindowsWebview();
    } else {
      mobileWebViewController = null;
    }
  }

  Future<void> _initWindowsWebview() async {
    try {
      await webviewController.initialize();
      await webviewController.loadUrl(blogUrl);
      setState(() {
        isWindowsWebviewInitialized = true;
      });
    } catch (e) {
      debugPrint('Failed to initialize Windows WebView: $e');
    }
  }

  void _goHome() {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      mobileWebViewController?.loadRequest(Uri.parse(blogUrl));
    } else if (!kIsWeb && Platform.isWindows && isWindowsWebviewInitialized) {
      webviewController.loadUrl(blogUrl);
    } else if (kIsWeb) {
      setState(() {
        webReloadKey++;
      });
    }
  }

  @override
  void dispose() {
    if (!kIsWeb && Platform.isWindows) {
      webviewController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Code Factory'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _goHome,
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return mobile_webview.WebViewWidget(
        controller: mobileWebViewController!,
      );
    }

    if (!kIsWeb && Platform.isWindows) {
      if (!isWindowsWebviewInitialized) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        );
      }
      return Webview(webviewController);
    }

    return WebViewWidget(key: ValueKey(webReloadKey), url: blogUrl);
  }
}
