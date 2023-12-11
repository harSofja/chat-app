import 'package:chat_app/widgets/components/chat_drawer.dart';
import 'package:chat_app/widgets/components/chat_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          'Chats',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      endDrawer: const ChatDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting for data...");
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error fetching data: ${snapshot.error}");
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            print("No data available");
            return const Center(child: Text('No chats found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var chatData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String chatId = snapshot.data!.docs[index].id;
              Timestamp timestamp = chatData[
                  'lastMessageTimestamp']; // Use fields from your Firestore documents. Adjust the field names as per your database structure
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ChatListItem(
                  chatPartnerName: chatData['partnerName'] ?? 'Unknown',
                  lastMessage: chatData['lastMessage'] ?? 'No message',
                  imageUrl:
                      chatData['imageUrl'] ?? 'https://via.placeholder.com/150',
                  timestamp: timestamp, // Pass the Timestamp directly
                  unreadMessages: 0,
                  chatId: chatId,
                ),
              );
            },
          );
        },
      ),
    );
  }
}