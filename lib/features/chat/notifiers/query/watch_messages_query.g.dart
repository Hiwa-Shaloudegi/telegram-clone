// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_messages_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WatchMessagesQuery)
final watchMessagesQueryProvider = WatchMessagesQueryFamily._();

final class WatchMessagesQueryProvider
    extends $StreamNotifierProvider<WatchMessagesQuery, List<MessageModel>> {
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
  WatchMessagesQuery create() => WatchMessagesQuery();

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
    r'94d2b5cdfd1375d023f9cfd26eb51e84153d1964';

final class WatchMessagesQueryFamily extends $Family
    with
        $ClassFamilyOverride<
          WatchMessagesQuery,
          AsyncValue<List<MessageModel>>,
          List<MessageModel>,
          Stream<List<MessageModel>>,
          String
        > {
  WatchMessagesQueryFamily._()
    : super(
        retry: null,
        name: r'watchMessagesQueryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchMessagesQueryProvider call(String chatId) =>
      WatchMessagesQueryProvider._(argument: chatId, from: this);

  @override
  String toString() => r'watchMessagesQueryProvider';
}

abstract class _$WatchMessagesQuery
    extends $StreamNotifier<List<MessageModel>> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  Stream<List<MessageModel>> build(String chatId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<MessageModel>>, List<MessageModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MessageModel>>, List<MessageModel>>,
              AsyncValue<List<MessageModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
