import 'package:chat_app/widgets/screens/drawer_screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String username = '';
  final String defaultAvatarUrl =
      'https://www.flaticon.com/free-icon/user_1177568?term=avatar&page=1&position=45&origin=tag&related_id=1177568';

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  void loadUserProfile() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    setState(() {
      username = userDoc.data()?['username'] ?? '';
    });
  }

  // ... [signOut and deleteUserAccount methods]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          'Προφίλ',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user?.photoURL ?? defaultAvatarUrl,
                      ),
                      radius: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Email: ${user?.email ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Username: $username',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Icon(
                          Icons.edit,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      title: Text(
                        'Επεξεργασία προφίλ',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const EditProfileScreen()),
                        );
                      },
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.secondary,
                      thickness: 1,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(
                        'Αποσύνδεση',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: signOut,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4.0),
              child: ListTile(
                leading: Icon(
                  Icons.cancel,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Κατάργηση λογαριασμού',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                onTap: deleteUserAccount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonCard(IconData icon, String label, VoidCallback onPressed) {
    return Card(
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void deleteUserAccount() async {
    // Confirmation dialog before deleting account
    bool shouldDelete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Κατάργηση λογαριασμού'),
            content: const Text(
                'Είστε σίγουροι ότι θέλετε να διαγράψετε μόνιμα το λογαριασμό σας; Αυτή η επιλογή δε μπορεί να αναιρεθεί.'),
            actions: [
              TextButton(
                child: const Text('Ακύρωση'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Διαγραφή'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDelete) {
      // Delete user account logic
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .delete();
      await user?.delete();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      // Navigate to login after deletion
    }
  }

  ButtonStyle buttonStyle(IconData icon) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
    ).copyWith(
      iconSize: MaterialStateProperty.all(24), // Adjust icon size as needed
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
