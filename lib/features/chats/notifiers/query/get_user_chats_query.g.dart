// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_chats_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetUserChatsQuery)
final getUserChatsQueryProvider = GetUserChatsQueryProvider._();

final class GetUserChatsQueryProvider
    extends $AsyncNotifierProvider<GetUserChatsQuery, List<ChatListItemModel>> {
  GetUserChatsQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUserChatsQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUserChatsQueryHash();

  @$internal
  @override
  GetUserChatsQuery create() => GetUserChatsQuery();
}

String _$getUserChatsQueryHash() => r'08c91c41501c74ece8351e5043b89bb1182ce1db';

abstract class _$GetUserChatsQuery
    extends $AsyncNotifier<List<ChatListItemModel>> {
  FutureOr<List<ChatListItemModel>> build();
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
