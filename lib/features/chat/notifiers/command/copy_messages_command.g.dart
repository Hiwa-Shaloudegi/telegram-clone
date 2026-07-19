// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'copy_messages_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CopyMessagesCommand)
final copyMessagesCommandProvider = CopyMessagesCommandProvider._();

final class CopyMessagesCommandProvider
    extends $AsyncNotifierProvider<CopyMessagesCommand, void> {
  CopyMessagesCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'copyMessagesCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$copyMessagesCommandHash();

  @$internal
  @override
  CopyMessagesCommand create() => CopyMessagesCommand();
}

String _$copyMessagesCommandHash() =>
    r'e5ca22531bcf4aba3c36bc714fb77b09ba05c99e';

abstract class _$CopyMessagesCommand extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
