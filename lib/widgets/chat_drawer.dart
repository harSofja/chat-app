import 'package:chat_app/screens/about_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? 'No Email';
    final userPhotoUrl = user?.photoURL ?? 'https://i.pravatar.cc/300';

    return SizedBox(
      height: 780,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
        child: Drawer(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          userPhotoUrl), // Replace with actual photo URL if available
                      radius: 40.0, // Adjust the size as needed
                    ),
                    const SizedBox(height: 10), // Space between avatar and text
                    Text(
                      userEmail, // Display the user's email or in-app tag
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Προφίλ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Σχετικά με την εφαρμογή',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const AboutScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
