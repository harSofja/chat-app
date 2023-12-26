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

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a User')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var userDoc = snapshot.data!.docs[index];
              var userData = userDoc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(userData['username'] ?? 'No Name'),
                onTap: () => _createOrGetChat(context, userDoc.id),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _createOrGetChat(
      BuildContext context, String otherUserId) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid == otherUserId) return;

    String chatId = '';
    bool chatExists = false;
    String chatPartnerName = '';

    var otherUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .get();
    if (otherUserDoc.exists) {
      chatPartnerName = otherUserDoc.data()?['username'] ?? 'Unknown';
    }

    var chatQuery = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .get();

    for (var doc in chatQuery.docs) {
      var participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUserId)) {
        chatId = doc.id;
        chatExists = true;
        break;
      }
    }

    if (!chatExists) {
      var newChatDoc =
          await FirebaseFirestore.instance.collection('chats').add({
        'participants': [currentUser.uid, otherUserId],
        'lastMessage': '',
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });
      chatId = newChatDoc.id;
    }

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatWindowScreen(
            chatId: chatId,
            chatPartnerName: chatPartnerName,
          ),
        ),
      );
    }
  }
}
