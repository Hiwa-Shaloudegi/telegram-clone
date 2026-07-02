import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/app/router/extra/pending_dm_extra.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat/notifiers/command/send_first_dm_message_command.dart';
import 'package:telegram_clone/features/chat/ui/widgets/chat_avatar.dart';
import 'package:telegram_clone/features/chat/ui/widgets/input_text.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/main_ui_state.dart';

class PendingDmPage extends ConsumerStatefulWidget {
  final String otherUserId;
  final PendingDmExtra extra;

  const PendingDmPage({
    super.key,
    required this.otherUserId,
    required this.extra,
  });

  @override
  ConsumerState<PendingDmPage> createState() => _PendingDmPageState();
}

class _PendingDmPageState extends ConsumerState<PendingDmPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _inputFocus = FocusNode();
  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  Future<void> _sendText() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;

    _textController.clear();
    setState(() => _isSending = true);

    final chatId = await ref
        .read(sendFirstDmMessageCommandProvider.notifier)
        .run(
          otherUserId: widget.otherUserId,
          content: text,
        );

    if (!mounted) return;

    if (chatId != null) {
      final chatInfo = ChatListItemModel(
        chatId: chatId,
        chatType: ChatType.private,
        isPublic: false,
        updatedAt: DateTime.now(),
        memberRole: 'member',
        isPinned: false,
        isArchived: false,
        isMuted: false,
        unreadCount: 0,
        otherUserId: widget.otherUserId,
        otherUserName: widget.extra.displayName,
        otherUserImage: widget.extra.profileImageUrl,
      );
      ref.read(mainUi_selectedChatItemProviderProvider.notifier).set(chatInfo);

      context.pushReplacementNamed(
        RouteNames.chat,
        pathParameters: {'chatId': chatId},
      );
    } else {
      setState(() => _isSending = false);
    }
  }

  void _showAttachMenu(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final chatInfo = ChatListItemModel(
      chatId: 'pending_${widget.otherUserId}',
      chatType: ChatType.private,
      isPublic: false,
      updatedAt: DateTime.now(),
      memberRole: 'member',
      isPinned: false,
      isArchived: false,
      isMuted: false,
      unreadCount: 0,
      otherUserId: widget.otherUserId,
      otherUserName: widget.extra.displayName,
      otherUserImage: widget.extra.profileImageUrl,
    );

    return Scaffold(
      appBar: AppBar(
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
                    widget.extra.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.extra.isOnline
                        ? 'online'
                        : 'last seen recently',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _isSending
                  ? const CircularProgressIndicator()
                  : const Text('No messages yet. Say hi! 👋'),
            ),
          ),
          InputBar(
            controller: _textController,
            focusNode: _inputFocus,
            isRecording: false,
            onSendText: _sendText,
            onAttach: _showAttachMenu,
            onRecordStart: () {},
            onRecordStop: () {},
          ),
        ],
      ),
    );
  }
}
