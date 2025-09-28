import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/forgotPassword/forgot_password_screen.dart';

// IMPORTA TODAS LAS PANTALLAS
import 'package:link_up/welcome/welcome_screen.dart';
import 'package:link_up/login/login_screen.dart';
import 'package:link_up/register/register_screen.dart';
import 'package:link_up/feed/event_feed_screen.dart';
import 'package:link_up/calendar/calendar_screen.dart';
import 'package:link_up/chat/chat_screen.dart';
import 'package:link_up/profile/profile_screen.dart';
import 'package:link_up/config/theme/app_colors.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [

    // SHELL ROUTE PARA LAS 4 TABS (barra inferior persistente)
    ShellRoute(
      builder: (context, state, child) {
        final path = state.uri.toString();

        // Determina qué tab está seleccionada
        final int index = path.startsWith('/calendar')
            ? 1
            : path.startsWith('/chat')
                ? 2
                : path.startsWith('/profile')
                    ? 3
                    : 0; // feed por defecto

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(child: child),
          bottomNavigationBar: NavigationBar(
            backgroundColor: AppColors.peach,
            selectedIndex: index,
            onDestinationSelected: (i) {
              if (i == 0) context.goNamed(EventFeedScreen.name);
              if (i == 1) context.goNamed(CalendarScreen.name);
              if (i == 2) context.goNamed(ChatScreen.name);
              if (i == 3) context.goNamed(ProfileScreen.name);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.event),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month),
                label: 'Calendar',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/welcome', 
          name: WelcomeScreen.name,
          builder: (context, state) => const WelcomeScreen()),
        GoRoute(
          path: '/login', 
          name: LoginScreen.name,
          builder: (context, state) => const LoginScreen()),
        GoRoute(
          path: '/register', 
          name: RegisterScreen.name,
          builder: (context, state) => const RegisterScreen()),
        GoRoute(
          path: '/forgot-password', 
          name: ForgotPasswordScreen.name,
          builder: (context, status) => const ForgotPasswordScreen()),
        GoRoute(
          path: '/feed',
          name: EventFeedScreen.name,
          builder: (_, __) => const EventFeedScreen(),
        ),
        GoRoute(
          path: '/calendar',
          name: CalendarScreen.name,
          builder: (_, __) => const CalendarScreen(),
        ),
        GoRoute(
          path: '/chat',
          name: ChatScreen.name,
          builder: (_, __) => const ChatScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: ProfileScreen.name,
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
