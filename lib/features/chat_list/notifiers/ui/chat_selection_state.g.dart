// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_selection_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatSelection)
final chatSelectionProvider = ChatSelectionProvider._();

final class ChatSelectionProvider
    extends $NotifierProvider<ChatSelection, Map<String, ChatListItemModel>> {
  ChatSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSelectionHash();

  @$internal
  @override
  ChatSelection create() => ChatSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, ChatListItemModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, ChatListItemModel>>(
        value,
      ),
    );
  }
}

String _$chatSelectionHash() => r'5f46e5eda224393fcae75c35d56bbc03418c7866';

abstract class _$ChatSelection
    extends $Notifier<Map<String, ChatListItemModel>> {
  Map<String, ChatListItemModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, ChatListItemModel>,
              Map<String, ChatListItemModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, ChatListItemModel>,
                Map<String, ChatListItemModel>
              >,
              Map<String, ChatListItemModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(chatSelectionActive)
final chatSelectionActiveProvider = ChatSelectionActiveProvider._();

final class ChatSelectionActiveProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ChatSelectionActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSelectionActiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSelectionActiveHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return chatSelectionActive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatSelectionActiveHash() =>
    r'958ef9ba3d635c47e827c599d4f9f40b260df8ec';

@ProviderFor(chatSelectionAllPinned)
final chatSelectionAllPinnedProvider = ChatSelectionAllPinnedProvider._();

final class ChatSelectionAllPinnedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ChatSelectionAllPinnedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSelectionAllPinnedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSelectionAllPinnedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return chatSelectionAllPinned(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatSelectionAllPinnedHash() =>
    r'5521a2e0f9b87ab4aec5c606f69650f8e9339067';

@ProviderFor(chatSelectionAllArchived)
final chatSelectionAllArchivedProvider = ChatSelectionAllArchivedProvider._();

final class ChatSelectionAllArchivedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ChatSelectionAllArchivedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSelectionAllArchivedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSelectionAllArchivedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return chatSelectionAllArchived(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatSelectionAllArchivedHash() =>
    r'9872b3b9cafb572159b8653781e9270a0069ea26';

/// "Block user" is only reasonable when every selected chat is a DM.

@ProviderFor(chatSelectionOnlyDms)
final chatSelectionOnlyDmsProvider = ChatSelectionOnlyDmsProvider._();

/// "Block user" is only reasonable when every selected chat is a DM.

final class ChatSelectionOnlyDmsProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// "Block user" is only reasonable when every selected chat is a DM.
  ChatSelectionOnlyDmsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSelectionOnlyDmsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSelectionOnlyDmsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return chatSelectionOnlyDms(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatSelectionOnlyDmsHash() =>
    r'2e4e624af00327253d13b8ba6d576abd41ce841c';
