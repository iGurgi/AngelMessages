# Supabase Setup Guide

This guide walks you through setting up the backend infrastructure for Angel Messages using Supabase.

## Prerequisites

- A Supabase account (sign up at https://supabase.com)
- Access to your Supabase project dashboard

## Step 1: Create a New Project

1. Log in to your Supabase account
2. Click "New Project"
3. Fill in the project details:
   - **Name**: Angel Messages
   - **Database Password**: Choose a strong password
   - **Region**: Select the region closest to your users
4. Click "Create new project"

## Step 2: Create the Messages Table

1. Navigate to the SQL Editor in your Supabase dashboard
2. Run the following SQL script:

```sql
-- Create messages table
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  category TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index on created_at for efficient sorting
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);

-- Enable Row Level Security
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Allow public read access" ON messages
  FOR SELECT USING (true);
```

## Step 3: Seed Initial Messages

Run the following SQL to add initial angel-themed messages:

```sql
INSERT INTO messages (title, body, category) VALUES
  (
    'Divine Guidance',
    'The angels are with you, guiding your steps. Trust in the journey and know that you are never alone. Every challenge you face is an opportunity for growth, and the universe conspires to support your highest good.',
    'guidance'
  ),
  (
    'Inner Strength',
    'You possess an inner strength that shines brighter than any star. Today, let that light guide you forward. Your resilience is a testament to your spiritual power, and you are capable of manifesting miracles.',
    'strength'
  ),
  (
    'Manifestation',
    'Your thoughts are powerful. Focus on what you wish to create, and the universe will conspire to help you. Align your intentions with your highest values, and watch as abundance flows into your life.',
    'manifestation'
  ),
  (
    'Protection',
    'You are surrounded by divine protection. Release your fears and step into your power with confidence. The angels guard your path, and you are safe to explore your fullest potential.',
    'protection'
  ),
  (
    'Love & Light',
    'Love flows through you and radiates from you. Share your light generously; the world needs your magic. Your presence is a gift, and your compassion heals those around you.',
    'love'
  ),
  (
    'Synchronicity',
    'The universe is speaking to you through signs and synchronicities. Pay attention to the messages around you. Every coincidence is a breadcrumb leading you toward your destiny.',
    'signs'
  ),
  (
    'Healing Energy',
    'Healing energy surrounds you now. Allow yourself to rest, recover, and emerge renewed and refreshed. Your body, mind, and spirit are aligning in perfect harmony.',
    'healing'
  ),
  (
    'Abundance',
    'Abundance is your birthright. Open your heart to receive the blessings that flow freely to you. The universe delights in supporting your dreams and desires.',
    'abundance'
  ),
  (
    'Trust the Process',
    'Even when the path ahead seems unclear, trust that you are exactly where you need to be. Divine timing is at work, orchestrating events for your highest good.',
    'guidance'
  ),
  (
    'Your Intuition',
    'Your intuition is your most powerful guide. Listen to the whispers of your soul, for they carry wisdom beyond logic and reason. Trust the knowing that lives within you.',
    'intuition'
  ),
  (
    'Release and Renew',
    'Let go of what no longer serves you. Make space for new blessings by releasing old patterns, beliefs, and energies. Renewal begins with the courage to release.',
    'transformation'
  ),
  (
    'Sacred Connection',
    'You are part of a vast, interconnected web of consciousness. Every being, every star, every molecule is connected through the fabric of love. Feel this sacred connection today.',
    'connection'
  );
```

## Step 4: Get Your API Credentials

1. Go to **Project Settings** > **API**
2. Copy the following values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **Anon/Public Key** (this is your `anon key`)

## Step 5: Configure Your Flutter App

1. Create a `.env` file in your project root (copy from `.env.example`)
2. Add your Supabase credentials:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

## Step 6: Verify the Setup

Test your API endpoint using curl:

```bash
curl 'https://your-project.supabase.co/rest/v1/messages?order=created_at.desc' \
  -H "apikey: your-anon-key" \
  -H "Authorization: Bearer your-anon-key"
```

You should receive a JSON response with your messages.

## API Endpoint Details

### Get All Messages (Newest First)

**Endpoint**: `GET /rest/v1/messages?order=created_at.desc`

**Headers**:
- `apikey`: Your Supabase anon key
- `Authorization`: Bearer {your-anon-key}

**Response**:
```json
[
  {
    "id": "uuid",
    "title": "Message Title",
    "body": "Message body text",
    "category": "category-name",
    "created_at": "2024-01-01T12:00:00Z"
  }
]
```

## Adding New Messages

You can add new messages through the Supabase dashboard or via SQL:

```sql
INSERT INTO messages (title, body, category) VALUES
  ('Your Message Title', 'Your message body', 'category');
```

## Security Notes

1. The `anon` key is safe to use in your Flutter app - it's designed for client-side use
2. Row Level Security ensures users can only read messages, not modify them
3. Never expose your `service_role` key in the client app
4. For production, consider adding rate limiting via Supabase Edge Functions

## Troubleshooting

### Can't connect to Supabase
- Verify your URL and anon key are correct
- Check that RLS policies are properly set up
- Ensure your Supabase project is not paused (free tier limitation)

### No messages returned
- Verify messages exist in the table via SQL Editor
- Check that RLS policy allows public reads
- Test the endpoint directly with curl

### 401 Unauthorized
- Verify the `apikey` header is set correctly
- Ensure the anon key matches your project

## Next Steps

- Consider adding more message categories
- Set up scheduled functions to auto-add messages
- Monitor API usage in the Supabase dashboard
- Implement analytics to track which messages resonate most

---

For more information, visit the [Supabase Documentation](https://supabase.com/docs).
