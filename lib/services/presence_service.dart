import 'dart:async';

import 'package:logger/web.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/logger/logger.dart';
import 'package:telegram_clone/features/auth/notifiers/current_user_notifier.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'presence_service.g.dart';

@Riverpod(keepAlive: true)
class PresenceService extends _$PresenceService {
  RealtimeChannel? _channel;
  Timer? _heartbeatTimer;
  late Logger logger;
  bool _shouldBeOnline = true;

  @override
  void build() {
    logger = ref.read(loggerProvider);

    // Watch the user to handle cold starts and login events reactively
    final user = ref.watch(currentUserProvider);

    if (user != null) {
      // Use microtask to perform side effects outside the build cycle
      Future.microtask(() => _initializePresence(user.id));
    } else {
      Future.microtask(() => _cleanup());
    }

    ref.onDispose(() {
      _cleanup();
    });
  }

  void _initializePresence(String userId) {
    logger.d('Initializing presence for userId: $userId');
    // Avoid re-initializing if already tracking the same user
    if (_channel != null &&
        ref.read(supabaseProvider).auth.currentUser?.id == userId) {
      logger.d('Channel already exists for this user, skipping init.');
      return;
    }

    _cleanup();

    final supabase = ref.read(supabaseProvider);
    
    // Create a channel for presence tracking
    _channel = supabase.channel('presence:online_users');

    _channel?.onPresenceSync((payload) {
          logger.d('Presence synced: ${_channel?.presenceState()}');
    }).onPresenceJoin((payload) {
          logger.d('User joined: ${payload.newPresences}');
    }).onPresenceLeave((payload) {
          logger.d('User left: ${payload.leftPresences}');
    });

    _channel?.subscribe((status, [error]) async {
      logger.d('Presence Channel Status: $status, Error: $error');
      if (status == RealtimeSubscribeStatus.subscribed) {
        await goOnline();
      }
    });
  }

  Future<void> goOnline() async {
    _shouldBeOnline = true;
    final user = ref.read(currentUserProvider);

    if (user == null) return;

    // If channel is null (cleaned up), re-initialize it
    if (_channel == null) {
      _initializePresence(user.id);
      return;
    }

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
    _shouldBeOnline = false;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    // 1. Untrack from realtime immediately
    await _channel?.untrack();

    // 2. Final "Last Seen" update in DB
    await _updateLastSeen(user.id, isOnline: false);
    
    // Only cleanup if we are still supposed to be offline
    if (!_shouldBeOnline) {
      _cleanup();
    }
  }

  void _startHeartbeat(String userId) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _updateLastSeen(userId, isOnline: true);
    });
  }

  Future<void> _updateLastSeen(String userId, {bool isOnline = true}) async {
    // Prevent overwriting online status if we just resumed
    if (isOnline == false && _shouldBeOnline) {
      logger.d('Skipping offline update because user resumed.');
      return;
    }

    try {
      final supabase = ref.read(supabaseProvider);
      
      // Basic upsert without .select() to reduce overhead and potential 403 triggers
      await supabase.from('user_presence').upsert({
        'user_id': userId,
        'last_seen_at': DateTime.now().toIso8601String(),
        'is_online': isOnline,
      });

      logger.d(
        'Successfully updated presence for $userId. isOnline: $isOnline',
      );
    } catch (e, stack) {
      logger.e(
        'Error updating last seen. isOnline: $isOnline',
        error: e,
        stackTrace: stack,
      );
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
