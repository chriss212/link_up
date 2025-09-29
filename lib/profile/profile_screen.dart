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
import 'package:link_up/config/theme/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  static const name = 'profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: theme.inputDecorationTheme.fillColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.surface,
                    backgroundImage: const AssetImage('assets/images/foto_cristi.jpg'),
                    onBackgroundImageError: (_, __) {},
                    child: const Icon(Icons.person, size: 50),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Sophia Bennett",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "sophia@linkup.com",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Account section
              Text(
                "Account",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              _buildCard(
                context,
                theme,
                colorScheme,
                children: [
                  _buildMenuItem(
                    context,
                    theme,
                    colorScheme,
                    icon: Icons.person_outline,
                    title: "Edit Profile",
                    onTap: () => context.pushNamed(EditPersonalInfoScreen.name),
                  ),
                  _buildDivider(colorScheme),
                  _buildMenuItem(
                    context,
                    theme,
                    colorScheme,
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    onTap: () => context.pushNamed(NotificationsScreen.name),
                  ),
                  _buildDivider(colorScheme),
                  _buildMenuItem(
                    context,
                    theme,
                    colorScheme,
                    icon: Icons.history,
                    title: "Past Events",
                    onTap: () => context.pushNamed(PastEventsScreen.name),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Financial section
              Text(
                "Financial",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              _buildCard(
                context,
                theme,
                colorScheme,
                children: [
                  _buildMenuItem(
                    context,
                    theme,
                    colorScheme,
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Finances",
                    onTap: () => context.pushNamed(FinancesScreen.name),
                  ),
                  _buildDivider(colorScheme),
                  _buildMenuItem(
                    context,
                    theme,
                    colorScheme,
                    icon: Icons.wallet_outlined,
                    title: "Wallet",
                    onTap: () => context.pushNamed(WalletScreen.name),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Settings section
              Text(
                "Preferences",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              _buildCard(
                context,
                theme,
                colorScheme,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            themeMode == ThemeModeType.dark
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Dark Mode",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Switch(
                          value: themeMode == ThemeModeType.dark,
                          onChanged: (value) {
                            ref.read(themeProvider.notifier).setTheme(
                                  value ? ThemeModeType.dark : ThemeModeType.light,
                                );
                          },
                          activeColor: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Logout button
              _buildCard(
                context,
                theme,
                colorScheme,
                children: [
                  _buildMenuItem(
                    context,
                    theme,
                    colorScheme,
                    icon: Icons.logout,
                    title: "Log Out",
                    iconColor: Colors.red.shade400,
                    textColor: Colors.red.shade400,
                    onTap: () {
                      _showLogoutDialog(context, ref);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Version info
              Center(
                child: Text(
                  "LinkUp v1.0.0",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor ?? colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor ?? colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: colorScheme.onSurface.withOpacity(0.08),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: theme.inputDecorationTheme.fillColor,
        title: Text(
          "Log Out",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dctx).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              ref.read(walletProvider.notifier).reset();
              ref.read(profileProvider.notifier).reset();
              ref.read(financesProvider.notifier).reset();
              Navigator.of(dctx).pop();
              context.go('/welcome');
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}