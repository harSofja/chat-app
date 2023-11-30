import 'package:chat_app/widgets/components/chat_drawer.dart';
import 'package:chat_app/widgets/components/chat_list_item.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openEndDrawer(); // Open the drawer
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CircleAvatar(
                // Placeholder for user profile image
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
                // Add more styling if needed
              ),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      endDrawer: const ChatDrawer(),
      body: ListView.builder(
        itemCount: 10, // This will be dynamic later
        itemBuilder: (context, index) {
          return ChatListItem(
            chatPartnerName: 'Chat Partner $index',
            lastMessage: 'Last message snippet...',
            imageUrl:
                'https://via.placeholder.com/150', // Placeholder image URL
            timestamp: '9:40 AM',
            unreadMessages: index % 2, // Example for unread messages
          );
        },
      ),
    );
  }
}
