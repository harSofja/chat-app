import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatWindowScreen extends StatelessWidget {
  final String chatId; // Assume you have a unique identifier for each chat
  final String chatPartnerName;

  const ChatWindowScreen({
    super.key,
    required this.chatId,
    required this.chatPartnerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          chatPartnerName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(chatId),
          ),
          _buildMessageInputField(chatId, context),
        ],
      ),
    );
  }

  Widget _buildMessageList(String chatId) {
    // StreamBuilder to listen to messages in real-time
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats/$chatId/messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Center(child: Text('No messages yet.'));
        }

        var messages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var messageData = messages[index].data() as Map<String, dynamic>;
            // You can create a custom MessageWidget to display each message
            return _messageBubble(messageData, context);
          },
        );
      },
    );
  }

  Widget _buildMessageInputField(String chatId, BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: Theme.of(context).colorScheme.background,
                controller: messageController,
                maxLines: 10, // Maximum lines the TextField can expand to
                minLines: 1, // Minimum lines (initial size)
                decoration: InputDecoration(
                  hintText: 'Μήνυμα...',
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.background),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _sendMessage(chatId, messageController.text);
                messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Widget _messageBubble(
      Map<String, dynamic> messageData, BuildContext context) {
    String currentUserId = getCurrentUserId();
    bool isSentByMe = messageData['senderId'] == currentUserId;
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isSentByMe
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messageData['text'],
              style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                DateFormat('hh:mm a').format(
                  (messageData['timestamp'] as Timestamp).toDate(),
                ),
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(String chatId, String text) async {
    if (text.trim().isEmpty) return;

    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseFirestore.instance.collection('chats/$chatId/messages').add({
      'text': text,
      'senderId': currentUserId, // Adding the senderId here
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Also update the lastMessage and lastMessageTimestamp in the chat document
    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });
  }
}
