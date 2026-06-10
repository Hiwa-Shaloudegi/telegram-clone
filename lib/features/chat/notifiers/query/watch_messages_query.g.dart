// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_messages_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Live stream of messages for the given [chatId].

@ProviderFor(watchMessagesQuery)
final watchMessagesQueryProvider = WatchMessagesQueryFamily._();

/// Live stream of messages for the given [chatId].

final class WatchMessagesQueryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MessageModel>>,
          List<MessageModel>,
          Stream<List<MessageModel>>
        >
    with
        $FutureModifier<List<MessageModel>>,
        $StreamProvider<List<MessageModel>> {
  /// Live stream of messages for the given [chatId].
  WatchMessagesQueryProvider._({
    required WatchMessagesQueryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'watchMessagesQueryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchMessagesQueryHash();

  @override
  String toString() {
    return r'watchMessagesQueryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MessageModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MessageModel>> create(Ref ref) {
    final argument = this.argument as String;
    return watchMessagesQuery(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchMessagesQueryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchMessagesQueryHash() =>
    r'4d54ff9556a7163db158033210de65dfb72378e6';

/// Live stream of messages for the given [chatId].

final class WatchMessagesQueryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MessageModel>>, String> {
  WatchMessagesQueryFamily._()
    : super(
        retry: null,
        name: r'watchMessagesQueryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Live stream of messages for the given [chatId].

  WatchMessagesQueryProvider call(String chatId) =>
      WatchMessagesQueryProvider._(argument: chatId, from: this);

  @override
  String toString() => r'watchMessagesQueryProvider';
}
