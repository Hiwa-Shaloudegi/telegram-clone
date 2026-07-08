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
        ? SelectionAppBar(chatId: chatInfo.chatId, chatType: chatInfo.chatType)
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
  const SelectionAppBar({super.key, required this.chatId, required this.chatType});

  final String chatId;
  final ChatType chatType;

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
            // ref.read(deleteMessagesCommandProvider.notifier).run();
            // show confirmation dialog before deleting
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: selectedCounts == 1
                      ? Text('Delete Message')
                      : Text('Delete $selectedCounts Messages'),
                  content: selectedCounts == 1
                      ? Text('Are you sure you want to delete this message?')
                      : Text('Are you sure you want to delete these messages?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        ref
                            .read(chatUi_selectedMessagesProvider.notifier)
                            .clear();
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(deleteMessagesCommandProvider.notifier)
                            .run(
                              chatId: chatId,
                              chatType: chatType,
                            );
                        ref
                            .read(chatUi_selectedMessagesProvider.notifier)
                            .clear();
                        Navigator.of(context).pop();
                      },
                      child: Text('Delete'),
                    ),
                  ],
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
