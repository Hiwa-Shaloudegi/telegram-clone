// lib/features/chat/ui/widgets/message_bubble.dart
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:telegram_clone/app/enums/send_status.dart';
import 'package:telegram_clone/data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool showSenderInfo;
  final VoidCallback onReply;
  final bool isDateSearchResult;
  final SendStatus sendStatus;

  const MessageBubble({
    super.key,
    required this.message,
    required this.showSenderInfo,
    required this.onReply,
    required this.sendStatus,
    this.isDateSearchResult = false,
  });

  @override
  Widget build(BuildContext context) {
    final isOwn = message.isOwnMessage;

    return Align(
      alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: GestureDetector(
          onLongPress: isDateSearchResult
              ? null
              : () => _showContextMenu(context),
          child: Padding(
            padding: EdgeInsets.only(
              left: isOwn ? 48 : 0,
              right: isOwn ? 0 : 48,
              bottom: 2,
              top: showSenderInfo ? 6 : 1,
            ),
            child: Column(
              crossAxisAlignment: isOwn
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (showSenderInfo && !isOwn)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 2),
                    child: Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _senderColor(message.senderId),
                      ),
                    ),
                  ),
                _BubbleContainer(
                  isOwn: isOwn,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Forwarded
                      if (message.isForwarded)
                        _ForwardedHeader(message: message),

                      // Reply
                      if (message.replyToMessageId != null)
                        _ReplyPreviewInBubble(message: message, isOwn: isOwn),

                      // Content
                      _MessageContent(message: message),

                      // Timestamp
                      _Timestamp(
                        message: message,
                        isOwn: isOwn,
                        sendStatus: sendStatus,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _senderColor(String senderId) {
    const colors = [
      Color(0xFFE53935),
      Color(0xFF8E24AA),
      Color(0xFF1E88E5),
      Color(0xFF00897B),
      Color(0xFF43A047),
      Color(0xFFEF6C00),
      Color(0xFF6D4C41),
    ];
    final hash = senderId.codeUnits.fold(0, (a, b) => a + b);
    return colors[hash % colors.length];
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                onReply();
              },
            ),
            if (message.messageType == 'text')
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: message.content));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Copied')));
                },
              ),
            if (message.isOwnMessage)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // deletion handled via messagesApi in caller
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Bubble container shape
// ─────────────────────────────────────────────────────────────

class _BubbleContainer extends StatelessWidget {
  final bool isOwn;
  final Widget child;

  const _BubbleContainer({required this.isOwn, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = isOwn
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
        bottomLeft: isOwn
            ? const Radius.circular(18)
            : const Radius.circular(4),
        bottomRight: isOwn
            ? const Radius.circular(4)
            : const Radius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Forwarded header
// ─────────────────────────────────────────────────────────────

class _ForwardedHeader extends StatelessWidget {
  final MessageModel message;
  const _ForwardedHeader({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.forward,
            size: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            'Forwarded${message.forwardedFromTitle != null ? ' from ${message.forwardedFromTitle}' : ''}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Reply preview inside bubble
// ─────────────────────────────────────────────────────────────

class _ReplyPreviewInBubble extends StatelessWidget {
  final MessageModel message;
  final bool isOwn;
  const _ReplyPreviewInBubble({required this.message, required this.isOwn});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isOwn
            ? colorScheme.primary.withOpacity(0.15)
            : colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: colorScheme.primary, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.replyToSenderName != null)
            Text(
              message.replyToSenderName!,
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          if (message.replyToContent != null)
            Text(
              message.replyToContent!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Message content — switches on type
// ─────────────────────────────────────────────────────────────

class _MessageContent extends StatelessWidget {
  final MessageModel message;
  const _MessageContent({required this.message});

  @override
  Widget build(BuildContext context) {
    switch (message.messageType) {
      case 'image':
        return _ImageContent(message: message);
      case 'video':
        return _VideoContent(message: message);
      case 'audio':
        return _AudioContent(message: message);
      case 'file':
        return _FileContent(message: message);
      default:
        return _TextContent(message: message);
    }
  }
}

class _TextContent extends StatelessWidget {
  final MessageModel message;
  const _TextContent({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message.content,
      style: TextStyle(
        fontSize: 15,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.35,
      ),
    );
  }
}

class _ImageContent extends StatelessWidget {
  final MessageModel message;
  const _ImageContent({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.mediaUrl == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        message.mediaUrl!,
        width: 220,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : SizedBox(
                width: 220,
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
        errorBuilder: (_, __, ___) => Container(
          width: 220,
          height: 120,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 48),
        ),
      ),
    );
  }
}

class _VideoContent extends StatelessWidget {
  final MessageModel message;
  const _VideoContent({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
      ),
    );
  }
}

class _AudioContent extends StatelessWidget {
  final MessageModel message;
  const _AudioContent({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Waveform placeholder
            Row(
              children: List.generate(
                20,
                (i) => Container(
                  width: 3,
                  height: 4 + (i % 5) * 4.0,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Voice message',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FileContent extends StatelessWidget {
  final MessageModel message;
  const _FileContent({required this.message});

  @override
  Widget build(BuildContext context) {
    final fileName = message.mediaUrl?.split('/').last ?? 'File';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.insert_drive_file_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Tap to download',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Timestamp + read tick
// ─────────────────────────────────────────────────────────────

class _Timestamp extends StatelessWidget {
  final MessageModel message;
  final bool isOwn;
  final SendStatus sendStatus;

  const _Timestamp({
    required this.message,
    required this.isOwn,
    required this.sendStatus,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(message.createdAt.toLocal());
    final subtleColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(timeStr, style: TextStyle(fontSize: 11, color: subtleColor)),
          if (isOwn) ...[
            const SizedBox(width: 4),
            sendStatus == SendStatus.sent
                ? Icon(Icons.done, size: 14, color: subtleColor)
                : sendStatus == SendStatus.read
                ? Icon(Icons.done_all, size: 14, color: subtleColor)
                : Icon(Icons.error, size: 14, color: subtleColor),
          ],
        ],
      ),
    );
  }
}
