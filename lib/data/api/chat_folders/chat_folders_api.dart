import 'dart:async';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/exception/app_exception.dart';
import 'package:telegram_clone/core/exception/exception_handler.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'chat_folders_api.g.dart';

@Riverpod(keepAlive: true)
ChatFoldersApi chatFoldersApi(Ref ref) {
  return ChatFoldersApi(
    supabase: ref.read(supabaseProvider),
    exceptionHandler: ref.read(exceptionHandlerProvider),
  );
}

class ChatFoldersApi {
  final SupabaseClient supabase;
  final ExceptionHandler exceptionHandler;
  final _log = Logger();

  static const int maxNameLength = 12;

  ChatFoldersApi({
    required this.supabase,
    required this.exceptionHandler,
  });

  String get _userId {
    final id = supabase.auth.currentUser?.id;
    if (id == null) {
      throw AppException(
        message: 'Not authenticated',
        userMessage: 'Please log in to continue',
      );
    }
    return id;
  }

  Stream<List<ChatFolderModel>> watchFolders() {
    final controller = StreamController<List<ChatFolderModel>>.broadcast();
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      controller.addError(
        AppException(
          message: 'Not authenticated',
          userMessage: 'Please log in to continue',
        ),
      );
      return controller.stream;
    }

    Future<void> fetch() async {
      try {
        final folders = await getFolders();
        if (!controller.isClosed) controller.add(folders);
      } catch (e, st) {
        _log.e('watchFolders fetch error', error: e, stackTrace: st);
        if (!controller.isClosed) controller.addError(e);
      }
    }

    fetch();
    _startPolling(controller, fetch);

    controller.onCancel = () {
      _pollTimer?.cancel();
    };

    return controller.stream;
  }

  Future<List<ChatFolderModel>> getFolders() async {
    try {
      final response = await supabase
          .from('chat_folders')
          .select('*, user_chat_folders(chat_id)')
          .eq('user_id', _userId)
          .order('position', ascending: true);

      return (response as List<dynamic>)
          .map((e) => ChatFolderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<ChatFolderModel> getFolder(String folderId) async {
    try {
      final response = await supabase
          .from('chat_folders')
          .select('*, user_chat_folders(chat_id)')
          .eq('id', folderId)
          .eq('user_id', _userId)
          .single();

      return ChatFolderModel.fromJson(response);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<ChatFolderModel> createFolder({
    required String name,
    List<String> chatIds = const [],
  }) async {
    try {
      final trimmed = _validateName(name);
      final existing = await getFolders();

      // Check for duplicate folder name
      if (existing.any((f) => f.name.toLowerCase() == trimmed.toLowerCase())) {
        throw AppException(
          message: 'Folder name already exists',
          userMessage: 'A folder with this name already exists',
        );
      }

      final position = existing.isEmpty
          ? 0
          : existing.map((f) => f.position).reduce((a, b) => a > b ? a : b) + 1;

      final inserted = await supabase
          .from('chat_folders')
          .insert({
            'user_id': _userId,
            'name': trimmed,
            'position': position,
          })
          .select()
          .single();

      final folderId = inserted['id'] as String;

      if (chatIds.isNotEmpty) {
        await _insertFolderItems(folderId, chatIds);
      }

      return getFolder(folderId);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<ChatFolderModel> updateFolderName({
    required String folderId,
    required String name,
  }) async {
    try {
      final trimmed = _validateName(name);

      // Check for duplicate folder name (excluding the folder being renamed)
      final existing = await getFolders();
      if (existing.any((f) =>
          f.id != folderId &&
          f.name.toLowerCase() == trimmed.toLowerCase())) {
        throw AppException(
          message: 'Folder name already exists',
          userMessage: 'A folder with this name already exists',
        );
      }

      await supabase
          .from('chat_folders')
          .update({'name': trimmed})
          .eq('id', folderId)
          .eq('user_id', _userId);

      return getFolder(folderId);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<void> deleteFolder(String folderId) async {
    try {
      await supabase
          .from('chat_folders')
          .delete()
          .eq('id', folderId)
          .eq('user_id', _userId);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  /// Replace the full ordered list of folders (by id).
  Future<void> reorderFolders(List<String> orderedFolderIds) async {
    try {
      // First, move all to temporary positions to avoid unique constraint conflicts
      for (var i = 0; i < orderedFolderIds.length; i++) {
        await supabase
            .from('chat_folders')
            .update({'position': i + 1000})
            .eq('id', orderedFolderIds[i])
            .eq('user_id', _userId);
      }
      // Then, set the final positions
      for (var i = 0; i < orderedFolderIds.length; i++) {
        await supabase
            .from('chat_folders')
            .update({'position': i})
            .eq('id', orderedFolderIds[i])
            .eq('user_id', _userId);
      }
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<void> addChatsToFolder({
    required String folderId,
    required List<String> chatIds,
  }) async {
    if (chatIds.isEmpty) return;
    try {
      await _assertOwnsFolder(folderId);
      await _insertFolderItems(folderId, chatIds);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<void> removeChatFromFolder({
    required String folderId,
    required String chatId,
  }) async {
    try {
      await _assertOwnsFolder(folderId);
      await supabase
          .from('user_chat_folders')
          .delete()
          .eq('folder_id', folderId)
          .eq('chat_id', chatId);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<void> removeChatsFromFolder({
    required String folderId,
    required List<String> chatIds,
  }) async {
    if (chatIds.isEmpty) return;
    try {
      await _assertOwnsFolder(folderId);
      await supabase
          .from('user_chat_folders')
          .delete()
          .eq('folder_id', folderId)
          .inFilter('chat_id', chatIds);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  /// Sets the exact chat membership of a folder (adds missing, removes extras).
  Future<void> setFolderChats({
    required String folderId,
    required List<String> chatIds,
  }) async {
    try {
      await _assertOwnsFolder(folderId);

      final current = await supabase
          .from('user_chat_folders')
          .select('chat_id')
          .eq('folder_id', folderId);

      final currentIds = (current as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>)['chat_id'] as String)
          .toSet();
      final nextIds = chatIds.toSet();

      final toAdd = nextIds.difference(currentIds).toList();
      final toRemove = currentIds.difference(nextIds).toList();

      if (toRemove.isNotEmpty) {
        await supabase
            .from('user_chat_folders')
            .delete()
            .eq('folder_id', folderId)
            .inFilter('chat_id', toRemove);
      }

      if (toAdd.isNotEmpty) {
        await _insertFolderItems(folderId, toAdd);
      }
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<void> _insertFolderItems(String folderId, List<String> chatIds) async {
    final unique = chatIds.toSet().toList();
    if (unique.isEmpty) return;

    final rows = unique
        .map((chatId) => {
              'folder_id': folderId,
              'chat_id': chatId,
              'user_id': _userId,
            })
        .toList();

    // ignoreDuplicates so re-adding existing chats is a no-op
    await supabase.from('user_chat_folders').upsert(
      rows,
      onConflict: 'folder_id,chat_id',
      ignoreDuplicates: true,
    );
  }

  Future<void> _assertOwnsFolder(String folderId) async {
    final row = await supabase
        .from('chat_folders')
        .select('id')
        .eq('id', folderId)
        .eq('user_id', _userId)
        .maybeSingle();

    if (row == null) {
      throw AppException(
        message: 'Folder not found',
        userMessage: 'Folder not found',
      );
    }
  }

  String _validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw AppException(
        message: 'Folder name empty',
        userMessage: 'Folder name cannot be empty',
      );
    }
    if (trimmed.length > maxNameLength) {
      throw AppException(
        message: 'Folder name too long',
        userMessage: 'Folder name can be at most $maxNameLength characters',
      );
    }
    return trimmed;
  }

  Timer? _pollTimer;

  void _startPolling(
    StreamController<List<ChatFolderModel>> controller,
    Future<void> Function() fetch,
  ) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (controller.isClosed) {
        _pollTimer?.cancel();
        return;
      }
      try {
        await fetch();
      } catch (_) {}
    });
  }
}
