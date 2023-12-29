// import 'package:chat_app/widgets/screens/chat_window_screen.dart';
// import 'package:flutter/material.dart';

// class UserSearchScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> users = [
//     {
//       "username": "Αλίκη",
//       "uid": "aliceUID",
//       "imageUrl":
//           "https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8ZmFjZXN8ZW58MHx8MHx8fDA%3D"
//     },
//     {
//       "username": "Βασίλης",
//       "uid": "bobUID",
//       "imageUrl":
//           "https://images.unsplash.com/photo-1582233479366-6d38bc390a08?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZmFjZXN8ZW58MHx8MHx8fDA%3D"
//     },
//     // Add more sample users with their image URLs
//   ];

//   UserSearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Select User to Chat')),
//       body: ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(users[index]["imageUrl"]),
//             ),
//             title: Text(users[index]["username"]),
//             onTap: () async {
//               String chatId = await createOrGetChat(users[index]["uid"]);
//               if (context.mounted) {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => ChatWindowScreen(
//                       chatId: chatId,
//                       chatPartnerName: users[index]["username"],
//                     ),
//                   ),
//                 );
//               }
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<String> createOrGetChat(String otherUserId) async {
//     // Simulate chat creation logic
//     return "dummyChatId";
//   }
// }

import 'package:chat_app/widgets/screens/chat_window_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  late Future<List<Map<String, dynamic>>> _usersFuture;
  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs
        .map((doc) => {'id': doc.id, 'username': doc['username']})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Αναζήτηση',
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Δεν βρέθηκαν χρήστες με αυτό το όνομα.');
          }

          var users = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 2,
                ),
              ),
              child: Autocomplete<Map<String, dynamic>>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Map<String, dynamic>>.empty();
                  }
                  return users.where((user) {
                    return user['username']
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase());
                  });
                },
                displayStringForOption: (Map<String, dynamic> option) =>
                    option['username'],
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Αναζήτησε χρήστες',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: InputBorder.none,
                    ),
                  );
                },
                onSelected: (Map<String, dynamic> selection) {
                  _createOrGetChat(context, selection['id']);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _createOrGetChat(
      BuildContext context, String otherUserId) async {
    debugPrint("Called _createOrGetChat with otherUserId: $otherUserId");

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      debugPrint("Current user is null");
      return;
    }

    debugPrint("Current User ID: ${currentUser.uid}");
    if (currentUser.uid == otherUserId) {
      debugPrint("Cannot create chat with self");
      return;
    }

    // Fetch current user's username
    DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    Map<String, dynamic> currentUserData =
        currentUserDoc.data() as Map<String, dynamic>;
    String currentUserName = currentUserData['username'] ?? 'Unknown';

    // Fetch chat partner's name
    DocumentSnapshot otherUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .get();
    Map<String, dynamic> otherUserData =
        otherUserDoc.data() as Map<String, dynamic>;
    String chatPartnerName = otherUserData['username'] ?? 'Unknown';

    String chatId = '';
    bool chatExists = false;

    var chatQuery = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .get();

    for (var doc in chatQuery.docs) {
      var participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUserId)) {
        chatId = doc.id;
        chatExists = true;
        debugPrint("Found existing chat: $chatId");
        break;
      }
    }

    if (!chatExists) {
      debugPrint("Creating new chat");
      var newChatDoc =
          await FirebaseFirestore.instance.collection('chats').add({
        'participants': [currentUser.uid, otherUserId],
        'participantNames': [
          currentUserName,
          chatPartnerName
        ], // Store both names
        'lastMessage': '',
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });
      chatId = newChatDoc.id;
    }

    debugPrint("Navigating to ChatWindowScreen with chatId: $chatId");
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatWindowScreen(
            chatId: chatId,
            chatPartnerName: chatPartnerName,
          ),
        ),
      );
    } else {
      debugPrint("Context not mounted, cannot navigate");
    }
  }
}
