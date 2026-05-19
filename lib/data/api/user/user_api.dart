import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/exception/app_exception.dart';
import 'package:telegram_clone/core/exception/exception_handler.dart';
import 'package:telegram_clone/data/models/user_profile.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'user_api.g.dart';

@Riverpod(keepAlive: true)
UserApi userApi(Ref ref) {
  return UserApi(
    supabase: ref.read(supabaseProvider),
    exceptionHandler: ref.read(exceptionHandlerProvider),
  );
}

class UserApi {
  final SupabaseClient supabase;
  final ExceptionHandler exceptionHandler;

  UserApi({required this.supabase, required this.exceptionHandler});

  String? get _currentUserId =>
      supabase.auth.currentUser?.id ?? supabase.auth.currentSession?.user.id;

  Future<UserProfile> getUserProfile() async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      final response = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserProfile.fromJson(response);
    } on Exception catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<UserProfile> getUserById(String userId) async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .eq('is_active', true)
          .single();

      return UserProfile.fromJson(response);
    } on Exception catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<UserProfile?> getUserByUsername(String username) async {
    try {
      // Ensure username starts with @
      final formattedUsername = username.startsWith('@')
          ? username
          : '@$username';

      final response = await supabase
          .from('users')
          .select()
          .eq('username', formattedUsername)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) return null;

      return UserProfile.fromJson(response);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<List<UserProfile>> searchUsers(String query, {int limit = 20}) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      final searchTerm = query.trim();

      final response = await supabase
          .from('users')
          .select()
          .eq('is_active', true)
          .or('username.ilike.%$searchTerm%,display_name.ilike.%$searchTerm%')
          .limit(limit);

      return (response as List)
          .map((json) => UserProfile.fromJson(json))
          .toList();
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      // Ensure username starts with @
      final formattedUsername = username.startsWith('@')
          ? username
          : '@$username';

      // Validate format
      final usernameRegex = RegExp(r'^@[a-zA-Z0-9_]{3,30}$');
      if (!usernameRegex.hasMatch(formattedUsername)) {
        throw AppException(
          message: 'Invalid username format',
          userMessage:
              'Username must be 3-30 characters and contain only letters, numbers, and underscores',
        );
      }

      final response = await supabase
          .from('users')
          .select('id')
          .eq('username', formattedUsername)
          .maybeSingle();

      return response == null;
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<UserProfile> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? username,
  }) async {
    try {
      final userId = _currentUserId;

      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      final updates = <String, dynamic>{};

      if (firstName != null && firstName.trim().isNotEmpty) {
        updates['first_name'] = firstName.trim();
      }
      if (lastName != null && lastName.trim().isNotEmpty) {
        updates['last_name'] = lastName.trim();
      }

      if (bio != null) {
        // Allow empty string to clear bio
        updates['bio'] = bio.trim();
      }

      if (username != null && username.trim().isNotEmpty) {
        // Format and validate username
        final formattedUsername = username.startsWith('@')
            ? username
            : '@$username';
        final usernameRegex = RegExp(r'^@[a-zA-Z0-9_]{3,30}$');

        if (!usernameRegex.hasMatch(formattedUsername)) {
          throw AppException(
            message: 'Invalid username format',
            userMessage:
                'Username must be 3-30 characters and contain only letters, numbers, and underscores',
          );
        }

        // Check if username is available
        final isAvailable = await isUsernameAvailable(formattedUsername);
        if (!isAvailable) {
          throw AppException(
            message: 'Username already taken',
            userMessage:
                'This username is already in use. Please choose another.',
          );
        }

        updates['username'] = formattedUsername;
      }

      if (updates.isEmpty) {
        throw AppException(
          message: 'No updates provided',
          userMessage: 'Please provide at least one field to update',
        );
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await supabase
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<UserProfile> updateProfileImage(String imageUrl) async {
    try {
      final userId = _currentUserId;

      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      if (imageUrl.trim().isEmpty) {
        throw AppException(
          message: 'Invalid image URL',
          userMessage: 'Please provide a valid image',
        );
      }

      final response = await supabase
          .from('users')
          .update({
            'profile_image_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<UserProfile> removeProfileImage() async {
    try {
      final userId = _currentUserId;

      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      final response = await supabase
          .from('users')
          .update({
            'profile_image_url': null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<UserProfile> addAdditionalImage(String imageUrl) async {
    try {
      final userId = _currentUserId;

      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      if (imageUrl.trim().isEmpty) {
        throw AppException(
          message: 'Invalid image URL',
          userMessage: 'Please provide a valid image',
        );
      }

      // Get current user to access existing images
      final current = await getUserProfile();
      final images = List<String>.from(current.additionalImages);

      // Limit check (optional - can adjust max count)
      if (images.length >= 10) {
        throw AppException(
          message: 'Image limit reached',
          userMessage: 'You can only have up to 10 additional profile images',
        );
      }

      // Add new image
      images.add(imageUrl);

      final response = await supabase
          .from('users')
          .update({
            'additional_images': images,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<UserProfile> removeAdditionalImage(String imageUrl) async {
    try {
      final userId = _currentUserId;

      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      final current = await getUserProfile();
      final images = List<String>.from(current.additionalImages);

      if (!images.contains(imageUrl)) {
        throw AppException(
          message: 'Image not found',
          userMessage: 'The specified image was not found in your gallery',
        );
      }

      images.remove(imageUrl);

      final response = await supabase
          .from('users')
          .update({
            'additional_images': images,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<void> deleteAccount() async {
    try {
      final userId = _currentUserId;

      if (userId == null) {
        throw AppException(
          message: 'No authenticated user',
          userMessage: 'Please log in to continue',
        );
      }

      // Soft delete - mark as inactive
      await supabase
          .from('users')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      // Sign out user
      await supabase.auth.signOut();
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<List<UserProfile>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) {
        return [];
      }

      final response = await supabase
          .from('users')
          .select()
          .inFilter('id', userIds)
          .eq('is_active', true);

      return (response as List)
          .map((json) => UserProfile.fromJson(json))
          .toList();
    } catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }
}
