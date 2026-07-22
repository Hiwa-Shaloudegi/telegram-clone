import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/app/router/extra/contacts_page_extra.dart';
import 'package:telegram_clone/app/router/extra/edit_folder_extra.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/pages/not_found_page.dart';
import 'package:telegram_clone/features/auth/notifiers/current_user_notifier.dart';
import 'package:telegram_clone/features/auth/ui/pages/login_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/profile_info_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/signup_page.dart';
import 'package:telegram_clone/features/chat/ui/pages/chat_page.dart';
import 'package:telegram_clone/features/chat/ui/pages/forward_chat_picker_page.dart';
import 'package:telegram_clone/features/chat_list/ui/pages/archived_chats_page.dart';
import 'package:telegram_clone/features/chat_list/ui/pages/main_page.dart';
import 'package:telegram_clone/features/contacts/ui/pages/contacts_page.dart';
import 'package:telegram_clone/features/folders/ui/pages/add_chats_to_folder_page.dart';
import 'package:telegram_clone/features/folders/ui/pages/edit_folder_page.dart';
import 'package:telegram_clone/features/folders/ui/pages/folders_settings_page.dart';
import 'package:telegram_clone/features/folders/ui/pages/reorder_folders_page.dart';
import 'package:telegram_clone/features/profile/ui/pages/change_username_page.dart';
import 'package:telegram_clone/features/profile/ui/pages/edit_profile_page.dart';
import 'package:telegram_clone/features/profile/ui/pages/profile_page.dart';
import 'package:telegram_clone/features/settings/ui/pages/settings_page.dart';
import 'package:telegram_clone/features/splash/ui/pages/splash_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final userValueNotifier = ValueNotifier<User?>(ref.read(currentUserProvider));

  ref.listen<User?>(currentUserProvider, (prev, next) {
    userValueNotifier.value = next;
  });

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: userValueNotifier,
    errorBuilder: (context, state) => const NotFoundPage(),
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/auth/signup',
        name: RouteNames.signup,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/auth/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        name: RouteNames.main,
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/profile/info',
        name: RouteNames.profileInfo,
        builder: (context, state) => const ProfileInfoPage(),
      ),
      GoRoute(
        path: '/profile',
        name: RouteNames.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/profile/username',
        name: RouteNames.changeUsername,
        builder: (context, state) => const ChangeUsernamePage(),
      ),
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/contacts',
        name: RouteNames.contacts,
        builder: (context, state) {
          final extra = state.extra as ContactsPageExtra;
          return ContactsPage(extra: extra);
        },
      ),
      GoRoute(
        name: RouteNames.chat,
        path: '/chat/:chatId',
        builder: (context, state) => ChatPage(),
      ),
      GoRoute(
        name: RouteNames.archivedChats,
        path: '/archived-chats',
        builder: (context, state) => const ArchivedChatsPage(),
      ),
      GoRoute(
        name: RouteNames.forwardChatPicker,
        path: '/forward-chat-picker',
        builder: (context, state) => const ForwardChatPickerPage(),
      ),
      GoRoute(
        name: RouteNames.folders,
        path: '/settings/folders',
        builder: (context, state) => const FoldersSettingsPage(),
      ),
      GoRoute(
        name: RouteNames.createFolder,
        path: '/settings/folders/create',
        builder: (context, state) => const EditFolderPage(),
      ),
      GoRoute(
        name: RouteNames.addChatsToFolder,
        path: '/settings/folders/add-chats',
        builder: (context, state) {
          final extra = state.extra is AddChatsToFolderExtra
              ? state.extra as AddChatsToFolderExtra
              : const AddChatsToFolderExtra();
          return AddChatsToFolderPage(extra: extra);
        },
      ),
      GoRoute(
        name: RouteNames.reorderFolders,
        path: '/settings/folders/reorder',
        builder: (context, state) => const ReorderFoldersPage(),
      ),
      // Parameterized route last so it doesn't swallow static paths above.
      GoRoute(
        name: RouteNames.editFolder,
        path: '/settings/folders/:folderId',
        builder: (context, state) {
          final folderId = state.pathParameters['folderId']!;
          return EditFolderPage(folderId: folderId);
        },
      ),
    ],
    redirect: (context, state) {
      final isAuthRoute =
          state.matchedLocation == '/auth/login' ||
          state.matchedLocation == '/auth/signup';
      final isSplashRoute = state.matchedLocation == '/splash';

      // Don't redirect while on splash, it has its own logic
      if (isSplashRoute) return null;

      if (ref.read(currentUserProvider) == null) {
        // Not logged in: allow only auth routes
        if (!isAuthRoute) return '/auth/login';
      } else {
        // Logged in: redirect away from auth routes to chats
        if (isAuthRoute) return '/';
      }

      return null;
    },
  );
}
