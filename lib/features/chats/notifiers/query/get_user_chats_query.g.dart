// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_chats_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getUserChatsQuery)
final getUserChatsQueryProvider = GetUserChatsQueryProvider._();

final class GetUserChatsQueryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatListItemModel>>,
          List<ChatListItemModel>,
          Stream<List<ChatListItemModel>>
        >
    with
        $FutureModifier<List<ChatListItemModel>>,
        $StreamProvider<List<ChatListItemModel>> {
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
  $StreamProviderElement<List<ChatListItemModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatListItemModel>> create(Ref ref) {
    return getUserChatsQuery(ref);
  }
}

String _$getUserChatsQueryHash() => r'529ca0d0d939275f3a912eed496063641f875010';
