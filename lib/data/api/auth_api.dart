import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/exception/app_exception.dart';
import 'package:telegram_clone/core/exception/exception_handler.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'auth_api.g.dart';

@Riverpod(keepAlive: true)
AuthApi authApi(Ref ref) {
  return AuthApi(
    supabase: ref.read(supabaseProvider),
    exceptionHandler: ref.read(exceptionHandlerProvider),
  );
}

class AuthApi {
  final SupabaseClient supabase;
  final ExceptionHandler exceptionHandler;

  AuthApi({required this.supabase, required this.exceptionHandler});

  User? get currentUser => supabase.auth.currentUser;

  Stream<AuthState> onAuthStateChange() {
    return supabase.auth.onAuthStateChange;
  }

  Future<AuthResponse> signup(
    String email,
    String password,
    String name,
  ) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      return res;
    } on Exception catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return res;
    } on Exception catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
    } on Exception catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<AuthResponse> googleSignIn() async {
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';
    final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '';

    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    if (kIsWeb) {
      await googleSignIn.initialize(clientId: webClientId);
    } else {
      await googleSignIn.initialize(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
    }
    try {
      if (kIsWeb) {
        return await _googleSignInWeb();
      } else {
        return await _googleSignInMobile();
      }
    } on Exception catch (e, st) {
      exceptionHandler.handle(e, st);
    }
  }

  Future<AuthResponse> _googleSignInWeb() async {
    final response = await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'http://localhost:7357/auth/callback',
      authScreenLaunchMode: LaunchMode.platformDefault,
    );

    if (!response) {
      throw AppException(
        message: 'Google Sign-In failed',
        userMessage: 'Google Sign-In was cancelled or failed',
      );
    }

    final authState = await supabase.auth.onAuthStateChange.firstWhere(
      (state) => state.session != null,
    );

    return AuthResponse(
      session: authState.session,
      user: authState.session?.user,
    );
  }

  Future<AuthResponse> _googleSignInMobile() async {
    final googleSignIn = GoogleSignIn.instance;

    final googleUser = await googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw AppException(message: 'No ID Token found.');
    }

    return await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: idToken,
    );
  }
}
