// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'on_auth_changes_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(onAuthChanges)
const onAuthChangesProvider = OnAuthChangesProvider._();

final class OnAuthChangesProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthState?>,
          AuthState?,
          Stream<AuthState?>
        >
    with $FutureModifier<AuthState?>, $StreamProvider<AuthState?> {
  const OnAuthChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onAuthChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onAuthChangesHash();

  @$internal
  @override
  $StreamProviderElement<AuthState?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState?> create(Ref ref) {
    return onAuthChanges(ref);
  }
}

String _$onAuthChangesHash() => r'89f1ea1896b80f445f6a34902d894f7433639e36';
