import 'package:supabase/supabase.dart';

const supabaseUrl = 'https://xfgrxmbysmngnwkzipkq.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmZ3J4bWJ5c21uZ253a3ppcGtxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzNjc0MzgsImV4cCI6MjA1NDk0MzQzOH0.y72dz0mzcvEwyatpMZ4TVwDp2wZaydYRg4lDVu166fk';

final supabase = SupabaseClient(supabaseUrl, supabaseAnonKey);