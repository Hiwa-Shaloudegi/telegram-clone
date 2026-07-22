// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_folders_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatFoldersApi)
final chatFoldersApiProvider = ChatFoldersApiProvider._();

final class ChatFoldersApiProvider
    extends $FunctionalProvider<ChatFoldersApi, ChatFoldersApi, ChatFoldersApi>
    with $Provider<ChatFoldersApi> {
  ChatFoldersApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatFoldersApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatFoldersApiHash();

  @$internal
  @override
  $ProviderElement<ChatFoldersApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatFoldersApi create(Ref ref) {
    return chatFoldersApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatFoldersApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatFoldersApi>(value),
    );
  }
}

String _$chatFoldersApiHash() => r'9601c52f3b45a29f81b8db38a52998bb575cfd8d';
