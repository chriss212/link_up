import 'package:go_router/go_router.dart';
import 'package:link_up/login/login_screen.dart';
import 'package:link_up/register/register_screen.dart';
import 'package:link_up/welcome/welcome_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),

  ],
);
