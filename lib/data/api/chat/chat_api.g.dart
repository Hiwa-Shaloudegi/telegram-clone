// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatApi)
final chatApiProvider = ChatApiProvider._();

final class ChatApiProvider
    extends $FunctionalProvider<ChatApi, ChatApi, ChatApi>
    with $Provider<ChatApi> {
  ChatApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatApiHash();

  @$internal
  @override
  $ProviderElement<ChatApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatApi create(Ref ref) {
    return chatApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatApi>(value),
    );
  }
}

String _$chatApiHash() => r'ff84e68492110058a53e0791158b385c2f12973b';
