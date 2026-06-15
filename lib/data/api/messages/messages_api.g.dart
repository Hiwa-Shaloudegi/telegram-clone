// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(messagesApi)
final messagesApiProvider = MessagesApiProvider._();

final class MessagesApiProvider
    extends $FunctionalProvider<MessagesApi, MessagesApi, MessagesApi>
    with $Provider<MessagesApi> {
  MessagesApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagesApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagesApiHash();

  @$internal
  @override
  $ProviderElement<MessagesApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MessagesApi create(Ref ref) {
    return messagesApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessagesApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessagesApi>(value),
    );
  }
}

String _$messagesApiHash() => r'ed037b4eeb48a91ca7e2e14895d85ad5533564d4';
