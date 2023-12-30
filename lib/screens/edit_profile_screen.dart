import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      var userData = userDoc.data();

      // Set the email in the email controller
      _emailController.text = user.email ?? '';
      // Set username and bio if they exist
      _usernameController.text = userData?['username'] ?? '';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          'Επεξεργασία προφίλ',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Profile Picture
            // Implement profile picture editing here

            // Username TextField
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Όνομα χρήστη',
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded corners
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Email TextField
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Το email δεν μπορεί να αλλάξει για λόγους ασφαλείας.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
            // Bio/Status TextField

            const SizedBox(height: 15),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null && _usernameController.text.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set({
                      'username': _usernameController.text,
                    }, SetOptions(merge: true));

                    if (context.mounted) {
                      setState(() {
                        // This will cause the widget to rebuild with updated values.
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Το προφίλ σας ενημερώθηκε επιτυχώς',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                      );
                    }
                  }
                },
                child: Text(
                  'Αποθήκευση αλλαγών',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
