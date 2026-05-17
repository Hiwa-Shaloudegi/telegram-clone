// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatsUi_isFabVisible)
final chatsUi_isFabVisibleProvider = ChatsUi_isFabVisibleProvider._();

final class ChatsUi_isFabVisibleProvider
    extends $NotifierProvider<ChatsUi_isFabVisible, bool> {
  ChatsUi_isFabVisibleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsUi_isFabVisibleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsUi_isFabVisibleHash();

  @$internal
  @override
  ChatsUi_isFabVisible create() => ChatsUi_isFabVisible();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$chatsUi_isFabVisibleHash() =>
    r'32a2f6b462d48e6a48f33d6bf0e32f971cdf840d';

abstract class _$ChatsUi_isFabVisible extends $Notifier<bool> {
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
