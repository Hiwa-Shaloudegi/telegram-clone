// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatUi_replyingTo)
final chatUi_replyingToProvider = ChatUi_replyingToProvider._();

final class ChatUi_replyingToProvider
    extends $NotifierProvider<ChatUi_replyingTo, MessageModel?> {
  ChatUi_replyingToProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_replyingToProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_replyingToHash();

  @$internal
  @override
  ChatUi_replyingTo create() => ChatUi_replyingTo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessageModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessageModel?>(value),
    );
  }
}

String _$chatUi_replyingToHash() => r'e880def85d8d0c21b22001a94fdbb9b191d96665';

abstract class _$ChatUi_replyingTo extends $Notifier<MessageModel?> {
  MessageModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MessageModel?, MessageModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MessageModel?, MessageModel?>,
              MessageModel?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatUi_isRecording)
final chatUi_isRecordingProvider = ChatUi_isRecordingProvider._();

final class ChatUi_isRecordingProvider
    extends $NotifierProvider<ChatUi_isRecording, bool> {
  ChatUi_isRecordingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_isRecordingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_isRecordingHash();

  @$internal
  @override
  ChatUi_isRecording create() => ChatUi_isRecording();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatUi_isRecordingHash() =>
    r'f1b29dc4ecbf9a845db9299763ce8091102b870e';

abstract class _$ChatUi_isRecording extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatUi_recordingPath)
final chatUi_recordingPathProvider = ChatUi_recordingPathProvider._();

final class ChatUi_recordingPathProvider
    extends $NotifierProvider<ChatUi_recordingPath, String?> {
  ChatUi_recordingPathProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_recordingPathProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_recordingPathHash();

  @$internal
  @override
  ChatUi_recordingPath create() => ChatUi_recordingPath();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$chatUi_recordingPathHash() =>
    r'ef12777e5b76d6441f5449222e51f33e0e3c8f02';

abstract class _$ChatUi_recordingPath extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatUi_hasText)
final chatUi_hasTextProvider = ChatUi_hasTextProvider._();

final class ChatUi_hasTextProvider
    extends $NotifierProvider<ChatUi_hasText, bool> {
  ChatUi_hasTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_hasTextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_hasTextHash();

  @$internal
  @override
  ChatUi_hasText create() => ChatUi_hasText();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatUi_hasTextHash() => r'dfd98966f378883b677c30712f43a004c0f9648d';

abstract class _$ChatUi_hasText extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
