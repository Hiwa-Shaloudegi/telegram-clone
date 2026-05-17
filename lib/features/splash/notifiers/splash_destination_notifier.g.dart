// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_destination_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(splashDestinationNotifier)
final splashDestinationProvider = SplashDestinationNotifierProvider._();

final class SplashDestinationNotifierProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  SplashDestinationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashDestinationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashDestinationNotifierHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return splashDestinationNotifier(ref);
  }
}

String _$splashDestinationNotifierHash() =>
    r'544ee88c53678d3bc22e888efa55f48cced81f89';
