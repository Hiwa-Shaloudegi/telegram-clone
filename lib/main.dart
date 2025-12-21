import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app.dart';

void main() {
  runApp(ProviderScope(child: const App()));
}
