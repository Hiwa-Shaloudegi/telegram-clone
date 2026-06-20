// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MainUi_isFabVisible)
final mainUi_isFabVisibleProvider = MainUi_isFabVisibleProvider._();

final class MainUi_isFabVisibleProvider
    extends $NotifierProvider<MainUi_isFabVisible, bool> {
  MainUi_isFabVisibleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainUi_isFabVisibleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainUi_isFabVisibleHash();

  @$internal
  @override
  MainUi_isFabVisible create() => MainUi_isFabVisible();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mainUi_isFabVisibleHash() =>
    r'1ef8e427af29a06a5592d483550ffcb09a283ed6';

abstract class _$MainUi_isFabVisible extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
