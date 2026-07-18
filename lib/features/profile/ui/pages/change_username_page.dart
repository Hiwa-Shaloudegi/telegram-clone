import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';
import 'package:telegram_clone/features/profile/notifiers/command/update_profile_command.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';

/// Telegram-style Change Username screen with live availability check.
class ChangeUsernamePage extends ConsumerStatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  ConsumerState<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends ConsumerState<ChangeUsernamePage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _originalUsername = '';
  bool _initialized = false;
  Timer? _debounce;
  _UsernameStatus _status = _UsernameStatus.idle;
  String? _statusMessage;

  // Telegram: 5–32 chars, a–z / 0–9 / underscore
  static final _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{5,32}$');

  bool get _hasChanges {
    return _controller.text.trim() != _originalUsername;
  }

  bool get _canSave {
    if (!_hasChanges) return false;
    final value = _controller.text.trim();
    // Allow clearing username
    if (value.isEmpty) return true;
    return _status == _UsernameStatus.available;
  }

  void _initialize(String? username) {
    if (_initialized) return;
    _originalUsername = username ?? '';
    _controller.text = _originalUsername;
    _controller.addListener(_onChanged);
    _initialized = true;
  }

  void _onChanged() {
    setState(() {});
    _debounce?.cancel();

    final value = _controller.text.trim();

    if (value == _originalUsername) {
      setState(() {
        _status = _UsernameStatus.idle;
        _statusMessage = null;
      });
      return;
    }

    if (value.isEmpty) {
      setState(() {
        _status = _UsernameStatus.idle;
        _statusMessage = 'You can use a-z, 0-9 and underscores.\n'
            'Minimum length is 5 characters.';
      });
      return;
    }

    if (value.length < 5) {
      setState(() {
        _status = _UsernameStatus.invalid;
        _statusMessage = 'Username must have at least 5 characters.';
      });
      return;
    }

    if (value.length > 32) {
      setState(() {
        _status = _UsernameStatus.invalid;
        _statusMessage = 'Username must be at most 32 characters.';
      });
      return;
    }

    if (!_usernameRegex.hasMatch(value)) {
      setState(() {
        _status = _UsernameStatus.invalid;
        _statusMessage =
            'Username can contain only letters, numbers, and underscores.';
      });
      return;
    }

    setState(() {
      _status = _UsernameStatus.checking;
      _statusMessage = 'Checking username…';
    });

    _debounce = Timer(const Duration(milliseconds: 450), () {
      _checkAvailability(value);
    });
  }

  Future<void> _checkAvailability(String username) async {
    try {
      final available =
          await ref.read(userApiProvider).isUsernameAvailable(username);
      if (!mounted || _controller.text.trim() != username) return;

      setState(() {
        if (available) {
          _status = _UsernameStatus.available;
          _statusMessage = '$username is available.';
        } else {
          _status = _UsernameStatus.taken;
          _statusMessage = 'Sorry, this username is already taken.';
        }
      });
    } catch (e) {
      if (!mounted || _controller.text.trim() != username) return;
      setState(() {
        _status = _UsernameStatus.invalid;
        _statusMessage = e.toString();
      });
    }
  }

  Future<void> _onSave() async {
    if (!_canSave) return;

    final value = _controller.text.trim();

    try {
      await ref.read(updateProfileCommandProvider.notifier).run(
            username: value.isNotEmpty ? value : null,
            clearUsername: value.isEmpty && _originalUsername.isNotEmpty,
          );

      if (mounted) {
        AppSnackbar.showSuccess(
          context,
          value.isEmpty ? 'Username removed' : 'Username updated',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileQueryProvider);
    final updateState = ref.watch(updateProfileCommandProvider);
    final isSaving = updateState.isLoading;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Username'),
        actions: [
          if (isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(
                Icons.check,
                color: _canSave ? Colors.white : Colors.white54,
              ),
              tooltip: 'Done',
              onPressed: _canSave ? _onSave : null,
            ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile != null) {
            _initialize(profile.usernameWithoutAt);
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            children: [
              Text(
                'You can choose a username on Telegram. If you do, people will '
                'be able to find you by this username and contact you without '
                'knowing your phone number.\n\n'
                'You can use a–z, 0–9 and underscores. '
                'Minimum length is 5 characters.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                  height: 1.45,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  enabled: !isSaving,
                  autofocus: true,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 17),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
                    LengthLimitingTextInputFormatter(32),
                  ],
                  decoration: InputDecoration(
                    prefixText: '@',
                    prefixStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 17,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'username',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 10),
                    suffixIcon: _buildStatusIcon(theme),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_statusMessage != null)
                Text(
                  _statusMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _statusColor(theme),
                    height: 1.35,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget? _buildStatusIcon(ThemeData theme) {
    switch (_status) {
      case _UsernameStatus.checking:
        return const Padding(
          padding: EdgeInsets.all(12),
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      case _UsernameStatus.available:
        return Icon(Icons.check_circle, color: Colors.green.shade600, size: 22);
      case _UsernameStatus.taken:
      case _UsernameStatus.invalid:
        return Icon(Icons.cancel, color: theme.colorScheme.error, size: 22);
      case _UsernameStatus.idle:
        return null;
    }
  }

  Color _statusColor(ThemeData theme) {
    switch (_status) {
      case _UsernameStatus.available:
        return Colors.green.shade600;
      case _UsernameStatus.taken:
      case _UsernameStatus.invalid:
        return theme.colorScheme.error;
      case _UsernameStatus.checking:
      case _UsernameStatus.idle:
        return theme.brightness == Brightness.dark
            ? Colors.white54
            : Colors.black54;
    }
  }
}

enum _UsernameStatus { idle, checking, available, taken, invalid }
