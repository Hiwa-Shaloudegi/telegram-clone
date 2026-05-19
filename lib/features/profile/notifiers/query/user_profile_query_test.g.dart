// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_query_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserProfileQueryTest)
final userProfileQueryTestProvider = UserProfileQueryTestProvider._();

final class UserProfileQueryTestProvider
    extends $AsyncNotifierProvider<UserProfileQueryTest, UserProfileModel> {
  UserProfileQueryTestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileQueryTestProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileQueryTestHash();

  @$internal
  @override
  UserProfileQueryTest create() => UserProfileQueryTest();
}

String _$userProfileQueryTestHash() =>
    r'fcc9eded54e05ee2349d86fbad61bed00c9db1a6';

abstract class _$UserProfileQueryTest extends $AsyncNotifier<UserProfileModel> {
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
