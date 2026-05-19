import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required TextEditingController controller,
    this.onChanged,
  }) : _phoneController = controller;

  final TextEditingController _phoneController;
  final void Function(PhoneNumber)? onChanged;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: _phoneController,
      showDropdownIcon: false,
      flagsButtonPadding: EdgeInsets.only(left: 8),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone number',
        border: OutlineInputBorder(),
      ),
      initialCountryCode: 'US',
      onChanged: onChanged,
      disableLengthCheck: false,
      validator: (value) {
        if (value == null || value.number.trim().isEmpty) {
          return 'Please enter phone number';
        }
        return null;
      },
    );
  }
}
