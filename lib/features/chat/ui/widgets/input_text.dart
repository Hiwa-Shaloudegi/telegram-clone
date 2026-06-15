import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/features/chat/notifiers/ui/chat_ui_state.dart';
import 'package:telegram_clone/features/chat/ui/widgets/mic_button.dart';
import 'package:telegram_clone/features/chat/ui/widgets/recording_button.dart';
import 'package:telegram_clone/features/chat/ui/widgets/send_button.dart';

class InputBar extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isRecording;
  final VoidCallback onSendText;
  final void Function(BuildContext) onAttach;
  final VoidCallback onRecordStart;
  final VoidCallback onRecordStop;

  const InputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isRecording,
    required this.onSendText,
    required this.onAttach,
    required this.onRecordStart,
    required this.onRecordStop,
  });

  @override
  ConsumerState<InputBar> createState() => _InputBarState();
}

class _InputBarState extends ConsumerState<InputBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final hasText = widget.controller.text.trim().isNotEmpty;
      ref.read(chatUi_hasTextProvider.notifier).set(hasText);
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
            Consumer(
              builder: (_, ref, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: ref.watch(chatUi_hasTextProvider)
                      ? SendButton(
                          key: const ValueKey('send'),
                          onTap: widget.onSendText,
                        )
                      : widget.isRecording
                      ? RecordingButton(
                          key: const ValueKey('recording'),
                          onStop: widget.onRecordStop,
                        )
                      : MicButton(
                          key: const ValueKey('mic'),
                          onStart: widget.onRecordStart,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
