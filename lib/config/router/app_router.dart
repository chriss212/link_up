import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/config/theme/app_colors.dart';
import 'package:link_up/forgotPassword/forgot_password_screen.dart';
import 'package:link_up/smartPlanner/smart_planner_screen.dart';

import 'package:link_up/welcome/welcome_screen.dart';
import 'package:link_up/login/login_screen.dart';
import 'package:link_up/register/register_screen.dart';

import 'package:link_up/feed/event_feed_screen.dart';
import 'package:link_up/calendar/calendar_screen.dart';
import 'package:link_up/events/models/event.dart';


import 'package:link_up/profile/profile_screen.dart';
import 'package:link_up/profile/edit_personal_info_screen.dart';
import 'package:link_up/profile/notifications_screen.dart';
import 'package:link_up/profile/past_events_screen.dart';
import 'package:link_up/finances/finances_screen.dart';
import 'package:link_up/profile/wallet_screen.dart';

import 'package:link_up/events/events_details_screen.dart';
import 'package:link_up/events/new_events_screen.dart';

import 'package:link_up/payments/payments_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      name: WelcomeScreen.name,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: ForgotPasswordScreen.name,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        final path = state.uri.toString();
        final int index = path.startsWith('/calendar')
            ? 1
            : path.startsWith('/smart-planner')
                ? 2
                : path.startsWith('/profile')
                    ? 3
                    : 0;

        // Detectar tema actual
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final colorScheme = theme.colorScheme;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(child: child),
          bottomNavigationBar: NavigationBar(
            backgroundColor: isDark 
                ? colorScheme.surfaceContainer
                : Colors.white,
            indicatorColor: AppColors.orange.withOpacity(isDark ? 0.25 : 0.15),
            selectedIndex: index,
            onDestinationSelected: (i) {
              if (i == 0) context.goNamed(EventFeedScreen.name);
              if (i == 1) context.goNamed(CalendarScreen.name);
              if (i == 2) context.goNamed(SmartPlannerScreen.name);
              if (i == 3) context.goNamed(ProfileScreen.name);
            },
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.event_outlined,
                  color: index == 0 ? AppColors.orange : colorScheme.onSurfaceVariant,
                ),
                selectedIcon: Icon(Icons.event, color: AppColors.orange),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: index == 1 ? AppColors.orange : colorScheme.onSurfaceVariant,
                ),
                selectedIcon: Icon(Icons.calendar_month, color: AppColors.orange),
                label: 'Calendar',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.lightbulb_outline,
                  color: index == 2 ? AppColors.orange : colorScheme.onSurfaceVariant,
                ),
                selectedIcon: Icon(Icons.lightbulb, color: AppColors.orange),
                label: 'Smart Planner',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline,
                  color: index == 3 ? AppColors.orange : colorScheme.onSurfaceVariant,
                ),
                selectedIcon: Icon(Icons.person, color: AppColors.orange),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      routes: [
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
          path: '/smart-planner',
          name: SmartPlannerScreen.name,
          builder: (_, __) => const SmartPlannerScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: ProfileScreen.name,
          builder: (_, __) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'edit-info',
              name: EditPersonalInfoScreen.name,
              builder: (_, __) => const EditPersonalInfoScreen(),
            ),
            GoRoute(
              path: 'notifications',
              name: NotificationsScreen.name,
              builder: (_, __) => const NotificationsScreen(),
            ),
            GoRoute(
              path: 'past-events',
              name: PastEventsScreen.name,
              builder: (_, __) => const PastEventsScreen(),
            ),
            GoRoute(
              path: 'finances',
              name: FinancesScreen.name,
              builder: (_, __) => const FinancesScreen(),
            ),
            GoRoute(
              path: 'wallet',
              name: WalletScreen.name,
              builder: (_, __) => const WalletScreen(),
            ),
          ],
        ),

        GoRoute(
          path: '/event-details/:id',
          name: EventDetailsScreen.name,
          builder: (context, state) {
            final event = state.extra as Event;

            return EventDetailsScreen(
              event: event,
            );
          },
        ),
        GoRoute(
          path: '/new-event',
          name: NewEventScreen.name,
          builder: (_, __) => const NewEventScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/payments',
      name: PaymentsScreen.name,
      builder: (_, __) => const PaymentsScreen(),
    ),
  ],
);