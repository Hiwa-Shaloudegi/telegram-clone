// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_user_chats_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WatchUserChatsQuery)
final watchUserChatsQueryProvider = WatchUserChatsQueryProvider._();

final class WatchUserChatsQueryProvider
    extends
        $StreamNotifierProvider<WatchUserChatsQuery, List<ChatListItemModel>> {
  WatchUserChatsQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchUserChatsQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchUserChatsQueryHash();

  @$internal
  @override
  WatchUserChatsQuery create() => WatchUserChatsQuery();
}

String _$watchUserChatsQueryHash() =>
    r'a42734efb566f6c2c16203ef193f821477fa554b';

abstract class _$WatchUserChatsQuery
    extends $StreamNotifier<List<ChatListItemModel>> {
  Stream<List<ChatListItemModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ChatListItemModel>>,
              List<ChatListItemModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ChatListItemModel>>,
                List<ChatListItemModel>
              >,
              AsyncValue<List<ChatListItemModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
