import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/data/models/message_model.dart';
import 'package:telegram_clone/features/chat/notifiers/command/delete_messages_command.dart';
import 'package:telegram_clone/features/chat/notifiers/query/watch_messages_query.dart';
import 'package:telegram_clone/features/chat/notifiers/ui/chat_ui_state.dart';
import 'package:telegram_clone/features/chat/ui/widgets/chat_avatar.dart';
import 'package:telegram_clone/features/chat/ui/widgets/chat_profile_subtitle.dart';
import 'package:telegram_clone/features/chat/ui/widgets/show_date_search.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key, required this.chatInfo});

  final ChatListItemModel chatInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectionMode = ref.watch(chatUi_isSelectionModeProvider);

    return isSelectionMode
        ? SelectionAppBar(
            chatId: chatInfo.chatId,
            chatType: chatInfo.chatType,
            otherUserName: chatInfo.otherUserName,
          )
        : AppBar(
            titleSpacing: 0,
            leadingWidth: 40,
            title: Row(
              children: [
                ChatAvatar(chatInfo: chatInfo),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatInfo.displayTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      ChatProfileSubtitle(chatInfo: chatInfo),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search by date',
                onPressed: () => showDateSearch(context),
              ),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class SelectionAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SelectionAppBar({
    super.key,
    required this.chatId,
    required this.chatType,
    this.otherUserName,
  });

  final String chatId;
  final ChatType chatType;
  final String? otherUserName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCounts = ref.watch(chatUi_selectedMessagesProvider).length;
    final canEdit = ref.watch(chatUI_canEditMessageProvider);

    return AppBar(
      leading: IconButton(
        onPressed: () =>
            ref.read(chatUi_selectedMessagesProvider.notifier).clear(),
        icon: Icon(Icons.close),
      ),
      title: Text('$selectedCounts'),
      actions: [
        if (canEdit)
          IconButton(
            onPressed: () {
              final selectedMessageIds = ref.read(
                chatUi_selectedMessagesProvider,
              );
              if (selectedMessageIds.isEmpty) return;

              final selectedMessageId = selectedMessageIds.first;
              final messagesAsync = ref.read(
                watchMessagesQueryProvider(chatId),
              );
              final selectedMessage = messagesAsync.whenData((messages) {
                for (final msg in messages) {
                  if (msg.id == selectedMessageId) return msg;
                }
                return null;
              }).value;

              if (selectedMessage == null) return;

              ref
                  .read(chatUi_editingMessageProvider.notifier)
                  .set(selectedMessage);
              ref.read(chatUi_selectedMessagesProvider.notifier).clear();
            },
            icon: Icon(Icons.mode_edit_outlined),
          ),

        IconButton(
          onPressed: () {
            final selectedMessageIds = ref.read(
              chatUi_selectedMessagesProvider,
            );
            if (selectedMessageIds.isEmpty) return;

            final selectedMessageId = selectedMessageIds.first;
            final messagesAsync = ref.read(
              watchMessagesQueryProvider(chatId),
            );
            final selectedMessage = messagesAsync.whenData((messages) {
              for (final msg in messages) {
                if (msg.id == selectedMessageId) return msg;
              }
              return null;
            }).value;

            if (selectedMessage == null) return;

            ref
                .read(chatUi_replyingToProvider.notifier)
                .set(selectedMessage);
            ref.read(chatUi_selectedMessagesProvider.notifier).clear();
          },
          icon: Icon(Icons.reply),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.copy_outlined)),
        IconButton(
          onPressed: () {
            final selectedMessageIds = ref.read(
              chatUi_selectedMessagesProvider,
            );
            if (selectedMessageIds.isEmpty) return;

            final messagesAsync = ref.read(
              watchMessagesQueryProvider(chatId),
            );
            final selectedMessages = messagesAsync.whenData((messages) {
              final result = <MessageModel>[];
              for (final msg in messages) {
                if (selectedMessageIds.contains(msg.id)) result.add(msg);
              }
              return result;
            }).value;

            if (selectedMessages == null || selectedMessages.isEmpty) return;

            ref
                .read(chatUi_forwardMessagesProvider.notifier)
                .set(selectedMessages);
            ref.read(chatUi_selectedMessagesProvider.notifier).clear();

            context.pushNamed(RouteNames.forwardChatPicker);
          },
          icon: Icon(Icons.turn_right_outlined),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return _DeleteConfirmDialog(
                  chatId: chatId,
                  chatType: chatType,
                  selectedCounts: selectedCounts,
                  otherUserName: otherUserName,
                );
              },
            );
          },
          icon: Icon(Icons.delete),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _DeleteConfirmDialog extends ConsumerStatefulWidget {
  const _DeleteConfirmDialog({
    required this.chatId,
    required this.chatType,
    required this.selectedCounts,
    this.otherUserName,
  });

  final String chatId;
  final ChatType chatType;
  final int selectedCounts;
  final String? otherUserName;

  @override
  ConsumerState<_DeleteConfirmDialog> createState() =>
      _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends ConsumerState<_DeleteConfirmDialog> {
  bool _deleteForEveryone = false;

  bool get _isPrivateChat => widget.chatType == ChatType.private;

  @override
  Widget build(BuildContext context) {
    final title = widget.selectedCounts == 1
        ? 'Delete Message'
        : 'Delete ${widget.selectedCounts} Messages';

    final contentText = widget.selectedCounts == 1
        ? 'Are you sure you want to delete this message?'
        : 'Are you sure you want to delete these messages?';

    final otherName = widget.otherUserName ?? 'the other person';

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contentText),
          if (_isPrivateChat) ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() => _deleteForEveryone = !_deleteForEveryone);
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Checkbox(
                      value: _deleteForEveryone,
                      onChanged: (value) {
                        setState(() => _deleteForEveryone = value ?? false);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Also delete for $otherName',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Text(
              'This message will be deleted for everyone.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(chatUi_selectedMessagesProvider.notifier).clear();
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            ref.read(deleteMessagesCommandProvider.notifier).run(
              chatId: widget.chatId,
              chatType: widget.chatType,
              deleteForEveryone: _deleteForEveryone,
            );
            ref.read(chatUi_selectedMessagesProvider.notifier).clear();
            Navigator.of(context).pop();
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
