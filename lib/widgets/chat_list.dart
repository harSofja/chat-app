import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: ListView.builder(
        itemCount: 10, // Placeholder for chat count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Chat $index'),
            onTap: () {
              Navigator.pushNamed(context, '/chatWindow');
            },
          );
        },
      ),
    );
  }
}
