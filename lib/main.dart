import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app.dart';
import 'package:telegram_clone/services/supabase_client.dart';

void main() async {
  await initializeSupabase();
  runApp(ProviderScope(child: const App()));
}
