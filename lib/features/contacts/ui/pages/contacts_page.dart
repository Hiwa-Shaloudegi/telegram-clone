import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:telegram_clone/core/ui/widgets/primary_button.dart';
import 'package:telegram_clone/core/ui/widgets/section_divider.dart';

class ContactsPage extends ConsumerWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            leading: Icon(Icons.person_add_outlined, size: 22),
            title: Text('Invite Friends', style: TextStyle(fontSize: 15)),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                builder: (context) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "New Contact",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "First name (required)",
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Last name (optional)",
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          IntlPhoneField(
                            showDropdownIcon: false,
                            flagsButtonPadding: EdgeInsets.only(left: 8),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone number',
                              border: OutlineInputBorder(),
                            ),
                            initialCountryCode: 'US',
                            onChanged: (phone) {},
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: PrimaryButton(
                              text: "Create Contact",
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SectionDivider(),

          // List of user contacts:
          Expanded(
            child: Center(child: Text('User contacts will be shown here')),
          ),
        ],
      ),
    );
  }
}
