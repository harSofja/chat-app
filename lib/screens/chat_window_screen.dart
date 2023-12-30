import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ChatWindowScreen extends StatefulWidget {
  final String chatId; // Assume you have a unique identifier for each chat
  final String chatPartnerName;

  const ChatWindowScreen({
    super.key,
    required this.chatId,
    required this.chatPartnerName,
  });

  @override
  State<ChatWindowScreen> createState() => _ChatWindowScreenState();
}

class _ChatWindowScreenState extends State<ChatWindowScreen> {
  late final TextEditingController messageController;
  final String defaultAvatarUrl = 'https://i.pravatar.cc/300';

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    debugPrint("Chat ID: ${widget.chatId}");
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          widget.chatPartnerName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(widget.chatId),
          ),
          _buildMessageInputField(widget.chatId, context),
        ],
      ),
    );
  }

  Widget _buildMessageList(String chatId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats/$chatId/messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Log the error for debugging
          debugPrint("Error fetching messages: ${snapshot.error}");
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var messages = snapshot.data?.docs ?? [];
        if (messages.isEmpty) {
          return _buildWelcomeMessage(context);
        }
        _markMessagesAsRead(chatId);
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var messageData = messages[index].data() as Map<String, dynamic>;
            return _messageBubble(messageData, context);
          },
        );
      },
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset('assets/lotties/welcome_chat.json',
              width: 200, height: 200),
          const SizedBox(height: 20),
          Text(
            'Ξεκινήστε μια νέα συζήτηση με τον/την ${widget.chatPartnerName}!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  void _markMessagesAsRead(String chatId) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    var querySnapshot = await FirebaseFirestore.instance
        .collection('chats/$chatId/messages')
        .where('senderId', isNotEqualTo: currentUser.uid)
        .where('read', isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      doc.reference.update({'read': true});
    }
  }

  Widget _buildMessageInputField(String chatId, BuildContext context) {
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
              icon: const Icon(Icons.send),
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
    String senderId = messageData['senderId'] ?? '';
    if (senderId.isEmpty) {
      return const SizedBox.shrink(); // Placeholder for invalid senderId
    }
    bool isSentByMe = senderId == getCurrentUserId();

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(senderId).get(),
      builder: (context, snapshot) {
        String imageUrl = defaultAvatarUrl; // Default URL
        if (snapshot.hasData && snapshot.data!.data() is Map<String, dynamic>) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          imageUrl = userData['imageUrl'] ?? defaultAvatarUrl;
        }

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
            child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isSentByMe) // Avatar for received messages
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 13,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messageData['text'] ?? 'Missing text',
                          style: TextStyle(
                              color: isSentByMe ? Colors.white : Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            messageData['timestamp'] != null
                                ? DateFormat('hh:mm a').format(
                                    (messageData['timestamp'] as Timestamp)
                                        .toDate())
                                : 'Unknown time',
                            style: const TextStyle(
                                fontSize: 10,
                                color: Color.fromARGB(248, 247, 252, 74)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSentByMe) // Read status for sent messages
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(
                        messageData['read'] ?? false
                            ? Icons.done_all
                            : Icons.done,
                        size: 16,
                        color: messageData['read'] ?? false
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendMessage(String chatId, String text) async {
    if (text.trim().isEmpty) return;

    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (currentUserId.isEmpty) {
      debugPrint("Error: No current user ID available for sending message.");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('chats/$chatId/messages')
          .add({
        'text': text,
        'senderId': currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("Message sent to chat ID: $chatId");
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }
}
