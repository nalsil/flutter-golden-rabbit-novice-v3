# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter image carousel application (image_carousel_v2) that displays a PageView with 5 images that auto-advance every 3 seconds. The app is part of Chapter 9 (ch09) of the "Golden Rabbit Novice" Flutter learning series.

## Development Commands

### Setup and Dependencies
```bash
flutter pub get                    # Install dependencies
```

### Running the Application
```bash
flutter run                        # Run on connected device/emulator
flutter run -d chrome              # Run on Chrome (web)
flutter run -d windows             # Run on Windows desktop
```

### Code Quality
```bash
flutter analyze                    # Run static analysis
flutter test                       # Run all tests
```

### Building
```bash
flutter build apk                  # Build Android APK
flutter build appbundle            # Build Android App Bundle
flutter build ios                  # Build iOS (macOS only)
flutter build web                  # Build web application
flutter build windows              # Build Windows desktop app
```

## Architecture

### Application Structure
- **Entry Point**: `lib/main.dart` - Minimal setup with MaterialApp wrapping HomeScreen
- **Single Screen**: `lib/screen/home_screen.dart` - StatefulWidget containing all carousel logic

### Key Implementation Details

**HomeScreen (_HomeScreenState)**:
- Uses `PageController` to manage PageView navigation
- Implements auto-advance timer in `initState()` using `Timer.periodic`
- Timer runs every 3 seconds, cycling through pages 0-4 with animated transitions
- **Critical Timer Behavior**: Timer is NOT disposed in the current implementation, which could cause memory leaks if the widget is disposed
- Uses `SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)` for status bar styling

**PageView Configuration**:
- Displays 5 images from `asset/img/` directory (image_1.jpeg through image_5.jpeg)
- Images use `BoxFit.cover` for full-screen display
- Controlled navigation via PageController (not user-swipeable by default, but can be changed)

### Asset Management
Images are located in `asset/img/` and must be registered in `pubspec.yaml` under:
```yaml
flutter:
  assets:
    - asset/img/
```

## Technical Constraints

- **Dart SDK**: ^3.9.2 (Flutter 3.x compatible)
- **Dependencies**: Minimal - only uses `cupertino_icons` beyond Flutter SDK
- **Linting**: Uses `flutter_lints: ^5.0.0` with default configuration

## Known Issues & Considerations

1. **Timer Disposal**: The `Timer.periodic` in HomeScreen is never cancelled or disposed, which will cause the timer to continue running even if the widget is removed from the tree. Consider storing the timer reference and calling `timer.cancel()` in `dispose()`.

2. **Null Safety**: The code uses null-safety features (`int?`, null-aware operators) appropriate for Dart 3.x.

3. **Page Index Magic Number**: The hardcoded value `4` for max page index could be derived from the list length for maintainability.

4. **Debug Print**: Contains `print('실행!')` statement in production code (Korean text meaning "Execute!").
