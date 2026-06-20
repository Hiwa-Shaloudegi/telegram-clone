import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
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
        ? SelectionAppBar()
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
  const SelectionAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCounts = ref.watch(chatUi_selectedMessagesProvider).length;

    return AppBar(
      leading: IconButton(
        onPressed: () =>
            ref.read(chatUi_selectedMessagesProvider.notifier).clear(),
        icon: Icon(Icons.close),
      ),
      title: Text('$selectedCounts'),
      actions: [
        if (selectedCounts == 1)
          IconButton(onPressed: () {}, icon: Icon(Icons.mode_edit_outlined)),

        IconButton(onPressed: () {}, icon: Icon(Icons.copy_outlined)),
        IconButton(onPressed: () {}, icon: Icon(Icons.turn_right_outlined)),
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
                        // ref.read(deleteMessagesCommandProvider.notifier).run();
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
