import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/data/models/message_model.dart';
import 'package:telegram_clone/features/chat/notifiers/command/edit_message_command.dart';
import 'package:telegram_clone/features/chat/notifiers/command/send_message_command.dart';
import 'package:telegram_clone/features/chat/notifiers/query/messages_by_date_query.dart';
import 'package:telegram_clone/features/chat/notifiers/query/watch_messages_query.dart';
import 'package:telegram_clone/features/chat/notifiers/ui/chat_ui_state.dart';
import 'package:telegram_clone/features/chat/ui/widgets/chat_app_bar.dart';
import 'package:telegram_clone/features/chat/ui/widgets/chat_message_list.dart';
import 'package:telegram_clone/features/chat/ui/widgets/input_text.dart';
import 'package:telegram_clone/features/chat/ui/widgets/message_bubble.dart';
import 'package:telegram_clone/features/chat/ui/widgets/reply_preview.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/main_ui_state.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocus = FocusNode();
  // TODO: Refactor
  final AudioRecorder _recorder = AudioRecorder();
  // TODO: Refactor
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Load more when near the top (messages list is newest-first, so
    // oldest messages are at the bottom of the reversed ListView)
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingMore) {
      // _loadMore();
    }
  }

  // Future<void> _loadMore() async {
  //   final messages = ref
  //       .read(watchMessagesQueryProvider(widget.chatInfo.chatId))
  //       .value;
  //   if (messages == null || messages.isEmpty) return;

  //   setState(() => _isLoadingMore = true);
  //   final oldest = messages.last;
  //   await ref
  //       .read(messagesApiProvider)
  //       .loadMoreMessages(
  //         chatId: widget.chatInfo.chatId,
  //         beforeMessageId: oldest.id,
  //       );
  //   if (mounted) setState(() => _isLoadingMore = false);
  // }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _inputFocus.dispose();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MessageModel? replyingTo = ref.watch(chatUi_replyingToProvider);
    MessageModel? editingMessage = ref.watch(chatUi_editingMessageProvider);
    // when editing is started elsewhere (app bar), populate input
    ref.listen<MessageModel?>(chatUi_editingMessageProvider, (prev, next) {
      if (next != null) {
        _textController.text = next.content;
        _inputFocus.requestFocus();
      }
    });
    bool isRecording = ref.watch(chatUi_isRecordingProvider);

    final chatId = GoRouterState.of(context).pathParameters['chatId']!;

    // Try to get chat info from the selected provider first, then from the
    // chat list stream, and finally fall back to a minimal object.
    final selectedChat = ref.watch(mainUi_selectedChatItemProviderProvider);
    final chatsAsync = ref.watch(watchUserChatsQueryProvider);
    final ChatListItemModel chatInfo = selectedChat ??
        chatsAsync.whenData((chats) {
          for (final c in chats) {
            if (c.chatId == chatId) return c;
          }
          return null;
        }).value ??
        ChatListItemModel(
          chatId: chatId,
          chatType: ChatType.private,
          isPublic: false,
          updatedAt: DateTime.now(),
          memberRole: 'member',
          isPinned: false,
          isArchived: false,
          isMuted: false,
          unreadCount: 0,
        );

    final messagesState = ref.watch(
      watchMessagesQueryProvider(chatInfo.chatId),
    );

    // Sync the selected chat provider so child widgets can access it.
    ref.listen(mainUi_selectedChatItemProviderProvider, (prev, next) {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainUi_selectedChatItemProviderProvider.notifier).set(chatInfo);
    });

    return Scaffold(
      appBar: ChatAppBar(chatInfo: chatInfo),
      body: Column(
        children: [
          Expanded(
            child: messagesState.when(
              data: (messages) => ChatMessagesList(
                chatId: chatInfo.chatId,
                messages: messages,
                scrollController: _scrollController,
                isLoadingMore: _isLoadingMore,
                onReply: (msg) =>
                    ref.read(chatUi_replyingToProvider.notifier).set(msg),
                onDelete: (msg) => _deleteMessage(chatInfo.chatId, msg),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),

          if (replyingTo != null)
            ReplyPreview(
              message: replyingTo,
              onCancel: () =>
                  ref.read(chatUi_replyingToProvider.notifier).set(null),
            ),

          InputBar(
            controller: _textController,
            focusNode: _inputFocus,
            isRecording: isRecording,
            onSendText: _sendText,
            onAttach: _showAttachMenu,
            onRecordStart: () {},
            onRecordStop: () {},
          ),
        ],
      ),
    );
  }

  // TODO: Organize functions
  Future<void> _sendText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final chatId = GoRouterState.of(context).pathParameters['chatId']!;

    // If editing an existing message, call edit command
    final editing = ref.read(chatUi_editingMessageProvider);
    if (editing != null) {
      _textController.clear();
      ref.read(chatUi_editingMessageProvider.notifier).set(null);

      await ref
          .read(editMessageCommandProvider(editing.id).notifier)
          .editText(
            chatId: chatId,
            messageId: editing.id,
            newContent: text,
          );

      return;
    }

    _textController.clear();

    MessageModel? replyingTo = ref.read(chatUi_replyingToProvider);
    ref.read(chatUi_replyingToProvider.notifier).set(null);

    final messageTempId = 'temp_${Uuid().v4()}';

    await ref
        .read(sendMessageCommandProvider(messageTempId).notifier)
        .sendText(
          chatId: chatId,
          content: text,
          replyingToMessage: replyingTo,
        );

    // Scroll to bottom (newest)
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _deleteMessage(String chatId, MessageModel msg) async {
    ref.read(watchMessagesQueryProvider(chatId).notifier).removeMessage(msg.id);
    await ref.read(messagesApiProvider).deleteMessage(msg.id);
  }

  void _showAttachMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AttachMenu(
        onPickImage: () {}, // _pickMedia(ImageSource.gallery, 'image'),
        onPickVideo: () {}, // _pickMedia(ImageSource.gallery, 'video'),
        onPickFile: () {}, //_pickFile,
        onTakePhoto: () {}, // _pickMedia(ImageSource.camera, 'image'),
      ),
    );
  }

  // Future<void> _pickMedia(ImageSource source, String type) async {
  //   MessageModel? replyingTo = ref.watch(chatUi_replyingToProvider);

  //   Navigator.pop(context);
  //   final picker = ImagePicker();
  //   final XFile? file = type == 'image'
  //       ? await picker.pickImage(source: source, imageQuality: 80)
  //       : await picker.pickVideo(source: source);
  //   if (file == null) return;

  //   await ref
  //       .read(sendMessageCommandProvider.notifier)
  //       .sendMedia(
  //         chatId: widget.chatInfo.chatId,
  //         file: File(file.path),
  //         messageType: type,
  //         replyToMessageId: replyingTo?.id,
  //       );
  //   ref.read(chatUi_replyingToProvider.notifier).set(null);
  // }

  // Future<void> _pickFile() async {
  //   MessageModel? replyingTo = ref.watch(chatUi_replyingToProvider);

  //   Navigator.pop(context);
  //   final result = await FilePicker.pickFiles();
  //   if (result == null || result.files.single.path == null) return;

  //   await ref
  //       .read(sendMessageCommandProvider.notifier)
  //       .sendMedia(
  //         chatId: widget.chatInfo.chatId,
  //         file: File(result.files.single.path!),
  //         messageType: 'file',
  //         replyToMessageId: replyingTo?.id,
  //       );
  //   ref.read(chatUi_replyingToProvider.notifier).set(null);
  // }

  // Future<void> _startRecording() async {
  //   if (!await _recorder.hasPermission()) return;
  //   final path =
  //       '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
  //   await _recorder.start(
  //     const RecordConfig(encoder: AudioEncoder.aacLc),
  //     path: path,
  //   );

  //   ref.read(chatUi_isRecordingProvider.notifier).set(true);
  //   ref.read(chatUi_recordingPathProvider.notifier).set(path);
  // }

  // Future<void> _stopRecording() async {
  //   MessageModel? replyingTo = ref.watch(chatUi_replyingToProvider);

  //   final path = await _recorder.stop();
  //   ref.read(chatUi_isRecordingProvider.notifier).set(false);

  //   if (path == null) return;

  //   await ref
  //       .read(sendMessageCommandProvider.notifier)
  //       .sendMedia(
  //         chatId: widget.chatInfo.chatId,
  //         file: File(path),
  //         messageType: 'audio',
  //         replyToMessageId: replyingTo?.id,
  //       );
  //   ref.read(chatUi_replyingToProvider.notifier).set(null);
  // }
}

// ─────────────────────────────────────────────────────────────
// Attach menu bottom sheet
// ─────────────────────────────────────────────────────────────

class _AttachMenu extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;
  final VoidCallback onPickFile;
  final VoidCallback onTakePhoto;

  const _AttachMenu({
    required this.onPickImage,
    required this.onPickVideo,
    required this.onPickFile,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AttachItem(
            icon: Icons.image_outlined,
            label: 'Gallery',
            color: Colors.purple,
            onTap: onPickImage,
          ),
          _AttachItem(
            icon: Icons.videocam_outlined,
            label: 'Video',
            color: Colors.red,
            onTap: onPickVideo,
          ),
          _AttachItem(
            icon: Icons.camera_alt_outlined,
            label: 'Camera',
            color: Colors.orange,
            onTap: onTakePhoto,
          ),
          _AttachItem(
            icon: Icons.attach_file_outlined,
            label: 'File',
            color: Colors.blue,
            onTap: onPickFile,
          ),
        ],
      ),
    );
  }
}

class _AttachItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Date Search Page
// ─────────────────────────────────────────────────────────────

class DateSearchPage extends ConsumerWidget {
  final String chatId;
  final String chatTitle;
  final DateTime date;

  const DateSearchPage({
    super.key,
    required this.chatId,
    required this.chatTitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // trigger search on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(messagesByDateQueryProvider.notifier)
          .search(chatId: chatId, date: date);
    });

    final state = ref.watch(messagesByDateQueryProvider);
    final fmt = DateFormat('MMMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              fmt.format(date),
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked == null) return;
              ref
                  .read(messagesByDateQueryProvider.notifier)
                  .search(chatId: chatId, date: picked);
            },
          ),
        ],
      ),
      body: state.when(
        data: (messages) => messages.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No messages on ${fmt.format(date)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    message: messages[index],
                    showSenderInfo: true,
                    // isDateSearchResult: true,

                    // TODO:
                    // sendStatus: SendStatus.read,
                    onReply: () {},
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
