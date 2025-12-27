import 'package:native_storage/native_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/constants/local_storage_constants.dart';
import 'package:telegram_clone/services/native_storage.dart';

part 'local_storage_service.g.dart';

@Riverpod(keepAlive: true)
LocalStorageService localStorageService(Ref ref) {
  return LocalStorageService(ref.read(storageProvider));
}

class LocalStorageService {
  final NativeStorage _storage;

  LocalStorageService(this._storage);

  // First Time Logic
  bool isFirstTime() {
    return _storage.read(LocalStorageConstants.isFirstTime) !=
        LocalStorageConstants.boolFalse;
  }

  void markAsNotFirstTime() {
    _storage.write(
      LocalStorageConstants.isFirstTime,
      LocalStorageConstants.boolFalse,
    );
  }

  // Theme Logic
  void saveTheme(String theme) {
    _storage.write(LocalStorageConstants.themeMode, theme);
  }

  String? getTheme() {
    return _storage.read(LocalStorageConstants.themeMode);
  }
}
