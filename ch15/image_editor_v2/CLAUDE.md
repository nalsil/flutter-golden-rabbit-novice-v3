# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter image editor app that allows users to:
- Pick images from the gallery
- Add emoticon stickers on top of images
- Transform stickers (move, scale, rotate) using gestures
- Save the edited image to the device gallery

## Essential Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices

# Build for release (Android)
flutter build apk

# Build for release (iOS)
flutter build ios
```

### Testing & Analysis
```bash
# Run tests
flutter test

# Analyze code for issues
flutter analyze
```

## Architecture Overview

### State Management Pattern
The app uses **StatefulWidget** with **setState()** for local state management in `HomeScreen`. Key state:
- `XFile? image`: Currently selected image from gallery
- `Set<StickerModel> stickers`: Collection of stickers placed on the image (Set ensures uniqueness by ID)
- `String? selectedId`: ID of the currently selected sticker for deletion/manipulation
- `GlobalKey imgKey`: Reference to the RepaintBoundary widget for image capture/saving

### Core Component Responsibilities

**HomeScreen** (`lib/screen/home_screen.dart`):
- Main application logic and state management
- Coordinates between image selection, sticker placement, and saving
- Uses `RepaintBoundary` with `GlobalKey` to capture the composite image (base image + stickers) for saving
- Implements `RenderRepaintBoundary.toImage()` to convert the widget tree to image bytes

**EmoticonSticker** (`lib/component/emoticon_sticker.dart`):
- Stateful widget handling individual sticker transformations
- Uses `GestureDetector` with `onScaleUpdate` to handle pinch-to-zoom and drag gestures
- Maintains transformation state: `scale`, `hTransform` (horizontal), `vTransform` (vertical)
- Shows blue border when selected (`isSelected` prop)
- Key insight: `actualScale` preserves scale between gesture sessions

**Footer** (`lib/component/footer.dart`):
- Displays horizontally scrollable emoticon palette (7 emoticons)
- Taps trigger `onEmotionTap` callback with emoticon index (1-7)

**MainAppBar** (`lib/component/main_app_bar.dart`):
- Three action buttons: image picker, delete selected sticker, save image
- All actions delegated to HomeScreen via callbacks

**StickerModel** (`lib/model/sticker_model.dart`):
- Immutable data model with UUID-based identity
- Custom equality/hashCode implementation ensures Set-based sticker management works correctly

### Key Dependencies

- **image_picker (^1.1.2)**: Gallery/camera image selection
- **gal (^2.3.0)**: Save edited images to device gallery (modern replacement for image_gallery_saver)
- **uuid (^4.5.1)**: Generate unique IDs for stickers

### Asset Structure

Images are stored in `asset/img/`:
- `background.jpeg`: Default/placeholder image
- `emoticon_1.png` through `emoticon_7.png`: Sticker emoticons

### Image Capture & Save Flow

1. `RepaintBoundary` wraps the image+stickers Stack with `imgKey`
2. On save, `imgKey.currentContext.findRenderObject()` retrieves the `RenderRepaintBoundary`
3. `boundary.toImage()` converts the render object to `ui.Image`
4. `image.toByteData(format: ui.ImageByteFormat.png)` converts to PNG bytes
5. `Gal.putImageBytes()` writes bytes to device gallery with proper error handling

### Gesture Handling

EmoticonSticker uses `GestureDetector` callbacks:
- `onTap`: Selects the sticker
- `onScaleUpdate`: Handles both pinch-to-zoom and drag simultaneously via `details.scale` and `details.focalPoint`
- `onScaleEnd`: Persists the final scale value to `actualScale` for next gesture session

### Common Patterns

- **Callback pattern**: Child widgets receive VoidCallback functions for user actions
- **Set for uniqueness**: Stickers use Set to prevent duplicates based on ID
- **Transform matrix**: `Matrix4.identity()` with translate/scale for sticker positioning
- **Conditional rendering**: UI elements shown/hidden based on state (`if (image != null)`)
