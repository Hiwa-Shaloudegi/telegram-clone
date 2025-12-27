import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/constants/supabase/supa_buckets_constants.dart';
import 'package:telegram_clone/core/exception/app_exception.dart';
import 'package:telegram_clone/core/exception/exception_handler.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'storage_api.g.dart';

@Riverpod(keepAlive: true)
StorageApi storageApi(Ref ref) {
  return StorageApi(
    supabase: ref.read(supabaseProvider),
    exceptionHandler: ref.read(exceptionHandlerProvider),
  );
}

class StorageApi {
  final SupabaseClient supabase;
  final ExceptionHandler exceptionHandler;

  StorageApi({required this.supabase, required this.exceptionHandler});

  Future<String> uploadProfileImage(XFile file) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      final fileExt = path.extension(file.name);
      final fileName =
          '$userId/profile${DateTime.now().millisecondsSinceEpoch}$fileExt';

      final bytes = await file.readAsBytes();

      await supabase.storage
          .from(SupaBucketsConstants.profileImages)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: file.mimeType),
          );

      final publicUrl = supabase.storage
          .from(SupaBucketsConstants.profileImages)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<String> uploadChatMedia(XFile file, String chatId) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      final fileExt = path.extension(file.name);
      final fileName =
          '$chatId/${DateTime.now().millisecondsSinceEpoch}$fileExt';

      final bytes = await file.readAsBytes();

      await supabase.storage
          .from(SupaBucketsConstants.chatMedia)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: file.mimeType),
          );

      final publicUrl = supabase.storage
          .from(SupaBucketsConstants.chatMedia)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<void> deleteFile(String bucketName, String filePath) async {
    try {
      await supabase.storage.from(bucketName).remove([filePath]);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }
}
