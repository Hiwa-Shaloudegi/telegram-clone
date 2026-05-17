import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:logger/logger.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/primary_button.dart';
import 'package:telegram_clone/features/contacts/notifiers/command/add_contact_command.dart';

Future<dynamic> showAddContactBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return AddContactBottomSheet();
    },
  );
}

class AddContactBottomSheet extends ConsumerStatefulWidget {
  const AddContactBottomSheet({super.key});

  @override
  ConsumerState<AddContactBottomSheet> createState() =>
      _AddContactBottomSheetState();
}

class _AddContactBottomSheetState extends ConsumerState<AddContactBottomSheet> {
  final _fitstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fitstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber = '';

    ref.listen(addContactCommandProvider, (previous, next) {
      next.when(
        data: (data) {
          Logger().w("NEXT VALUE: ${next.value}");
          final hasAccount = next.value as bool;

          if (hasAccount) {
            // TODO: navigate to PV chats page
          } else {
            // TODO: invite contact feature via SMS
            AppSnackbar.show(
              context,
              message: "Contact added. Invite them to Telegram!",
            );
          }

          // Close the bottom sheet
          Navigator.pop(context);
        },
        error: (error, stackTrace) {
          // Close the bottom sheet
          Navigator.pop(context);

          AppSnackbar.showError(context, next.error.toString());
        },
        loading: () {},
      );
    });

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Contact",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fitstNameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "First name (required)",
                  labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: "Last name (optional)",
                  labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              IntlPhoneField(
                controller: _phoneController,
                showDropdownIcon: false,
                flagsButtonPadding: EdgeInsets.only(left: 8),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'US',
                onChanged: (phone) {
                  phoneNumber = phone.completeNumber;
                },
                disableLengthCheck: false,
                validator: (value) {
                  if (value == null || value.number.trim().isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Consumer(
                  builder: (context, ref, _) {
                    return PrimaryButton(
                      text: "Create Contact",
                      isLoading: ref.watch(addContactCommandProvider).isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _phoneController.text.isNotEmpty) {
                          final phone = phoneNumber.trim();
                          final firstName = _fitstNameController.text.trim();
                          final lastName =
                              _lastNameController.text.trim().isEmpty
                              ? null
                              : _lastNameController.text.trim();

                          ref
                              .read(addContactCommandProvider.notifier)
                              .run(
                                phone: phone,
                                firstName: firstName,
                                lastName: lastName,
                              );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
