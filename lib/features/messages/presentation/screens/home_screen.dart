import 'package:flutter/material.dart';

/// Home screen displaying daily angel messages
/// 
/// This is the main screen of the app where users will view
/// their daily inspirational messages. Currently shows a placeholder
/// until the message display functionality is implemented.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Messages'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to Daily Messages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
