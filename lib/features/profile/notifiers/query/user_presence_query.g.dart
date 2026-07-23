// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_presence_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserPresenceQuery)
final userPresenceQueryProvider = UserPresenceQueryFamily._();

final class UserPresenceQueryProvider
    extends $StreamNotifierProvider<UserPresenceQuery, UserPresenceModel?> {
  UserPresenceQueryProvider._({
    required UserPresenceQueryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userPresenceQueryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userPresenceQueryHash();

  @override
  String toString() {
    return r'userPresenceQueryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserPresenceQuery create() => UserPresenceQuery();

  @override
  bool operator ==(Object other) {
    return other is UserPresenceQueryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userPresenceQueryHash() => r'c9fc029435f2bae0f2790615626db989e91f6789';

final class UserPresenceQueryFamily extends $Family
    with
        $ClassFamilyOverride<
          UserPresenceQuery,
          AsyncValue<UserPresenceModel?>,
          UserPresenceModel?,
          Stream<UserPresenceModel?>,
          String
        > {
  UserPresenceQueryFamily._()
    : super(
        retry: null,
        name: r'userPresenceQueryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserPresenceQueryProvider call(String userId) =>
      UserPresenceQueryProvider._(argument: userId, from: this);

  @override
  String toString() => r'userPresenceQueryProvider';
}

abstract class _$UserPresenceQuery extends $StreamNotifier<UserPresenceModel?> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  Stream<UserPresenceModel?> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<UserPresenceModel?>, UserPresenceModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserPresenceModel?>, UserPresenceModel?>,
              AsyncValue<UserPresenceModel?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
