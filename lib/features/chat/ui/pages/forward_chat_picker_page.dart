import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat/notifiers/ui/chat_ui_state.dart';
import 'package:telegram_clone/features/chat/ui/widgets/chat_avatar.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/main_ui_state.dart';

class ForwardChatPickerPage extends ConsumerStatefulWidget {
  const ForwardChatPickerPage({super.key});

  @override
  ConsumerState<ForwardChatPickerPage> createState() =>
      _ForwardChatPickerPageState();
}

class _ForwardChatPickerPageState extends ConsumerState<ForwardChatPickerPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(watchUserChatsQueryProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Forward to...'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(chatUi_forwardMessagesProvider.notifier).clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: chatsAsync.when(
              data: (chats) {
                final filteredChats = chats.where((chat) {
                  if (chat.chatType == ChatType.channel) return false;
                  if (_searchQuery.isNotEmpty) {
                    return chat.displayTitle.toLowerCase().contains(
                      _searchQuery,
                    );
                  }
                  return true;
                }).toList();

                if (filteredChats.isEmpty) {
                  return const Center(child: Text('No chats found'));
                }

                return ListView.separated(
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = filteredChats[index];
                    return _ChatPickerTile(
                      chat: chat,
                      onTap: () => _selectChat(chat),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
        ],
      ),
    );
  }

  void _selectChat(ChatListItemModel chat) {
    ref.read(chatUi_forwardChatInfoProvider.notifier).set(chat);
    ref.read(mainUi_selectedChatItemProviderProvider.notifier).set(chat);

    context.pushReplacementNamed(
      RouteNames.chat,
      pathParameters: {'chatId': chat.chatId},
      extra: chat,
    );
  }
}

class _ChatPickerTile extends StatelessWidget {
  final ChatListItemModel chat;
  final VoidCallback onTap;

  const _ChatPickerTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: ChatAvatar(chatInfo: chat, size: 46),
      title: Text(
        chat.displayTitle,
        style: const TextStyle(fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: chat.chatType != ChatType.private
          ? Text(
              chat.chatType.name[0].toUpperCase() +
                  chat.chatType.name.substring(1),
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
