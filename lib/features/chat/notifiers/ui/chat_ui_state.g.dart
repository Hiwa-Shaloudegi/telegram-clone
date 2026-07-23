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

@ProviderFor(ChatUi_selectedMessages)
final chatUi_selectedMessagesProvider = ChatUi_selectedMessagesProvider._();

final class ChatUi_selectedMessagesProvider
    extends $NotifierProvider<ChatUi_selectedMessages, HashSet<String>> {
  ChatUi_selectedMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_selectedMessagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_selectedMessagesHash();

  @$internal
  @override
  ChatUi_selectedMessages create() => ChatUi_selectedMessages();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HashSet<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HashSet<String>>(value),
    );
  }
}

String _$chatUi_selectedMessagesHash() =>
    r'f9827b6fe2d8664628ffa3ff250ec41ce86e483e';

abstract class _$ChatUi_selectedMessages extends $Notifier<HashSet<String>> {
  HashSet<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HashSet<String>, HashSet<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HashSet<String>, HashSet<String>>,
              HashSet<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatUi_isSelectionMode)
final chatUi_isSelectionModeProvider = ChatUi_isSelectionModeProvider._();

final class ChatUi_isSelectionModeProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ChatUi_isSelectionModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_isSelectionModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_isSelectionModeHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return ChatUi_isSelectionMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatUi_isSelectionModeHash() =>
    r'b2991e8a8b7e3d675a13dab30f99fc4c866009d2';

@ProviderFor(ChatUI_canEditMessage)
final chatUI_canEditMessageProvider = ChatUI_canEditMessageProvider._();

final class ChatUI_canEditMessageProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ChatUI_canEditMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUI_canEditMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUI_canEditMessageHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return ChatUI_canEditMessage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatUI_canEditMessageHash() =>
    r'ee1c265fe2637096f1d8466510b361762eeeedcb';

@ProviderFor(ChatUi_editingMessage)
final chatUi_editingMessageProvider = ChatUi_editingMessageProvider._();

final class ChatUi_editingMessageProvider
    extends $NotifierProvider<ChatUi_editingMessage, MessageModel?> {
  ChatUi_editingMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_editingMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_editingMessageHash();

  @$internal
  @override
  ChatUi_editingMessage create() => ChatUi_editingMessage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessageModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessageModel?>(value),
    );
  }
}

String _$chatUi_editingMessageHash() =>
    r'67fdae3a4c68dad5d303c8bb7db89999feb11244';

abstract class _$ChatUi_editingMessage extends $Notifier<MessageModel?> {
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

@ProviderFor(ChatUi_forwardMessages)
final chatUi_forwardMessagesProvider = ChatUi_forwardMessagesProvider._();

final class ChatUi_forwardMessagesProvider
    extends $NotifierProvider<ChatUi_forwardMessages, List<MessageModel>> {
  ChatUi_forwardMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_forwardMessagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_forwardMessagesHash();

  @$internal
  @override
  ChatUi_forwardMessages create() => ChatUi_forwardMessages();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MessageModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MessageModel>>(value),
    );
  }
}

String _$chatUi_forwardMessagesHash() =>
    r'046378fddeac62c824f5070c2b43af692204f5f2';

abstract class _$ChatUi_forwardMessages extends $Notifier<List<MessageModel>> {
  List<MessageModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<MessageModel>, List<MessageModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MessageModel>, List<MessageModel>>,
              List<MessageModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatUi_forwardChatInfo)
final chatUi_forwardChatInfoProvider = ChatUi_forwardChatInfoProvider._();

final class ChatUi_forwardChatInfoProvider
    extends $NotifierProvider<ChatUi_forwardChatInfo, ChatListItemModel?> {
  ChatUi_forwardChatInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_forwardChatInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_forwardChatInfoHash();

  @$internal
  @override
  ChatUi_forwardChatInfo create() => ChatUi_forwardChatInfo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatListItemModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatListItemModel?>(value),
    );
  }
}

String _$chatUi_forwardChatInfoHash() =>
    r'338e8223c0b53da0327b2db363b1178782cd4249';

abstract class _$ChatUi_forwardChatInfo extends $Notifier<ChatListItemModel?> {
  ChatListItemModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChatListItemModel?, ChatListItemModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatListItemModel?, ChatListItemModel?>,
              ChatListItemModel?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatUi_isForwarding)
final chatUi_isForwardingProvider = ChatUi_isForwardingProvider._();

final class ChatUi_isForwardingProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ChatUi_isForwardingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_isForwardingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_isForwardingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return ChatUi_isForwarding(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatUi_isForwardingHash() =>
    r'5a3fd8871b8bd06b1b31fc1577bfcf6e8acd905a';

@ProviderFor(ChatUi_deleteForEveryone)
final chatUi_deleteForEveryoneProvider = ChatUi_deleteForEveryoneProvider._();

final class ChatUi_deleteForEveryoneProvider
    extends $NotifierProvider<ChatUi_deleteForEveryone, bool> {
  ChatUi_deleteForEveryoneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_deleteForEveryoneProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_deleteForEveryoneHash();

  @$internal
  @override
  ChatUi_deleteForEveryone create() => ChatUi_deleteForEveryone();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatUi_deleteForEveryoneHash() =>
    r'd971d6b6c8bc830046c754462a430809f7cac909';

abstract class _$ChatUi_deleteForEveryone extends $Notifier<bool> {
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

@ProviderFor(ChatUi_forwardSearchQuery)
final chatUi_forwardSearchQueryProvider = ChatUi_forwardSearchQueryProvider._();

final class ChatUi_forwardSearchQueryProvider
    extends $NotifierProvider<ChatUi_forwardSearchQuery, String> {
  ChatUi_forwardSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUi_forwardSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUi_forwardSearchQueryHash();

  @$internal
  @override
  ChatUi_forwardSearchQuery create() => ChatUi_forwardSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$chatUi_forwardSearchQueryHash() =>
    r'd0d05840fe4385d560fedd83b64723e13349d78d';

abstract class _$ChatUi_forwardSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
