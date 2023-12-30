import 'dart:io';

import 'package:chat_app/screens/edit_profile_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String username = '';
  final String defaultAvatarUrl = 'https://i.pravatar.cc/300';

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

  Future<void> pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null && user != null) {
      String userId = user!.uid;
      var ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(userId);

      await ref.putFile(File(image.path));
      String imageUrl = await ref.getDownloadURL();

      // Save imageUrl to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'imageUrl': imageUrl,
      }, SetOptions(merge: true));

      // Update the user's photoURL in Firebase Auth (optional)
      await user!.updatePhotoURL(imageUrl);
    }
  }

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
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                          onTap:
                              pickAndUploadImage, // Call your image picking function
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user?.photoURL ?? defaultAvatarUrl,
                            ),
                            radius: 40,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                              4), // Padding inside the circle
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username,
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // First, prompt for the user's password
    String? password = await _promptForPassword(context);
    if (password == null || password.isEmpty) return;

    // Then, show the confirmation dialog
    bool shouldDelete = await _showDeleteConfirmationDialog(context);
    if (!shouldDelete) return;

    // Perform the deletion in a separate method
    _performUserDeletion(user, password);
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
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
                child: const Text('Οριστική διαγραφή'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _performUserDeletion(User user, String password) async {
    try {
      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Delete user's document from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Delete user from Firebase Authentication
      await user.delete();

      // Navigate to login after deletion
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      // Handle exceptions (e.g., show error message)
      print("Error deleting user: $e");
    }
  }

// Helper function to prompt for password
  Future<String?> _promptForPassword(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
            'Για λόγους ασφαλείας θα πρέπει να εισάγεται τον κωδικό σας'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Κωδικός'),
        ),
        actions: [
          TextButton(
            child: const Text('Ακύρωση'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Υποβολή'),
            onPressed: () => Navigator.of(context).pop(passwordController.text),
          ),
        ],
      ),
    );
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
