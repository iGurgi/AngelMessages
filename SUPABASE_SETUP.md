# Supabase Setup Guide for Angel Messages

This guide walks you through setting up the Supabase backend for the Angel Messages app.

## Overview

Angel Messages uses Supabase as a backend to:
- Store messages in a PostgreSQL database
- Expose messages via PostgREST API
- Enable secure public read access with Row Level Security

## Step-by-Step Setup

### 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Sign in or create an account
3. Click **"New Project"**
4. Fill in the project details:
   - **Name**: Angel Messages (or your preferred name)
   - **Database Password**: Choose a strong password (save this)
   - **Region**: Choose closest to your users
   - **Pricing Plan**: Free tier works great for development

5. Click **"Create new project"** and wait for provisioning (2-3 minutes)

### 2. Create the Messages Table

Once your project is ready:

1. Navigate to **SQL Editor** in the left sidebar
2. Click **"New Query"**
3. Copy and paste this SQL:

```sql
-- Create messages table
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  category TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for ordering
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);

-- Enable Row Level Security
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Allow public read access"
  ON messages
  FOR SELECT
  TO anon
  USING (true);

-- Seed initial angel-themed messages
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
  
  ('New Beginnings', 'Today marks a fresh start. The universe is aligning to support your highest good. Step forward with faith, knowing that miracles await you.', 'new_beginnings'),
  
  ('Courage and Strength', 'You possess a strength that comes from divine source. Any obstacle before you is an opportunity to demonstrate your resilience. You are more powerful than you know.', 'strength'),
  
  ('Forgiveness and Release', 'Let go of what weighs heavy on your heart. Forgiveness is a gift you give yourself. Release the past and step into the freedom that awaits you.', 'forgiveness'),
  
  ('Purpose and Meaning', 'You were born with a unique mission. Your gifts are needed in this world. Trust that your purpose will reveal itself as you follow your heart.', 'purpose'),
  
  ('Divine Timing', 'Everything is unfolding in perfect timing. What is meant for you will not pass you by. Surrender your need to control and trust in divine orchestration.', 'timing'),
  
  ('Sacred Connection', 'You are never alone. Invisible threads connect you to the divine, to your angels, to all of creation. Feel this connection and draw strength from it.', 'connection');
```

4. Click **"Run"** to execute the SQL
5. Verify success: You should see "Success. No rows returned"

### 3. Get Your API Credentials

1. In your Supabase project dashboard, click **Settings** in the left sidebar
2. Click **API** in the settings menu
3. Find the following values:

#### Project URL
Located under "Project URL"
- Example: `https://abcdefghijklmnop.supabase.co`
- Copy this entire URL

#### Anon Key
Located under "Project API keys" → "anon" "public"
- This is a long string starting with `eyJ...`
- Click the copy icon to copy it
- This key is safe to use in client-side code

### 4. Configure the Angel Messages App

Open your Flutter project and update these files:

#### File 1: `lib/providers/repository_providers.dart`

Find these lines (around line 11-12):

```dart
const String _supabaseUrl = 'https://your-project.supabase.co';
const String _supabaseAnonKey = 'your-anon-key';
```

Replace with your actual values:

```dart
const String _supabaseUrl = 'https://abcdefghijklmnop.supabase.co';  // Your Project URL
const String _supabaseAnonKey = 'eyJhbGc...your-actual-key';  // Your anon key
```

#### File 2: `lib/main.dart`

Find the `callbackDispatcher()` function (around line 19-21) and update:

```dart
final supabaseService = SupabaseService(
  supabaseUrl: 'https://abcdefghijklmnop.supabase.co',  // Your Project URL
  supabaseAnonKey: 'eyJhbGc...your-actual-key',  // Your anon key
);
```

### 5. Test Your Setup

1. Run the app: `flutter run`
2. The app should launch successfully
3. Pull down to refresh on the home screen
4. You should see the seeded messages appear

If messages don't load:
- Check your API credentials are correct
- Verify Row Level Security policy is enabled
- Check the Supabase logs in your dashboard

## Verify Your Setup

You can test your API directly using curl:

```bash
curl 'https://YOUR-PROJECT.supabase.co/rest/v1/messages?order=created_at.desc' \
  -H "apikey: YOUR-ANON-KEY" \
  -H "Authorization: Bearer YOUR-ANON-KEY"
```

You should see JSON output with your messages.

## Adding More Messages

To add more messages through the Supabase dashboard:

1. Go to **Table Editor** in the sidebar
2. Select the **messages** table
3. Click **"Insert row"**
4. Fill in:
   - **title**: Message title
   - **body**: Full message text
   - **category**: Category name (guidance, peace, love, etc.)
   - **id** and **created_at** will auto-generate
5. Click **"Save"**

The app will automatically sync new messages during the next daily background sync or when you pull to refresh.

## Security Notes

- ✅ The anon key is safe to use in client apps
- ✅ Row Level Security ensures users can only read, not write
- ✅ All message access is read-only via the policy
- ⚠️ Never commit your actual keys to public repositories
- 💡 Consider using environment variables for production

## Troubleshooting

### "Failed to load messages" error

1. Check Supabase project is active (not paused)
2. Verify API credentials are correct
3. Check Row Level Security policy exists
4. Look at Supabase logs: Dashboard → Logs → API

### Messages not syncing in background

- WorkManager requires network connection
- Background sync runs every 24 hours
- Test with pull-to-refresh instead

### "Network connection failed"

- Check device internet connection
- Verify Supabase project is not paused
- Try accessing the API URL directly in a browser

## Production Considerations

For production deployment:

1. **Environment Variables**: Store credentials securely
   ```dart
   const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
   const supabaseKey = String.fromEnvironment('SUPABASE_KEY');
   ```

2. **Rate Limiting**: Monitor API usage in Supabase dashboard

3. **Database Backups**: Enable automatic backups in Supabase project settings

4. **CDN**: Consider using Supabase Storage for any message images

5. **Monitoring**: Set up logging and error tracking (Sentry, etc.)

---

Need help? Check the [Supabase Documentation](https://supabase.com/docs) or open an issue on GitHub.
