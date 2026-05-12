# Angel Messages

A cross-platform mobile app delivering inspirational angel-themed messages through scheduled notifications.

## Overview

Angel Messages is designed for spiritual individuals who seek daily guidance and inspiration. The app delivers carefully curated messages at special times throughout the day, creating meaningful moments of reflection and connection.

### Features

- 📱 **Offline-First Architecture**: All messages stored locally with daily background sync
- 🔔 **Smart Notifications**: Choose between Angel Times (sacred moments like 11:11) or hourly messages
- ✨ **Beautiful UI**: Dark-mode-first design with celestial themes and starfield animations
- 🔄 **Auto-Sync**: Daily background refresh of new messages
- 🎯 **Viewed Tracking**: Never see the same message twice until you've read them all

## Tech Stack

- **Flutter**: 3.24.5
- **Dart**: 3.5.4
- **State Management**: Riverpod 2.5.1
- **Local Database**: Isar 3.1.8
- **Backend**: Supabase (PostgREST)
- **Notifications**: flutter_local_notifications 17.2.3
- **Routing**: go_router 14.3.0

## Prerequisites

- Flutter SDK 3.24.5 (use FVM: `fvm use 3.24.5`)
- Dart SDK 3.5.4
- Xcode 16.0+ (for iOS)
- Android Studio with SDK 26+ (for Android)
- Supabase account

## Setup Instructions

### 1. Clone and Install Dependencies

```bash
git clone https://github.com/iGurgi/AngelMessages.git
cd AngelMessages
fvm use 3.24.5
flutter pub get
```

### 2. Supabase Setup

#### Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Navigate to the SQL Editor and run this schema:

```sql
-- Create messages table
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  category TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Allow public read access"
  ON messages
  FOR SELECT
  TO anon
  USING (true);

-- Seed initial messages
INSERT INTO messages (title, body, category) VALUES
  ('Divine Guidance', 'Your angels are always with you, guiding each step of your journey. Trust in the wisdom that flows through you and know that you are exactly where you need to be.', 'guidance'),
  ('Inner Peace', 'In this moment, breathe deeply and feel the peace that surrounds you. Release all worry and embrace the tranquility that is your birthright. You are safe, you are loved.', 'peace'),
  ('Manifesting Abundance', 'The universe conspires in your favor. Your dreams are taking shape in ways you cannot yet see. Keep your heart open and your intentions clear—abundance flows to you naturally.', 'abundance'),
  ('Love and Connection', 'You are a beacon of divine love. Every soul you encounter is blessed by your presence. Share your light freely, for it multiplies with every act of kindness.', 'love'),
  ('Spiritual Awakening', 'Your spiritual journey is unfolding perfectly. Each challenge is an opportunity for growth, each moment a chance to deepen your connection to the divine. You are awakening.', 'awakening'),
  ('Protection and Safety', 'Surrounded by angelic light, you are protected from all harm. Your energy field is strong, your path is clear. Walk forward with confidence and courage.', 'protection'),
  ('Healing Energy', 'Healing light flows through every cell of your being. Release what no longer serves you and embrace the renewal that comes with each breath. You are healing, you are whole.', 'healing'),
  ('Intuition and Wisdom', 'Your intuition is your superpower. Listen to the whispers of your soul—they carry ancient wisdom and divine guidance. Trust yourself completely.', 'intuition'),
  ('Gratitude and Joy', 'Take a moment to appreciate the magic in your life. Gratitude opens doors to infinite blessings. Your joy is a gift to the world.', 'gratitude'),
  ('New Beginnings', 'Today marks a fresh start. The universe is aligning to support your highest good. Step forward with faith, knowing that miracles await you.', 'new_beginnings');
```

#### Get API Credentials

1. In your Supabase project, go to Settings → API
2. Copy your **Project URL** (e.g., `https://xxxxx.supabase.co`)
3. Copy your **anon/public** key

#### Configure the App

Open `lib/providers/repository_providers.dart` and update:

```dart
const String _supabaseUrl = 'YOUR_SUPABASE_URL';
const String _supabaseAnonKey = 'YOUR_ANON_KEY';
```

Also update in `lib/main.dart` in the `callbackDispatcher` function.

### 3. Code Generation

Run build_runner to generate all required code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- Freezed models (`.freezed.dart`)
- JSON serialization (`.g.dart`)
- Isar schemas (`.isar.dart`)
- Riverpod providers (`.g.dart`)

### 4. Run the App

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## Project Structure

```
lib/
├── data/
│   ├── database.dart              # Isar database setup
│   └── message_repository.dart    # Message CRUD and sync
├── models/
│   ├── message.dart               # Message data model
│   └── schedule_category.dart     # Schedule enum
├── providers/
│   ├── message_providers.dart     # Message state providers
│   ├── permission_providers.dart  # Permission state providers
│   ├── repository_providers.dart  # Service dependency injection
│   └── schedule_providers.dart    # Schedule state providers
├── router/
│   └── app_router.dart            # GoRouter configuration
├── screens/
│   ├── home_screen.dart           # Message list screen
│   ├── message_detail_screen.dart # Full message view
│   └── settings_screen.dart       # App settings
├── services/
│   ├── notification_scheduler.dart # Notification logic
│   └── supabase_service.dart      # API client
├── theme/
│   └── app_theme.dart             # Material 3 theme
├── widgets/
│   ├── message_card.dart          # Message list item
│   └── starfield_background.dart  # Animated background
└── main.dart                       # App entry point
```

## Notification Schedules

### Angel Times
Messages at sacred moments:
- 1:11, 2:22, 3:33, 4:44, 5:55
- 11:11, 12:12, 22:22

### Every Hour
Messages at the top of each hour (0:00, 1:00, 2:00, etc.)

## Platform-Specific Setup

### Android

Permissions are automatically requested. For Android 14+ (API 34), the app requests `SCHEDULE_EXACT_ALARM` permission for precise notification timing.

### iOS

1. Enable Background Modes in Xcode:
   - Background fetch
   - Background processing
   - Remote notifications

2. Add BGTaskScheduler identifiers in Info.plist (already configured)

## Testing

Run tests with coverage:

```bash
flutter test --coverage
```

## Building for Release

### Android

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ipa --release
```

## Architecture Notes

This project follows the locked architecture specification with:

- **Riverpod** for dependency injection and state management
- **Isar 3.1.8** for local database (locked to avoid breaking changes in 4.x)
- **Freezed** for immutable data models
- **GoRouter 14.3.0** for declarative routing
- **WorkManager** for background sync on Android
- **Material 3** design system with custom theming

## Troubleshooting

### Build Runner Issues

If code generation fails:
```bash
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Permission Issues on Android

Ensure your `AndroidManifest.xml` includes all required permissions. If notifications don't work on Android 14+, check that exact alarm permissions are granted in system settings.

### iOS Background Fetch Not Working

1. Verify Background Modes are enabled in Xcode
2. Check that `Info.plist` includes the correct UIBackgroundModes
3. Background fetch may not trigger in debug mode; test on a physical device

## Contributing

This project follows strict architectural guidelines. Before contributing:
1. Review `analysis_options.yaml` for linting rules
2. Maintain 80%+ test coverage
3. Follow the Riverpod codegen pattern
4. Never upgrade dependencies without approval

## License

MIT License - See LICENSE file for details

## Support

For issues or questions, please open a GitHub issue.

---

Built with 💜 for the spiritual community
