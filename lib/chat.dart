import 'package:flutter/material.dart';

//TODO: Do the class properly is only for testing purposes
class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Center(
        child: Text('The chat are the friends we made along the way'),
      ),
    );
  }
}