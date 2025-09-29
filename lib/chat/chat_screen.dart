import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const name = 'chat';
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Text(
          'Chat Screen (WIP)',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}
