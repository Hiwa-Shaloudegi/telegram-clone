// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_chats_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetUserChatsQuery)
const getUserChatsQueryProvider = GetUserChatsQueryProvider._();

final class GetUserChatsQueryProvider
    extends $AsyncNotifierProvider<GetUserChatsQuery, List<ChatModel>> {
  const GetUserChatsQueryProvider._()
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

String _$getUserChatsQueryHash() => r'9a8df23ebe35cd069958432972640c71aabab45e';

abstract class _$GetUserChatsQuery extends $AsyncNotifier<List<ChatModel>> {
  FutureOr<List<ChatModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<ChatModel>>, List<ChatModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ChatModel>>, List<ChatModel>>,
              AsyncValue<List<ChatModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
