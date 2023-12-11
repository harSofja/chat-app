import 'package:chat_app/widgets/components/drawer_screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail =
        user?.email ?? 'No Email'; // Default text if the email is null
// You can also retrieve the user's photo URL if you have set it up
    final userPhotoUrl = user?.photoURL ?? 'default_photo_url';

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
                  Icons.edit_document,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Οι σημειώσεις μου',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  // Handle the tap
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Ρυθμίσεις',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  // Handle the tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
