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
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(chatPartnerName),
      subtitle: Text(lastMessage),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(timestamp),
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
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () {
        // Action on tap (Navigate to chat screen)
      },
    );
  }
}
