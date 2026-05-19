// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_contacts_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetContactsQuery)
final getContactsQueryProvider = GetContactsQueryProvider._();

final class GetContactsQueryProvider
    extends
        $AsyncNotifierProvider<
          GetContactsQuery,
          List<ContactWithAcountAndPresenceModel>
        > {
  GetContactsQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getContactsQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getContactsQueryHash();

  @$internal
  @override
  GetContactsQuery create() => GetContactsQuery();
}

String _$getContactsQueryHash() => r'f532c047be8e5cbd4a9394e44a8e6e53f804d865';

abstract class _$GetContactsQuery
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

@ProviderFor(contactsWithAccount)
final contactsWithAccountProvider = ContactsWithAccountProvider._();

final class ContactsWithAccountProvider
    extends
        $FunctionalProvider<
          List<ContactWithAcountAndPresenceModel>,
          List<ContactWithAcountAndPresenceModel>,
          List<ContactWithAcountAndPresenceModel>
        >
    with $Provider<List<ContactWithAcountAndPresenceModel>> {
  ContactsWithAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsWithAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsWithAccountHash();

  @$internal
  @override
  $ProviderElement<List<ContactWithAcountAndPresenceModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ContactWithAcountAndPresenceModel> create(Ref ref) {
    return contactsWithAccount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ContactWithAcountAndPresenceModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<List<ContactWithAcountAndPresenceModel>>(value),
    );
  }
}

String _$contactsWithAccountHash() =>
    r'c09fae4f77e6c5eb001ff3fd9bbcdc97e11a6515';

@ProviderFor(contactsWithoutAccount)
final contactsWithoutAccountProvider = ContactsWithoutAccountProvider._();

final class ContactsWithoutAccountProvider
    extends
        $FunctionalProvider<
          List<ContactWithAcountAndPresenceModel>,
          List<ContactWithAcountAndPresenceModel>,
          List<ContactWithAcountAndPresenceModel>
        >
    with $Provider<List<ContactWithAcountAndPresenceModel>> {
  ContactsWithoutAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsWithoutAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsWithoutAccountHash();

  @$internal
  @override
  $ProviderElement<List<ContactWithAcountAndPresenceModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ContactWithAcountAndPresenceModel> create(Ref ref) {
    return contactsWithoutAccount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ContactWithAcountAndPresenceModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<List<ContactWithAcountAndPresenceModel>>(value),
    );
  }
}

String _$contactsWithoutAccountHash() =>
    r'c0e22a91050be80079bc47548b68a19df911b704';
