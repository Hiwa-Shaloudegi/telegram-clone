// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_user_chats_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(watchUserChatsQuery)
final watchUserChatsQueryProvider = WatchUserChatsQueryProvider._();

final class WatchUserChatsQueryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatListItemModel>>,
          List<ChatListItemModel>,
          Stream<List<ChatListItemModel>>
        >
    with
        $FutureModifier<List<ChatListItemModel>>,
        $StreamProvider<List<ChatListItemModel>> {
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
  $StreamProviderElement<List<ChatListItemModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatListItemModel>> create(Ref ref) {
    return watchUserChatsQuery(ref);
  }
}

String _$watchUserChatsQueryHash() =>
    r'153148feab27d9385c2ccf57e841059e431eee47';
