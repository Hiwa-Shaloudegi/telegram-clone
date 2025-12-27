import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app.dart';
import 'package:telegram_clone/services/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeSupabase();
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: false, //!kReleaseMode,
        builder: (context) => const App(),
      ),
    ),
  );
}
