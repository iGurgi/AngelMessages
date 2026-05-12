# Angel Messages

A spiritual messaging app delivering daily inspirational messages for the witchy and spiritual community.

## Features

- 📱 Daily inspirational angel messages
- 🔔 Smart notifications (Angel Times: 1:11, 2:22, 3:33, etc., or Every Hour)
- 💾 Offline-first architecture with local persistence
- 🌙 Beautiful dark-mode-first Material 3 design
- ✨ Immersive message reading experience
- 🔄 Automatic daily message synchronization

## Tech Stack

- **Flutter**: 3.24.5
- **Dart**: 3.5.4
- **State Management**: Riverpod 2.5.1
- **Database**: Isar 3.1.8
- **Routing**: GoRouter 14.3.0
- **Notifications**: Flutter Local Notifications 17.2.3

## Setup

### Prerequisites

- Flutter 3.24.5 (managed via FVM)
- Dart 3.5.4
- Xcode 16.0+ (for iOS)
- Android Studio with API 26+ SDK

### Installation

1. Install FVM:
   ```bash
   dart pub global activate fvm
   ```

2. Install Flutter 3.24.5:
   ```bash
   fvm install 3.24.5
   fvm use 3.24.5 --force
   ```

3. Get dependencies:
   ```bash
   fvm flutter pub get
   ```

4. Run code generation:
   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Supabase Setup

1. Create a new Supabase project at https://supabase.com
2. Create the `messages` table:

```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  category TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Create policy for public reads
CREATE POLICY "Allow public read access" ON messages
  FOR SELECT USING (true);

-- Seed initial messages
INSERT INTO messages (title, body, category) VALUES
  ('Divine Guidance', 'The angels are with you, guiding your steps. Trust in the journey and know that you are never alone.', 'guidance'),
  ('Inner Strength', 'You possess an inner strength that shines brighter than any star. Today, let that light guide you forward.', 'strength'),
  ('Manifestation', 'Your thoughts are powerful. Focus on what you wish to create, and the universe will conspire to help you.', 'manifestation'),
  ('Protection', 'You are surrounded by divine protection. Release your fears and step into your power with confidence.', 'protection'),
  ('Love & Light', 'Love flows through you and radiates from you. Share your light generously; the world needs your magic.', 'love'),
  ('Synchronicity', 'The universe is speaking to you through signs and synchronicities. Pay attention to the messages around you.', 'signs'),
  ('Healing Energy', 'Healing energy surrounds you now. Allow yourself to rest, recover, and emerge renewed and refreshed.', 'healing'),
  ('Abundance', 'Abundance is your birthright. Open your heart to receive the blessings that flow freely to you.', 'abundance');
```

3. Get your Supabase URL and anon key from Project Settings > API
4. Create `.env` file in project root:
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_anon_key
   ```

### Running the App

```bash
# iOS
fvm flutter run -d ios

# Android
fvm flutter run -d android
```

### Testing

```bash
# Run all tests
fvm flutter test

# Run with coverage
fvm flutter test --coverage --reporter=expanded
```

## Architecture

The app follows Riverpod Architecture with offline-first principles:

```
lib/
├── core/
│   ├── theme/          # Material 3 theme configuration
│   ├── routing/        # GoRouter configuration
│   └── constants/      # App-wide constants
├── features/
│   ├── messages/       # Message display and management
│   ├── settings/       # User preferences
│   └── notifications/  # Notification scheduling
└── shared/
    ├── providers/      # Global Riverpod providers
    └── utils/          # Utility functions
```

## Permissions

### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSUserNotificationsUsageDescription</key>
<string>We need notification permission to send you daily inspirational messages</string>
```

### Android
Permissions in `android/app/src/main/AndroidManifest.xml`:
- `POST_NOTIFICATIONS` (API 33+)
- `SCHEDULE_EXACT_ALARM` (API 34+)
- `INTERNET`
- `ACCESS_NETWORK_STATE`

## License

MIT License - See LICENSE file for details
