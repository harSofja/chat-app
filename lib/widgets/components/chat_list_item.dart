import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  final String chatPartnerName;
  final String lastMessage;
  final String imageUrl;
  final String timestamp;
  final int unreadMessages;

  const ChatListItem({
    super.key,
    required this.chatPartnerName,
    required this.lastMessage,
    required this.imageUrl,
    required this.timestamp,
    this.unreadMessages = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      elevation: 3, // Shadow effect
      margin: EdgeInsets.symmetric(
          horizontal: 10, vertical: 5), // Spacing around the card
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16, vertical: 10), // Padding inside the ListTile
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(chatPartnerName,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(lastMessage),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(timestamp, style: TextStyle(color: Colors.grey, fontSize: 12)),
            if (unreadMessages > 0)
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$unreadMessages',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        onTap: () {
          // Action on tap (Navigate to chat screen)
        },
      ),
    );
  }
}
