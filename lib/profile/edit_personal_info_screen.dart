import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_provider.dart';

class EditPersonalInfoScreen extends ConsumerWidget {
  static const name = 'edit-info';
  const EditPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    final nameCtrl = TextEditingController(text: profile.name);
    final emailCtrl = TextEditingController(text: profile.email);
    final phoneCtrl = TextEditingController(text: profile.phone);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              const SizedBox(height: 20),
              const Text("Saved Cards",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...profile.cards.map(
                (c) => ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: Text(c),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.read(profileProvider.notifier).updateProfile(
                        nameCtrl.text,
                        emailCtrl.text,
                        phoneCtrl.text,
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile updated")),
                  );
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
