import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/shared/widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 360,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FlutterLogo(size: 96),
                const SizedBox(height: 16),
                Text(
                  'LinkUp',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Plan, coordinate and enjoy your social adventures',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 48,
                  child: PrimaryButton(label: 'Log In', onPressed: () => context.go('/login')),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: PrimaryButton(label: 'Register', onPressed: () => context.go('/register'), filled: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
