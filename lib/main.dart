import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/styles/color_scheme.dart';
import 'package:chat_app/widgets/chat_list.dart';
import 'package:chat_app/widgets/chat_window.dart';
import 'package:chat_app/widgets/login%20_screen.dart';
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
    ThemeData theme = ThemeData.from(colorScheme: colorScheme);
    return MaterialApp(
      title: 'Chat App',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/chatList': (context) => const ChatListScreen(),
        '/chatWindow': (context) => const ChatWindow(),
      },
    );
  }
}
