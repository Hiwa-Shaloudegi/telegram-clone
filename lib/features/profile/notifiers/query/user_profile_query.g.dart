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
    extends $AsyncNotifierProvider<UserProfileQuery, UserProfileModel> {
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

String _$userProfileQueryHash() => r'fb5d36f15e24d0936ad14a78f10ecd39ee87f776';

abstract class _$UserProfileQuery extends $AsyncNotifier<UserProfileModel> {
  FutureOr<UserProfileModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<UserProfileModel>, UserProfileModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfileModel>, UserProfileModel>,
              AsyncValue<UserProfileModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
