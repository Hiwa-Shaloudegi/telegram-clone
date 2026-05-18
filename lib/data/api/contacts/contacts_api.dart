import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/exception/app_exception.dart';
import 'package:telegram_clone/core/exception/exception_handler.dart';
import 'package:telegram_clone/data/models/contact_with_acount_and_presence_model.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'contacts_api.g.dart';

@Riverpod(keepAlive: true)
ContactsApi contactsApi(Ref ref) {
  return ContactsApi(
    supabase: ref.read(supabaseProvider),
    exceptionHandler: ref.read(exceptionHandlerProvider),
  );
}

class ContactsApi {
  final SupabaseClient supabase;
  final ExceptionHandler exceptionHandler;

  ContactsApi({required this.supabase, required this.exceptionHandler});

  Future<bool> addContact({
    required String phone,
    required String firstName,
    required String? lastName,
  }) async {
    try {
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        throw AppException(message: 'No authenticated user');
      }

      // Check if user exists
      final existingUser = await supabase
          .from('users')
          .select('id')
          .eq('phone', phone)
          .maybeSingle();

      // Insert contact
      await supabase.from('user_contacts').insert({
        'user_id': currentUser.id,
        'contact_user_id': existingUser?['id'],
        'contact_phone': phone,
        'contact_first_name': firstName,
        'contact_last_name': lastName,
        'added_at': DateTime.now().toIso8601String(),
      });

      // returning 'true' means the contact_user already has an account
      return existingUser?['id'] != null;
    } on PostgrestException catch (e) {
      Logger().w('duplicate-contact, error code: ${e.code}');
      if (e.code == '23505') {
        throw AppException(
          message: "duplicate-contact",
          userMessage: "This contact already exists.",
        );
      }
      rethrow;
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }

  Future<List<ContactWithAcountAndPresenceModel>> fetchContacts() async {
    final response = await supabase.rpc(
      'get_contacts_with_account_and_presence',
    );
    final List<dynamic> rows = (response as List<dynamic>);

    return rows
        .map(
          (e) => ContactWithAcountAndPresenceModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
