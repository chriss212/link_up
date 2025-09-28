import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const name = 'profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Profile Screen (WIP)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
