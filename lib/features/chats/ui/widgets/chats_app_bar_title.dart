import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/services/connection_service.dart';

class ChatsAppBarTitle extends ConsumerWidget {
  const ChatsAppBarTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(appConnectionStatusProvider);

    String text;
    switch (status) {
      case TelegramConnectionState.waitingForNetwork:
        text = 'Waiting for network...';
        break;
      case TelegramConnectionState.connecting:
        text = 'Connecting...';
        break;
      case TelegramConnectionState.updating:
        text = 'Updating...';
        break;
      case TelegramConnectionState.connected:
        text = 'Telegram';
        break;
    }

    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
