// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_message_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditMessageCommand)
final editMessageCommandProvider = EditMessageCommandFamily._();

final class EditMessageCommandProvider
    extends $AsyncNotifierProvider<EditMessageCommand, void> {
  EditMessageCommandProvider._({
    required EditMessageCommandFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'editMessageCommandProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editMessageCommandHash();

  @override
  String toString() {
    return r'editMessageCommandProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditMessageCommand create() => EditMessageCommand();

  @override
  bool operator ==(Object other) {
    return other is EditMessageCommandProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editMessageCommandHash() =>
    r'a06dd66fe944d893ef5464b19d412355c3a94db1';

final class EditMessageCommandFamily extends $Family
    with
        $ClassFamilyOverride<
          EditMessageCommand,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String
        > {
  EditMessageCommandFamily._()
    : super(
        retry: null,
        name: r'editMessageCommandProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditMessageCommandProvider call(String messageId) =>
      EditMessageCommandProvider._(argument: messageId, from: this);

  @override
  String toString() => r'editMessageCommandProvider';
}

abstract class _$EditMessageCommand extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as String;
  String get messageId => _$args;

  FutureOr<void> build(String messageId);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
