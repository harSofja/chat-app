import 'package:chat_app/screens/user_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:chat_app/widgets/chat_drawer.dart';
import 'package:chat_app/widgets/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? '';
    // final currentUserName = currentUser?.displayName ??
    ''; // Assuming the displayName is the username

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
            .where('participants', arrayContains: currentUserId)
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
                  SizedBox(
                    width: 350,
                    child: Lottie.asset('assets/lotties/not_found.json'),
                  ), // Lottie animation
                  const SizedBox(height: 20),
                  Text(
                    'Δεν υπάρχουν ακόμη συνομιλίες!',
                    style: Theme.of(context).textTheme.bodyLarge,
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
              Timestamp timestamp =
                  chatData['lastMessageTimestamp'] as Timestamp? ??
                      Timestamp.now();

              return FutureBuilder<String>(
                future: _getChatPartnerData(chatData, currentUserId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  String chatPartnerName =
                      snapshot.data ?? 'Unknown'; // Use snapshot.data directly

                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ChatListItem(
                      chatPartnerName: chatPartnerName,
                      lastMessage: chatData['lastMessage'] ?? 'Χωρίς μήνυμα',
                      imageUrl: chatData['imageUrl'] ??
                          'https://via.placeholder.com/150',
                      timestamp: timestamp,
                      unreadMessages: 0,
                      chatId: chatId,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const UserSelectionScreen()),
          );
        },
        tooltip: 'Νέα Συνομιλία', // "New Chat" in Greek
        child: const Icon(Icons.message),
      ),
    );
  }

  Future<String> _getChatPartnerData(
      Map<String, dynamic> chatData, String currentUserId) async {
    List<String> participantIds = List<String>.from(chatData['participants']);
    participantIds.remove(currentUserId); // Remove current user's id
    String chatPartnerId =
        participantIds.first; // Assuming chats are always between two users

    // If participantNames exists and contains the other user's name, use it
    if (chatData.containsKey('participantNames') &&
        chatData['participantNames'] is List) {
      List<String> participantNames =
          List<String>.from(chatData['participantNames']);
      return participantNames.firstWhere((name) => name != currentUserId,
          orElse: () => 'Unknown');
    }

    // Otherwise, fetch from the 'users' collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(chatPartnerId)
        .get();

    // Ensure that userDoc.data() is cast to Map<String, dynamic>
    Map<String, dynamic> userData =
        userDoc.data() as Map<String, dynamic>? ?? {};
    return userData['username'] as String? ?? 'Unknown';
  }
}
