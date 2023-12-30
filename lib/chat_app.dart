import 'package:chat_app/screens/chat_list_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const ChatListScreen(); // User is signed in
          }
          return const LoginScreen(); // User is not signed in
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()), // Loading state
        );
      },
    );
  }
}
