# Angel Messages

A spiritual messaging app delivering daily angel-themed inspirational notifications.

## Overview

Angel Messages is a cross-platform mobile app for spiritual users who identify as witchy or spiritual but not religious. The app delivers inspirational messages through push notifications at customizable times, with full offline support.

## Features

- ✨ **Daily Angel Messages** - Receive inspirational guidance from your angels
- 🔔 **Smart Notifications** - Choose between "Angel Times" (1:11, 2:22, etc.) or hourly notifications
- 📱 **Offline First** - All messages stored locally, works without internet
- 🌙 **Beautiful Dark Theme** - Material 3 design with deep purples, soft golds, and muted lavenders
- 🎨 **Immersive Experience** - Starfield animations and elegant typography
- 🔄 **Background Sync** - Automatically fetches new messages daily

## Tech Stack

- **Flutter** 3.24.5
- **Dart** 3.5.4
- **State Management** Riverpod 2.5.1 (with code generation)
- **Database** Isar 3.1.8 (offline-first NoSQL)
- **Routing** go_router 14.3.0
- **Notifications** flutter_local_notifications 17.2.3
- **Background Tasks** workmanager 0.5.2
- **UI/UX** Material 3, Google Fonts (Cinzel + Raleway)

## Getting Started

### Prerequisites

- Flutter 3.24.5 (use FVM: `fvm use 3.24.5`)
- Dart 3.5.4
- Xcode 16.0+ (for iOS)
- Android Studio with SDK 35 (for Android)

### Installation

1. Clone the repository
```bash
git clone https://github.com/iGurgi/AngelMessages.git
cd AngelMessages
```

2. Install FVM and set Flutter version
```bash
fvm install 3.24.5
fvm use 3.24.5
```

3. Get dependencies
```bash
fvm flutter pub get
```

4. Generate code
```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

5. Run the app
```bash
fvm flutter run
```

## Configuration

### Supabase Setup

1. Create a Supabase project at https://supabase.com
2. Create a `messages` table with the following schema:

```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  category TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Allow public reads only
CREATE POLICY "Allow public read access" ON messages
  FOR SELECT USING (true);
```

3. Seed with initial messages:

```sql
INSERT INTO messages (title, body, category) VALUES
  ('Divine Guidance', 'The angels remind you that you are exactly where you need to be...', 'guidance'),
  ('Inner Peace', 'Find stillness within the chaos...', 'peace'),
  ('Abundance Flows', 'You are a magnet for miracles and abundance...', 'abundance');
```

4. Update `lib/main.dart` with your Supabase credentials:

```dart
const String supabaseUrl = 'https://your-project.supabase.co';
const String supabaseAnonKey = 'your-anon-key';
```

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── message.dart               # Message data model (Isar)
│   └── schedule_category.dart     # Notification schedule types
├── repositories/
│   └── message_repository.dart    # Data layer (Isar + Supabase)
├── providers/
│   ├── messages_provider.dart     # Message state management
│   └── schedule_notifier.dart     # Schedule state management
├── services/
│   ├── notification_scheduler.dart # Notification scheduling logic
│   ├── permission_service.dart    # Permission handling
│   └── background_sync.dart       # WorkManager background tasks
├── router/
│   └── app_router.dart           # go_router configuration
├── theme/
│   └── app_theme.dart            # Material 3 theme
├── screens/
│   ├── home_screen.dart          # Message list
│   ├── message_detail_screen.dart # Full message view
│   └── settings_screen.dart      # Settings
└── widgets/
    ├── message_card.dart         # Message card component
    └── starfield_painter.dart    # Custom painter for animations
```

## Architecture

The app follows a **Riverpod Architecture** with offline-first principles:

1. **Data Layer** - Isar for local storage, Dio for API calls
2. **Repository Pattern** - MessageRepository handles data sync
3. **State Management** - Riverpod with code generation
4. **UI Layer** - Material 3 widgets with custom theming

### Offline-First Strategy

- Messages are cached locally in Isar database
- App works fully offline after initial sync
- Background sync runs daily via WorkManager
- Viewed status persists locally
- When all messages are viewed, flags reset automatically

## Permissions

### Android
- `POST_NOTIFICATIONS` - Required for Android 13+
- `SCHEDULE_EXACT_ALARM` - Required for Android 14+ exact-time notifications
- `INTERNET` - For API sync

### iOS
- `UIBackgroundModes` - fetch, processing, remote-notification
- Custom URL scheme `angelmessages://` for deep linking

## Testing

Run tests:
```bash
fvm flutter test
```

Run with coverage:
```bash
fvm flutter test --coverage
```

## Building

### Android
```bash
fvm flutter build apk --release
```

### iOS
```bash
fvm flutter build ios --release
```

## License

Copyright © 2024 Angel Messages. All rights reserved.

## Support

For issues and feature requests, please use GitHub Issues.
