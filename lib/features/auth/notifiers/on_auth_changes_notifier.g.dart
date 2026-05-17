// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'on_auth_changes_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(onAuthChanges)
final onAuthChangesProvider = OnAuthChangesProvider._();

final class OnAuthChangesProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthState?>,
          AuthState?,
          Stream<AuthState?>
        >
    with $FutureModifier<AuthState?>, $StreamProvider<AuthState?> {
  OnAuthChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onAuthChangesProvider',
        isAutoDispose: false,
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

String _$onAuthChangesHash() => r'f11d7be18c2660f017c599011c83c21f6e9eb040';
