import 'package:chat_app/widgets/screens/user_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:chat_app/widgets/components/chat_drawer.dart';
import 'package:chat_app/widgets/components/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          'Συνομιλίες',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      endDrawer: const ChatDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants',
                arrayContains: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint("Αναμονή για δεδομένα...");
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint("Σφάλμα κατά τη λήψη δεδομένων: ${snapshot.error}");
            return const Center(child: Text('Κάτι πήγε στραβά'));
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset(
                      'assets/lottie/Animation.json'), // Lottie animation
                  const SizedBox(height: 20),
                  const Text('Δεν υπάρχουν ακόμη συνομιλίες!'),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to start a new chat
                    },
                    child: const Text('Ξεκινήστε μια νέα συνομιλία'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var chatData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String chatId = snapshot.data!.docs[index].id;
              Timestamp timestamp = chatData['lastMessageTimestamp'];
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ChatListItem(
                  chatPartnerName: chatData['partnerName'] ?? 'Άγνωστος',
                  lastMessage: chatData['lastMessage'] ?? 'Χωρίς μήνυμα',
                  imageUrl:
                      chatData['imageUrl'] ?? 'https://via.placeholder.com/150',
                  timestamp: timestamp,
                  unreadMessages: 0,
                  chatId: chatId,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UserSearchScreen()),
          );
        },
        tooltip: 'Νέα Συνομιλία', // "New Chat" in Greek
        child: const Icon(Icons.message),
      ),
    );
  }
}
