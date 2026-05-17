// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_info_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileInfoUi_selectedProfileImage)
final profileInfoUi_selectedProfileImageProvider =
    ProfileInfoUi_selectedProfileImageProvider._();

final class ProfileInfoUi_selectedProfileImageProvider
    extends $NotifierProvider<ProfileInfoUi_selectedProfileImage, XFile?> {
  ProfileInfoUi_selectedProfileImageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileInfoUi_selectedProfileImageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$profileInfoUi_selectedProfileImageHash();

  @$internal
  @override
  ProfileInfoUi_selectedProfileImage create() =>
      ProfileInfoUi_selectedProfileImage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(XFile? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<XFile?>(value),
    );
  }
}

String _$profileInfoUi_selectedProfileImageHash() =>
    r'7316d54306b4b13152925bb2876e247ee03df5c4';

abstract class _$ProfileInfoUi_selectedProfileImage extends $Notifier<XFile?> {
  XFile? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<XFile?, XFile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<XFile?, XFile?>,
              XFile?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
