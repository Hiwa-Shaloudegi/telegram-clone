// lib/features/chat/ui/pages/chat_page.dart
// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/data/models/message_model.dart';
import 'package:telegram_clone/features/chat/notifiers/command/send_message_command.dart';
import 'package:telegram_clone/features/chat/notifiers/query/messages_by_date_query.dart';
import 'package:telegram_clone/features/chat/notifiers/query/watch_messages_query.dart';
import 'package:telegram_clone/features/chat/ui/widgets/date_divider.dart';
import 'package:telegram_clone/features/chat/ui/widgets/message_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  final ChatListItemModel chatInfo;

  const ChatPage({super.key, required this.chatInfo});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocus = FocusNode();
  final AudioRecorder _recorder = AudioRecorder();

  MessageModel? _replyingTo;
  bool _isRecording = false;
  String? _recordingPath;

  // ── For pagination ──────────────────────────────────────────
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
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final messages = ref
        .read(watchMessagesQueryProvider(widget.chatInfo.chatId))
        .value;
    if (messages == null || messages.isEmpty) return;

    setState(() => _isLoadingMore = true);
    final oldest = messages.last;
    await ref
        .read(messagesApiProvider)
        .loadMoreMessages(
          chatId: widget.chatInfo.chatId,
          beforeMessageId: oldest.id,
        );
    if (mounted) setState(() => _isLoadingMore = false);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _inputFocus.dispose();
    _recorder.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final chatInfo = widget.chatInfo;
    final messagesState = ref.watch(
      watchMessagesQueryProvider(chatInfo.chatId),
    );

    ref.listen<AsyncValue<void>>(sendMessageCommandProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => AppSnackbar.showError(context, e.toString()),
      );
    });

    return Scaffold(
      appBar: _buildAppBar(context, chatInfo),
      body: Column(
        children: [
          // ── Messages list ──
          Expanded(
            child: messagesState.when(
              data: (messages) => _MessagesList(
                chatId: chatInfo.chatId,
                messages: messages,
                scrollController: _scrollController,
                isLoadingMore: _isLoadingMore,
                onReply: (msg) => setState(() => _replyingTo = msg),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),

          // ── Reply preview ──
          if (_replyingTo != null)
            _ReplyPreview(
              message: _replyingTo!,
              onCancel: () => setState(() => _replyingTo = null),
            ),

          // ── Input bar ──
          _InputBar(
            controller: _textController,
            focusNode: _inputFocus,
            isRecording: _isRecording,
            onSendText: _sendText,
            onAttach: _showAttachMenu,
            onRecordStart: _startRecording,
            onRecordStop: _stopRecording,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // AppBar
  // ─────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ChatListItemModel chatInfo,
  ) {
    return AppBar(
      titleSpacing: 0,
      leadingWidth: 40,
      title: Row(
        children: [
          _buildAvatar(chatInfo),
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
                _buildSubtitle(chatInfo),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search by date',
          onPressed: () => _showDateSearch(context),
        ),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  Widget _buildAvatar(ChatListItemModel chatInfo) {
    final bg = _colorFromName(chatInfo.displayTitle);
    if (chatInfo.avatarUrl != null) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(chatInfo.avatarUrl!),
        backgroundColor: bg,
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: bg,
      child: Text(
        chatInfo.avatarInitials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubtitle(ChatListItemModel chatInfo) {
    switch (chatInfo.chatType) {
      case 'channel':
        return Text(
          'Channel',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      case 'group':
        return Text(
          'Group',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      case 'saved':
        return Text(
          'Your saved messages',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Color _colorFromName(String name) {
    final colors = [
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.brown,
    ];
    final hash = name.codeUnits.fold(0, (a, b) => a + b);
    return colors[hash % colors.length];
  }

  // ─────────────────────────────────────────────────────────────
  // Send text
  // ─────────────────────────────────────────────────────────────

  Future<void> _sendText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    final replyId = _replyingTo?.id;
    setState(() => _replyingTo = null);

    await ref
        .read(sendMessageCommandProvider.notifier)
        .sendText(
          chatId: widget.chatInfo.chatId,
          content: text,
          replyToMessageId: replyId,
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

  // ─────────────────────────────────────────────────────────────
  // Attach menu
  // ─────────────────────────────────────────────────────────────

  void _showAttachMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AttachMenu(
        onPickImage: () => _pickMedia(ImageSource.gallery, 'image'),
        onPickVideo: () => _pickMedia(ImageSource.gallery, 'video'),
        onPickFile: _pickFile,
        onTakePhoto: () => _pickMedia(ImageSource.camera, 'image'),
      ),
    );
  }

  Future<void> _pickMedia(ImageSource source, String type) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final XFile? file = type == 'image'
        ? await picker.pickImage(source: source, imageQuality: 80)
        : await picker.pickVideo(source: source);
    if (file == null) return;

    await ref
        .read(sendMessageCommandProvider.notifier)
        .sendMedia(
          chatId: widget.chatInfo.chatId,
          file: File(file.path),
          messageType: type,
          replyToMessageId: _replyingTo?.id,
        );
    setState(() => _replyingTo = null);
  }

  Future<void> _pickFile() async {
    Navigator.pop(context);
    final result = await FilePicker.pickFiles();
    if (result == null || result.files.single.path == null) return;

    await ref
        .read(sendMessageCommandProvider.notifier)
        .sendMedia(
          chatId: widget.chatInfo.chatId,
          file: File(result.files.single.path!),
          messageType: 'file',
          replyToMessageId: _replyingTo?.id,
        );
    setState(() => _replyingTo = null);
  }

  // ─────────────────────────────────────────────────────────────
  // Voice recording
  // ─────────────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) return;
    final path =
        '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );
    setState(() {
      _isRecording = true;
      _recordingPath = path;
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    setState(() => _isRecording = false);
    if (path == null) return;

    await ref
        .read(sendMessageCommandProvider.notifier)
        .sendMedia(
          chatId: widget.chatInfo.chatId,
          file: File(path),
          messageType: 'audio',
          replyToMessageId: _replyingTo?.id,
        );
    setState(() => _replyingTo = null);
  }

  // ─────────────────────────────────────────────────────────────
  // Date search
  // ─────────────────────────────────────────────────────────────

  Future<void> _showDateSearch(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked == null || !mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DateSearchPage(
          chatId: widget.chatInfo.chatId,
          chatTitle: widget.chatInfo.displayTitle,
          date: picked,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Messages list (reversed so newest is at bottom, oldest loads up)
// ─────────────────────────────────────────────────────────────

class _MessagesList extends StatelessWidget {
  final String chatId;
  final List<MessageModel> messages;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final void Function(MessageModel) onReply;

  const _MessagesList({
    required this.chatId,
    required this.messages,
    required this.scrollController,
    required this.isLoadingMore,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(child: Text('No messages yet. Say hi! 👋'));
    }

    // Group messages by date so we can insert date dividers
    return ListView.builder(
      controller: scrollController,
      reverse: true, // newest at bottom
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: messages.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (isLoadingMore && index == messages.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final msg = messages[index];

        // Determine if a date divider is needed
        final bool showDateDivider;
        if (index == messages.length - 1) {
          showDateDivider = true;
        } else {
          final next =
              messages[index + 1]; // older message (higher index in reversed)
          showDateDivider = !_sameDay(msg.createdAt, next.createdAt);
        }

        // Should the avatar/sender name be shown?
        final bool showSenderInfo;
        if (index == 0) {
          showSenderInfo = true;
        } else {
          final prev = messages[index - 1]; // newer message
          showSenderInfo =
              prev.senderId != msg.senderId ||
              msg.createdAt.difference(prev.createdAt).abs() >
                  const Duration(minutes: 5);
        }

        return Column(
          children: [
            if (showDateDivider) DateDivider(date: msg.createdAt),
            MessageBubble(
              message: msg,
              showSenderInfo: showSenderInfo,
              onReply: () => onReply(msg),
            ),
          ],
        );
      },
    );
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// ─────────────────────────────────────────────────────────────
// Reply preview banner above input
// ─────────────────────────────────────────────────────────────

class _ReplyPreview extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onCancel;

  const _ReplyPreview({required this.message, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.senderName,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  message.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Input bar
// ─────────────────────────────────────────────────────────────

class _InputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isRecording;
  final VoidCallback onSendText;
  final void Function(BuildContext) onAttach;
  final VoidCallback onRecordStart;
  final VoidCallback onRecordStop;

  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.isRecording,
    required this.onSendText,
    required this.onAttach,
    required this.onRecordStart,
    required this.onRecordStop,
  });

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final hasText = widget.controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Attach
            IconButton(
              icon: Icon(
                Icons.attach_file,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: () => widget.onAttach(context),
            ),

            // Text field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 160),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Message',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (_) => widget.onSendText(),
                      ),
                    ),
                    // Emoji button
                    IconButton(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {},
                      padding: const EdgeInsets.only(right: 4, bottom: 4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 6),

            // Send / mic button
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _hasText
                  ? _SendButton(
                      key: const ValueKey('send'),
                      onTap: widget.onSendText,
                    )
                  : widget.isRecording
                  ? _RecordingButton(
                      key: const ValueKey('recording'),
                      onStop: widget.onRecordStop,
                    )
                  : _MicButton(
                      key: const ValueKey('mic'),
                      onStart: widget.onRecordStart,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SendButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'send_fab',
      onPressed: onTap,
      elevation: 0,
      child: const Icon(Icons.send_rounded),
    );
  }
}

class _MicButton extends StatelessWidget {
  final VoidCallback onStart;
  const _MicButton({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'mic_fab',
      onPressed: onStart,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      child: const Icon(Icons.mic_outlined),
    );
  }
}

class _RecordingButton extends StatelessWidget {
  final VoidCallback onStop;
  const _RecordingButton({super.key, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'stop_fab',
      onPressed: onStop,
      elevation: 0,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      child: const Icon(Icons.stop_rounded),
    );
  }
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
                    onReply: () {},
                    isDateSearchResult: true,
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
