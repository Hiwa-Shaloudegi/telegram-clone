// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatsApi)
final chatsApiProvider = ChatsApiProvider._();

final class ChatsApiProvider
    extends $FunctionalProvider<ChatsApi, ChatsApi, ChatsApi>
    with $Provider<ChatsApi> {
  ChatsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsApiHash();

  @$internal
  @override
  $ProviderElement<ChatsApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatsApi create(Ref ref) {
    return chatsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatsApi>(value),
    );
  }
}

String _$chatsApiHash() => r'44b084f54c09ad8d266160ad5bdc298844dadd4b';
