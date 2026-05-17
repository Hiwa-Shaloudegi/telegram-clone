import 'package:native_storage/native_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/constants/local_storage_constants.dart';
import 'package:telegram_clone/services/native_storage.dart';

part 'theme_local_service.g.dart';

@Riverpod(keepAlive: true)
ThemeLocalService themeLocalService(Ref ref) {
  return ThemeLocalService(storage: ref.read(storageProvider));
}

class ThemeLocalService {
  final NativeStorage storage;

  ThemeLocalService({required this.storage});

  void saveTheme(String theme) {
    storage.write(LocalStorageConstants.themeMode, theme);
  }

  String? getTheme() {
    return storage.read(LocalStorageConstants.themeMode);
  }
}
