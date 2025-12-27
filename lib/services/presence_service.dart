import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/features/auth/notifiers/current_user_notifier.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'presence_service.g.dart';

@Riverpod(keepAlive: true)
class PresenceService extends _$PresenceService {
  RealtimeChannel? _channel;
  Timer? _heartbeatTimer;

  @override
  void build() {
    final user = ref.watch(currentUserProvider);
    if (user != null) {
      _initializePresence(user.id);
    } else {
      _cleanup();
    }

    ref.onDispose(() {
      _cleanup();
    });
  }

  void _initializePresence(String userId) {
    _cleanup();

    final supabase = ref.read(supabaseProvider);
    
    // Create a channel for presence tracking
    _channel = supabase.channel('presence:online_users');

    _channel?.onPresenceSync((payload) {
      if (kDebugMode) {
        print('Presence synced: ${_channel?.presenceState()}');
      }
    }).onPresenceJoin((payload) {
      if (kDebugMode) {
        print('User joined: ${payload.newPresences}');
      }
    }).onPresenceLeave((payload) {
      if (kDebugMode) {
        print('User left: ${payload.leftPresences}');
      }
    });

    _channel?.subscribe((status, [error]) async {
      if (status == RealtimeSubscribeStatus.subscribed) {
        await goOnline();
      }
    });
  }

  Future<void> goOnline() async {
    final user = ref.read(currentUserProvider);
    if (user == null || _channel == null) return;

    // 1. Track the user in Realtime. 
    // This is the source of truth for "is online". 
    // If the app crashes or loses internet, the Realtime server will 
    // automatically remove the user from presence after a timeout (~10s).
    await _channel?.track({
      'user_id': user.id,
      'online_at': DateTime.now().toIso8601String(),
    });

    // 2. Initial "Last Seen" update in DB
    await _updateLastSeen(user.id, isOnline: true);

    // 3. Start Heartbeat to keep "Last Seen" updated even if a crash occurs later
    _startHeartbeat(user.id);
  }

  Future<void> goOffline() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    // 1. Untrack from realtime immediately
    await _channel?.untrack();

    // 2. Final "Last Seen" update in DB
    await _updateLastSeen(user.id, isOnline: false);
    
    _cleanup();
  }

  void _startHeartbeat(String userId) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _updateLastSeen(userId, isOnline: true);
    });
  }

  Future<void> _updateLastSeen(String userId, {bool isOnline = true}) async {
    try {
      await ref.read(supabaseProvider)
          .from('user_presence')
          .upsert({
            'user_id': userId,
            'last_seen_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'is_online': isOnline, 
          });
    } catch (e) {
      if (kDebugMode) print('Error updating last seen: $e');
    }
  }

  void _cleanup() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _channel?.unsubscribe();
    _channel = null;
  }

  /// Handles app lifecycle changes
  void handleLifecycleChange(bool isResumed) {
    if (isResumed) {
      goOnline();
    } else {
      goOffline();
    }
  }
}
