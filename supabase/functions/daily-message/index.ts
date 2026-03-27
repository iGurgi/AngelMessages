import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface DailyMessage {
  id: number
  content: string
  author: string | null
  category: string
  created_at: string
}

interface AnalyticsEvent {
  event_type: string
  user_agent?: string
  timestamp: string
  metadata?: Record<string, any>
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Initialize Supabase client
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    // Get user agent for analytics
    const userAgent = req.headers.get('user-agent') || 'unknown'
    const clientInfo = req.headers.get('x-client-info') || 'unknown'

    console.log('Daily message request received', {
      userAgent,
      clientInfo,
      timestamp: new Date().toISOString()
    })

    // Call the database function to get varied daily message
    const { data: messageData, error: messageError } = await supabaseClient
      .rpc('get_varied_daily_message')
      .single()

    if (messageError) {
      console.error('Error fetching daily message:', messageError)
      
      // Log error analytics
      await logAnalytics(supabaseClient, {
        event_type: 'daily_message_error',
        user_agent: userAgent,
        timestamp: new Date().toISOString(),
        metadata: {
          error: messageError.message,
          code: messageError.code
        }
      })

      return new Response(
        JSON.stringify({ 
          error: 'Failed to fetch daily message',
          details: messageError.message 
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        },
      )
    }

    const message: DailyMessage = messageData

    // Log successful fetch analytics
    await logAnalytics(supabaseClient, {
      event_type: 'daily_message_fetched',
      user_agent: userAgent,
      timestamp: new Date().toISOString(),
      metadata: {
        message_id: message.id,
        category: message.category,
        has_author: !!message.author,
        client_info: clientInfo
      }
    })

    console.log('Daily message served successfully', {
      messageId: message.id,
      category: message.category,
      hasAuthor: !!message.author
    })

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          id: message.id,
          content: message.content,
          author: message.author,
          category: message.category,
          created_at: message.created_at
        }
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      },
    )

  } catch (error) {
    console.error('Unexpected error in daily-message function:', error)
    
    return new Response(
      JSON.stringify({ 
        error: 'Internal server error',
        message: 'An unexpected error occurred while processing your request'
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      },
    )
  }
})

/**
 * Log analytics event to the database
 */
async function logAnalytics(
  supabaseClient: any,
  event: AnalyticsEvent
): Promise<void> {
  try {
    const { error } = await supabaseClient
      .from('analytics_events')
      .insert({
        event_type: event.event_type,
        user_agent: event.user_agent,
        timestamp: event.timestamp,
        metadata: event.metadata || {}
      })

    if (error) {
      console.error('Failed to log analytics:', error)
      // Don't throw - analytics failure shouldn't break the main flow
    }
  } catch (err) {
    console.error('Analytics logging exception:', err)
    // Don't throw - analytics failure shouldn't break the main flow
  }
}
