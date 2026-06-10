// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_by_date_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MessagesByDateQuery)
final messagesByDateQueryProvider = MessagesByDateQueryProvider._();

final class MessagesByDateQueryProvider
    extends $AsyncNotifierProvider<MessagesByDateQuery, List<MessageModel>> {
  MessagesByDateQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagesByDateQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagesByDateQueryHash();

  @$internal
  @override
  MessagesByDateQuery create() => MessagesByDateQuery();
}

String _$messagesByDateQueryHash() =>
    r'd3db9506fce2c3cb92a62add57d8a270d2495d98';

abstract class _$MessagesByDateQuery
    extends $AsyncNotifier<List<MessageModel>> {
  FutureOr<List<MessageModel>> build();
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
    element.handleCreate(ref, build);
  }
}
