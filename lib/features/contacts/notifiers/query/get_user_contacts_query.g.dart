// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_contacts_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetUserContactsQuery)
final getUserContactsQueryProvider = GetUserContactsQueryProvider._();

final class GetUserContactsQueryProvider
    extends
        $AsyncNotifierProvider<
          GetUserContactsQuery,
          List<ContactWithAcountAndPresenceModel>
        > {
  GetUserContactsQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUserContactsQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUserContactsQueryHash();

  @$internal
  @override
  GetUserContactsQuery create() => GetUserContactsQuery();
}

String _$getUserContactsQueryHash() =>
    r'261080fa68696e479afb38d9f3ba11f95d9247d2';

abstract class _$GetUserContactsQuery
    extends $AsyncNotifier<List<ContactWithAcountAndPresenceModel>> {
  FutureOr<List<ContactWithAcountAndPresenceModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ContactWithAcountAndPresenceModel>>,
              List<ContactWithAcountAndPresenceModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ContactWithAcountAndPresenceModel>>,
                List<ContactWithAcountAndPresenceModel>
              >,
              AsyncValue<List<ContactWithAcountAndPresenceModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
