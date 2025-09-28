import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_personal_info_screen.dart';
import 'notifications_screen.dart';
import 'past_events_screen.dart';
import '../finances/finances_screen.dart';
import 'wallet_screen.dart';
import 'wallet_provider.dart'; 
import 'profile_provider.dart';
import 'package:link_up/finances/finances_provider.dart';

class ProfileScreen extends ConsumerWidget {
  static const name = 'profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=47"),
          ),
          const SizedBox(height: 12),
          const Text(
            "Sophia Bennett",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Edit Profile"),
            onTap: () => context.pushNamed(EditPersonalInfoScreen.name),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () => context.pushNamed(NotificationsScreen.name),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Past Events"),
            onTap: () => context.pushNamed(PastEventsScreen.name),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text("Finances"),
            onTap: () => context.pushNamed(FinancesScreen.name),
          ),
          ListTile(
            leading: const Icon(Icons.wallet),
            title: const Text("Wallet"),
            onTap: () => context.pushNamed(WalletScreen.name),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () {
              ref.read(walletProvider.notifier).reset();
              ref.read(profileProvider.notifier).reset();
              ref.read(financesProvider.notifier).reset();




              context.go('/welcome');
            },
          ),
        ],
      ),
    );
  }
}
