import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              // Add more decoration as needed
            ),
            child: Text('Drawer Header',
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Chats', style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              // Handle the tap
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              // Handle the tap
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Οι σημειώσεις μου'),
            onTap: () {
              // Handle the tap
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Ρυθμίσεις'),
            onTap: () {
              // Handle the tap
            },
          ),
        ],
      ),
    );
  }
}
