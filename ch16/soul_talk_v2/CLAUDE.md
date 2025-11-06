# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Soul Talk v2 is a Flutter chat application that integrates with Google's Generative Language API (Gemini). The app features a conversational interface where users can send messages and receive AI-generated responses, with a point system for tracking interactions.

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Run code generation for Isar database models
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Run linter
flutter analyze

# Format code
flutter format .
```

## Architecture

### Core Dependencies
- **Isar**: Local database (NoSQL) for persisting chat messages
- **Google Generative Language API**: Integration with Gemini AI for chat responses
- **GetIt**: Service locator for dependency injection (declared but not yet implemented)
- **Path Provider**: Access to device file system for Isar database

### Project Structure

```
lib/
├── main.dart                   # App entry point
├── screen/
│   └── home_screen.dart        # Main chat interface
├── model/
│   └── MessageModel.dart       # Isar collection model for messages
└── component/
    ├── chat_text_field.dart    # Input field with send button
    ├── message.dart            # Chat bubble UI component
    ├── date_divider.dart       # Date separator in chat
    ├── logo.dart               # App logo header
    └── point_notification.dart # Point display badge
```

### Data Model

**MessageModel** (Isar collection):
- `id`: Auto-increment primary key
- `isMine`: Boolean to distinguish user vs AI messages
- `message`: String content
- `point`: Nullable int for point rewards (only on user messages)
- `date`: DateTime timestamp

The model uses Isar's code generation (`part 'message_model.g.dart'`). Any changes to the model require running build_runner.

### UI Architecture

**HomeScreen** is a stateful widget that:
- Displays a scrollable list of messages with the app logo at the top
- Implements date dividers between messages from different days
- Uses asymmetric padding for user (right-aligned) vs AI (left-aligned) messages
- Has a `handleSendMessage()` method that is currently a stub for future API integration
- Maintains `isRunning` state for loading and `error` state for error handling

**Message Positioning Logic**:
- User messages (`isMine: true`): 64px left padding, 16px right padding
- AI messages (`isMine: false`): 16px left padding, 64px right padding
- Date dividers appear when consecutive messages have different dates

### Code Generation

The project uses build_runner for:
1. **Isar collections**: Generating database schema from `@collection` annotations
2. **JSON serialization**: Configured but currently commented out in MessageModel

After modifying any Isar models, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Assets

Images are located in `asset/img/` directory and must be referenced as:
```dart
'asset/img/filename.png'
```

## Important Notes

### File Naming Convention Issue
The MessageModel file is named `MessageModel.dart` (PascalCase) but the generated part file reference expects `message_model.g.dart` (snake_case). When working with Isar models, ensure the part directive uses snake_case naming convention.

### Sample Data
`home_screen.dart` contains hardcoded sample messages for UI development. The actual AI integration through `handleSendMessage()` is not yet implemented.

### GetIt Service Locator
GetIt is declared in dependencies but not initialized in `main.dart`. Future implementation will likely register:
- Isar database instance
- Google Generative Language API client
- Message repository/service classes

### Korean Language
UI text and sample data are in Korean. Consider this when working with string literals and date formatting.
