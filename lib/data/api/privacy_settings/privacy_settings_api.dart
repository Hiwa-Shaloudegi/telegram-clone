import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/exception/app_exception.dart';
import 'package:telegram_clone/core/exception/exception_handler.dart';
import 'package:telegram_clone/data/models/privacy_settings_model.dart';
import 'package:telegram_clone/services/supabase_client.dart';


part 'privacy_settings_api.g.dart'; 

@Riverpod(keepAlive: true)
PrivacySettingsApi privacySettingsApi(Ref ref) {
  return PrivacySettingsApi(
    supabase: ref.read(supabaseProvider),
    exceptionHandler: ref.read(exceptionHandlerProvider),
  );
}

class PrivacySettingsApi {
  
  final SupabaseClient supabase;
  final ExceptionHandler exceptionHandler;

  PrivacySettingsApi({required this.supabase, required this.exceptionHandler});

     Future<PrivacySettingsModel> getPrivacySettings() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      final response = await supabase
          .from('user_privacy_settings')
          .select()
          .eq('user_id', userId)
          .single();

      return PrivacySettingsModel.fromJson(response);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<PrivacySettingsModel> updatePrivacySettings({
    String? bioVisibility,
    String? profileImageVisibility,
    String? lastSeenVisibility,
    bool? showTypingIndicator,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      final updates = <String, dynamic>{};
      final validVisibilities = ['everyone', 'contacts', 'nobody'];

      if (bioVisibility != null) {
        if (!validVisibilities.contains(bioVisibility)) {
          throw AppException(
            message: 'Invalid visibility option',
            userMessage: 'Please select a valid privacy option',
          );
        }
        updates['bio_visibility'] = bioVisibility;
      }

      if (profileImageVisibility != null) {
        if (!validVisibilities.contains(profileImageVisibility)) {
          throw AppException(
            message: 'Invalid visibility option',
            userMessage: 'Please select a valid privacy option',
          );
        }
        updates['profile_image_visibility'] = profileImageVisibility;
      }

      if (lastSeenVisibility != null) {
        if (!validVisibilities.contains(lastSeenVisibility)) {
          throw AppException(
            message: 'Invalid visibility option',
            userMessage: 'Please select a valid privacy option',
          );
        }
        updates['last_seen_visibility'] = lastSeenVisibility;
      }

      if (showTypingIndicator != null) {
        updates['show_typing_indicator'] = showTypingIndicator;
      }

      if (updates.isEmpty) {
        throw AppException(
          message: 'No updates provided',
          userMessage: 'Please select at least one setting to update',
        );
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await supabase
          .from('user_privacy_settings')
          .update(updates)
          .eq('user_id', userId)
          .select()
          .single();

      return PrivacySettingsModel.fromJson(response);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }
}