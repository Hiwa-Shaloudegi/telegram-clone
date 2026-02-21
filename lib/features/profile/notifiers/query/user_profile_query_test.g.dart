// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_query_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserProfileQueryTest)
const userProfileQueryTestProvider = UserProfileQueryTestProvider._();

final class UserProfileQueryTestProvider
    extends $AsyncNotifierProvider<UserProfileQueryTest, UserProfile> {
  const UserProfileQueryTestProvider._()
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
    r'0627a0b75f5b3c9295a2622336c8f6e5683d7bf3';

abstract class _$UserProfileQueryTest extends $AsyncNotifier<UserProfile> {
  FutureOr<UserProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserProfile>, UserProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile>, UserProfile>,
              AsyncValue<UserProfile>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
