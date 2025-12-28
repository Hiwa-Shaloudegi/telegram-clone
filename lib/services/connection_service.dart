import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'connection_service.g.dart';

enum TelegramConnectionState { waitingForNetwork, connecting, updating, connected }

@riverpod
Stream<List<ConnectivityResult>> connectivityStream(Ref ref) {
  return Connectivity().onConnectivityChanged;
}

@riverpod
Stream<RealtimeSubscribeStatus> channelStatusStream(Ref ref) {
  final controller = StreamController<RealtimeSubscribeStatus>();
  
  final supabase = ref.read(supabaseProvider);
  final channel = supabase.channel('public:messages');

  channel.subscribe((status, error) {
    if (!controller.isClosed) {
      controller.add(status);
    }
  });

  ref.onDispose(() {
    supabase.removeChannel(channel);
    controller.close();
  });

  return controller.stream;
}

@riverpod
class IsSyncing extends _$IsSyncing {
  @override
  bool build() => false;
  void toggle(bool val) => state = val;
}

@riverpod
TelegramConnectionState appConnectionStatus(Ref ref) {
  final connectivity = ref.watch(connectivityStreamProvider).value;
  final channelStatus = ref.watch(channelStatusStreamProvider).value;
  final isSyncing = ref.watch(isSyncingProvider);

  if (connectivity == null || connectivity.contains(ConnectivityResult.none)) {
    return TelegramConnectionState.waitingForNetwork;
  }

  if (channelStatus != RealtimeSubscribeStatus.subscribed) {
    return TelegramConnectionState.connecting;
  }

  if (isSyncing) {
    return TelegramConnectionState.updating;
  }

  return TelegramConnectionState.connected;
}