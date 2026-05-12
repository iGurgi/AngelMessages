# Development Guide

## Initial Setup

This project uses code generation extensively. Before you can run the app or tests, you MUST generate the required files.

### Step 1: Install Dependencies

```bash
flutter pub get
```

**Note**: This step may show errors about missing generated files. This is expected and normal.

### Step 2: Generate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `*.g.dart` - JSON serialization, Riverpod providers, and Drift database
- `*.freezed.dart` - Immutable data classes
- `*.drift.dart` - Database schemas

### Step 3: Verify Setup

```bash
flutter analyze
flutter test
```

## Code Generation During Development

Whenever you modify:
- Models (Message, ScheduleCategory)
- Providers (@riverpod annotated classes)
- Database schemas

You must regenerate code:

```bash
# Watch mode - automatically regenerates on file changes
dart run build_runner watch --delete-conflicting-outputs

# One-time generation
dart run build_runner build --delete-conflicting-outputs
```

## CI/CD Note

The CI pipeline automatically runs code generation before analysis and testing. If CI fails on "Get dependencies", it's likely due to a dependency version conflict or SDK mismatch, not the code generation issue.

## Common Issues

### "Part file doesn't exist"

**Solution**: Run `dart run build_runner build --delete-conflicting-outputs`

### "Conflicting outputs"

**Solution**: Use the `--delete-conflicting-outputs` flag or manually delete generated files:
```bash
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
find . -name "*.drift.dart" -delete
dart run build_runner build --delete-conflicting-outputs
```

### Build Runner Hangs

**Solution**: 
```bash
dart run build_runner clean
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/message_test.dart
```

## Formatting

```bash
# Check formatting
dart format --output=none --set-exit-if-changed lib test

# Fix formatting
dart format lib test
```

## Analysis

```bash
flutter analyze
```

## Building

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Debug
flutter build ios --debug --no-codesign

# Release (requires Apple Developer account)
flutter build ios --release
flutter build ipa --release
```

## Architecture Overview

```
lib/
├── data/           # Database and repositories
├── models/         # Data models (with Freezed)
├── providers/      # Riverpod state management
├── router/         # GoRouter navigation
├── screens/        # UI screens
├── services/       # Business logic services
├── theme/          # Material 3 theming
├── widgets/        # Reusable UI components
└── main.dart       # App entry point
```

## Key Dependencies

- **flutter_riverpod** ^2.5.1 - State management
- **drift** ^2.18.0 - Local SQLite database (offline-first)
- **freezed** ^2.5.7 - Immutable models
- **go_router** ^14.3.0 - Declarative routing
- **flutter_local_notifications** ^17.2.3 - Notifications

### Why Drift?

Drift (formerly Moor) provides type-safe SQL database access compatible with Dart 3.5+ and offers excellent offline-first capabilities for our angel messages app.

## Debug Tips

### Enable Flutter Inspector

```bash
flutter run --dart-define=INSPECTOR=true
```

### Check Riverpod Provider Graph

Install the Riverpod DevTools extension in your IDE or use the Dart DevTools.

### Database Inspection

Drift databases are SQLite files stored in the app's documents directory. You can use various SQLite inspection tools or Drift's built-in debugging:

```bash
# Find your app's data directory
flutter run
# Database file will be at: <app_documents>/angel_messages.db
```

### Notification Testing

Notifications require physical devices (not simulators). Use the immediate notification method for testing:

```dart
// In your code
await NotificationScheduler().showImmediateNotification(
  title: 'Test',
  body: 'Testing notifications',
);
```

## Contributing Guidelines

1. Create a feature branch from `main`
2. Make your changes
3. Run code generation if needed
4. Run tests: `flutter test`
5. Run analyzer: `flutter analyze`
6. Format code: `dart format lib test`
7. Commit with descriptive message
8. Push and create PR

### Code Style

- Follow the linter rules in `analysis_options.yaml`
- Use `const` constructors where possible
- Prefer `final` over `var`
- Use trailing commas for better formatting
- Write tests for new features

## Release Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Update CHANGELOG.md
- [ ] Run full test suite
- [ ] Test on physical iOS device
- [ ] Test on physical Android device
- [ ] Update README if needed
- [ ] Create git tag
- [ ] Build release artifacts
- [ ] Test release builds on devices

## Need Help?

- Check the main README.md for setup instructions
- Review SUPABASE_SETUP.md for backend configuration
- Open a GitHub issue for bugs or feature requests
