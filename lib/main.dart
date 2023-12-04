import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/styles/color_scheme.dart';
import 'package:chat_app/widgets/chat_list.dart';
import 'package:chat_app/widgets/components/drawer_screens/profile_screen.dart';
import 'package:chat_app/widgets/login%20_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData.from(
      colorScheme: colorScheme,
    ).copyWith(iconTheme: IconThemeData(color: colorScheme.primary));
    return MaterialApp(
      title: 'Chat App',
      theme: theme,
      home: StreamBuilder(
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
      ),
      routes: {
        '/chatList': (context) => const ChatListScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
