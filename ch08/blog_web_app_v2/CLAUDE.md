# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A fully cross-platform Flutter application that displays the Code Factory blog (https://blog.codefactory.ai) using embedded WebView on all platforms. The app demonstrates platform-specific WebView implementations:
- **Mobile (Android/iOS)**: Native WebView via `webview_flutter`
- **Windows**: Edge WebView2 via `webview_windows`
- **Web**: HTML iframe via `HtmlElementView`

This is an educational project demonstrating advanced platform-specific implementations and conditional imports in Flutter.

## Development Commands

### Setup
```bash
flutter pub get
```

### Run Application
```bash
# Run on connected device/emulator
flutter run

# Run on specific platform
flutter run -d windows
flutter run -d chrome
flutter run -d android
flutter run -d ios
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Code Quality
```bash
# Run static analysis
flutter analyze

# Format code
dart format .

# Fix auto-fixable issues
dart fix --apply
```

### Build
```bash
# Build for production (specific platform examples)
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle
flutter build ios              # iOS
flutter build windows          # Windows
flutter build web              # Web
```

## Architecture

### Application Structure

**Entry Point**: `lib/main.dart`
- Initializes Flutter bindings with `WidgetsFlutterBinding.ensureInitialized()`
- Launches app with `MaterialApp` wrapper pointing to `HomeScreen`

**Main Screen**: `lib/screen/home_screen.dart`
- Single-screen application using `StatefulWidget` for platform-specific rendering
- **Platform Detection**: Uses `kIsWeb` and `Platform.isX` to determine runtime platform
- **Platform-Specific Implementations**:
  - **Mobile (Android/iOS)**:
    - WebView implementation using `mobile_webview.WebViewController`
    - Configured with unrestricted JavaScript mode
    - Synchronous initialization in `initState()`
  - **Windows**:
    - WebView2 implementation using `webview_windows.WebviewController`
    - Asynchronous initialization with loading indicator
    - Requires WebView2 Runtime (automatically managed by Flutter)
  - **Web**:
    - HTML iframe via conditional import (`web_view_widget.dart`)
    - Uses `HtmlElementView` with `dart:html` IFrameElement
    - Platform view registry for iframe factory
- Features app bar with home button that reloads WebView based on platform

**Web Platform Widget**: `lib/screen/web_view_widget.dart`
- Web-only widget using conditional imports
- Implements `HtmlElementView` with iframe for embedding web content
- Registers platform view factory with unique viewId
- Companion stub file (`web_view_stub.dart`) for non-web platforms

### Key Dependencies

- **webview_flutter 4.10.0**: Native WebView for Android and iOS platforms
- **webview_windows ^0.4.0**: Edge WebView2 integration for Windows desktop
- **flutter_lints ^5.0.0**: Linting rules following Flutter best practices

### Platform-Specific Behavior

**Mobile Platforms (Android/iOS)**:
- Uses `webview_flutter` package
- `WebViewController` configured with:
  - Target URL: `https://blog.codefactory.ai`
  - JavaScript mode: Unrestricted (`JavaScriptMode.unrestricted`)
  - Home button: Reloads blog URL via `loadRequest()`

**Windows Platform**:
- Uses `webview_windows` package (Edge WebView2)
- `WebviewController` with async initialization:
  - Calls `initialize()` then `loadUrl()`
  - Shows loading spinner during initialization
  - Home button: Reloads blog URL via `loadUrl()`
- **Requirement**: WebView2 Runtime (auto-installed by Flutter build)

**Web Platform**:
- Uses `HtmlElementView` with `dart:html` iframe
- Conditional import pattern:
  - `web_view_widget.dart`: Web implementation
  - `web_view_stub.dart`: Non-web stub
- Platform view factory registers unique iframe instance
- Iframe configured with `border: none` and `100%` width/height
- **Note**: Home button doesn't reload iframe (limitation of HtmlElementView)

### Implementation Patterns

**Conditional Imports**:
```dart
import 'web_view_widget.dart' if (dart.library.io) 'web_view_stub.dart';
```
This pattern allows importing web-specific code only on web platform.

**Platform Detection Hierarchy**:
1. Check `kIsWeb` for web platform
2. Check `Platform.isAndroid` / `Platform.isIOS` for mobile
3. Check `Platform.isWindows` for Windows desktop
4. Each platform uses appropriate WebView implementation

**Asynchronous Initialization (Windows)**:
- `webview_windows` requires async setup
- Use `isWindowsWebviewInitialized` flag
- Show loading indicator until ready
- Proper disposal in `dispose()` method

## Development Notes

### Project Context
This is part of Chapter 8 (`ch08`) in a Flutter learning series (Golden Rabbit Novice v3). The parent directory contains `blog_web_app` (likely v1) and this version (`blog_web_app_v2`).

### SDK Requirements
- Dart SDK: ^3.9.2
- Flutter SDK: (version determined by Dart SDK compatibility)

### Supported Platforms
- ✅ **Android**: Full embedded WebView support via `webview_flutter`
- ✅ **iOS**: Full embedded WebView support via `webview_flutter`
- ✅ **Windows**: Full embedded WebView support via `webview_windows` (Edge WebView2)
- ✅ **Web**: Full embedded iframe support via `HtmlElementView`
- ⚠️ **macOS/Linux**: Not implemented - would require additional platform-specific packages

### Known Limitations

**Web Platform**:
- Home button cannot reload iframe (HtmlElementView limitation)
- Pointer events inside iframe not captured by Flutter (gesture detection limitation)
- Performance impact due to canvas overlay splitting

**Windows Platform**:
- Requires WebView2 Runtime (automatically handled by Flutter)
- First-time NuGet download may take time during build
- Async initialization requires loading state management

**All Platforms**:
- Cross-origin restrictions may apply depending on the loaded URL
- JavaScript execution permissions vary by platform

### Formatting
The project uses `analysis_options.yaml` with `package:flutter_lints/flutter.yaml` for consistent code style enforcement.
