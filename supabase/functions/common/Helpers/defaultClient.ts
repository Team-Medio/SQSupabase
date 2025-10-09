import { createClient } from 'jsr:@supabase/supabase-js@2'

export const defaultClient = (authorization: string) => createClient( 
    Deno.env.get('SUPABASE_URL') ?? '',
     Deno.env.get('SUPABASE_ANON_KEY') ?? '',
    { global: { headers: { Authorization: authorization! } } }
  )