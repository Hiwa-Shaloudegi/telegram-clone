// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_by_id_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserByIdQuery)
final userByIdQueryProvider = UserByIdQueryFamily._();

final class UserByIdQueryProvider
    extends $AsyncNotifierProvider<UserByIdQuery, UserProfileModel> {
  UserByIdQueryProvider._({
    required UserByIdQueryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userByIdQueryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userByIdQueryHash();

  @override
  String toString() {
    return r'userByIdQueryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserByIdQuery create() => UserByIdQuery();

  @override
  bool operator ==(Object other) {
    return other is UserByIdQueryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userByIdQueryHash() => r'453467039d262cf46568b941247f1383eb83ead9';

final class UserByIdQueryFamily extends $Family
    with
        $ClassFamilyOverride<
          UserByIdQuery,
          AsyncValue<UserProfileModel>,
          UserProfileModel,
          FutureOr<UserProfileModel>,
          String
        > {
  UserByIdQueryFamily._()
    : super(
        retry: null,
        name: r'userByIdQueryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserByIdQueryProvider call(String userId) =>
      UserByIdQueryProvider._(argument: userId, from: this);

  @override
  String toString() => r'userByIdQueryProvider';
}

abstract class _$UserByIdQuery extends $AsyncNotifier<UserProfileModel> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<UserProfileModel> build(String userId);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
