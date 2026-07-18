import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Telegram-style underlined form field used on Edit Profile.
class EditProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final bool enabled;
  final FocusNode? focusNode;

  const EditProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.prefix,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? const Color(0xFF6AB3F3) : theme.primaryColor;
    final underlineColor = isDark ? Colors.white24 : Colors.black12;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 17),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefix: prefix,
          // Telegram shows a floating label above the underline
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
            color: labelColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: labelColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38,
            fontSize: 17,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
          contentPadding: const EdgeInsets.only(top: 8, bottom: 10),
          counterText: maxLength != null ? null : '',
          counterStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.black45,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
