// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserProfileQuery)
final userProfileQueryProvider = UserProfileQueryProvider._();

final class UserProfileQueryProvider
    extends $AsyncNotifierProvider<UserProfileQuery, UserProfile> {
  UserProfileQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileQueryHash();

  @$internal
  @override
  UserProfileQuery create() => UserProfileQuery();
}

String _$userProfileQueryHash() => r'596e87389c51a2ff35bccae2bbdbde35ed5ec670';

abstract class _$UserProfileQuery extends $AsyncNotifier<UserProfile> {
  FutureOr<UserProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfile>, UserProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile>, UserProfile>,
              AsyncValue<UserProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
