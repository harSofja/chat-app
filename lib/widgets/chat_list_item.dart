import 'package:chat_app/screens/chat_window_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatListItem extends StatelessWidget {
  final String chatPartnerName;
  final String lastMessage;
  final String imageUrl;
  final Timestamp timestamp;
  final int unreadMessages;
  final String chatId;

  const ChatListItem({
    super.key,
    required this.chatPartnerName,
    required this.lastMessage,
    required this.imageUrl,
    required this.timestamp,
    this.unreadMessages = 0,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTimestamp(timestamp);
    String displayLastMessage =
        lastMessage.isEmpty ? 'Πείτε ένα γειά!' : lastMessage;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      elevation: 3, // Shadow effect
      margin:
          const EdgeInsets.symmetric(horizontal: 10), // Spacing around the card
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 5), // Padding inside the ListTile
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(chatPartnerName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(displayLastMessage),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(formattedTime,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12)),
            if (unreadMessages > 0)
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$unreadMessages',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12),
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatWindowScreen(
                        chatPartnerName: chatPartnerName,
                        chatId: chatId,
                      )));
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('M/dd  HH:mm').format(dateTime); // e.g., "3/12  04:00"
  }
}
