import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/feed/event_feed_screen.dart';
import 'package:link_up/register/register_screen.dart';
import 'package:link_up/shared/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  static const name = 'login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/welcome'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: const [
                      SizedBox(height: 32),
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Log in to your next adventure',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email or username',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.go('/forgot-password'), 
                      child: const Text('Forgot password?')
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    child: PrimaryButton(
                      label: 'Log In',
                      onPressed: () => context.goNamed(EventFeedScreen.name),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text('Continue with Google'),
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () => context.goNamed(RegisterScreen.name),
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
