# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Calendar Scheduler V2 - A Flutter calendar application for managing daily schedules. This is a learning project (Chapter 17) focused on calendar UI and schedule management.

## Development Commands

### Setup
```bash
flutter pub get                    # Install dependencies
flutter pub run build_runner build # Generate Drift database files (when needed)
```

### Running
```bash
flutter run                        # Run on connected device/emulator
flutter run -d chrome              # Run on Chrome
flutter run -d windows             # Run on Windows
```

### Testing & Quality
```bash
flutter test                       # Run all tests
flutter analyze                    # Run static analysis
```

### Code Generation
The project uses Drift for database management. When modifying database schemas or DAOs:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture

### Application Structure
- **Entry Point**: `lib/main.dart` - Initializes date localization (Korean) and launches app
- **Main Screen**: `lib/screen/home_screen.dart` - StatefulWidget managing calendar state and selected date
- **Components**: Reusable UI widgets in `lib/component/`
- **Constants**: App-wide constants in `lib/const/`

### Key Dependencies
- **table_calendar** (3.1.2): Calendar UI with Korean localization
- **drift** (2.21.0) + **drift_flutter** (0.1.0): Type-safe SQLite database ORM
- **provider** (6.1.2): State management
- **get_it** (8.0.2): Dependency injection
- **dio** (5.7.0): HTTP client
- **uuid** (4.5.1): Unique identifier generation

### Component Architecture

**MainCalendar** (`lib/component/main_calendar.dart`):
- Uses table_calendar package with Korean locale ('ko_kr')
- Receives `selectedDate` and `onDaySelected` callback from parent
- Custom styling defined with PRIMARY_COLOR and GREY colors

**ScheduleBottomSheet** (`lib/component/schedule_bottom_sheet.dart`):
- Modal bottom sheet for adding/editing schedules
- Contains two time input fields (start/end) and one content field
- Handles keyboard insets dynamically with `MediaQuery.viewInsets.bottom`
- Currently has empty `onSavePressed()` - needs database integration

**HomeScreen State Management**:
- Stores `selectedDate` as UTC DateTime
- Updates selected date through `onDaySelected` callback
- Static schedule card currently hardcoded - needs dynamic data binding

### Database Layer (Drift)
Project includes Drift dependencies but generated files (*.g.dart) are not yet present. When implementing database:
- Define tables in a `*_database.dart` file
- Run build_runner to generate DAO and query code
- Integrate with get_it for dependency injection
- Connect to Provider for state management

### Color Scheme
All app colors defined in `lib/const/colors.dart`:
- PRIMARY_COLOR: #0DB2B2 (teal/cyan)
- LIGHT_GREY_COLOR: grey[200]
- DARK_GREY_COLOR: grey[600]
- TEXT_FIELD_FILL_COLOR: grey[300]

## Current Implementation Status

**Completed**:
- Calendar UI with date selection
- Schedule input form UI
- Basic navigation and modals

**Pending**:
- Drift database schema and DAO implementation
- Save schedule functionality
- Load schedules for selected date
- Provider state management integration
- API integration with Dio (if backend planned)
