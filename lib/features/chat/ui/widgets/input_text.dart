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
      // padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      padding: const EdgeInsets.only(top: 6),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 160),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      // borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          onPressed: () => widget.onAttach(context),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: widget.controller,
                            focusNode: widget.focusNode,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Message',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                            ),
                            onSubmitted: (_) => widget.onSendText(),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // Floating send / mic button overlapping right
                  Positioned(
                    right: 6,
                    child: Consumer(
                      builder: (_, ref, __) {
                        final hasText = ref.watch(chatUi_hasTextProvider);
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: hasText
                              ? SendButton(onTap: widget.onSendText)
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
