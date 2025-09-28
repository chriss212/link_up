import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const name = 'chat';
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Chat Screen (WIP)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
