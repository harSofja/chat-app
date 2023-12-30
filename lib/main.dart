import 'package:chat_app/chat_app.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/styles/color_scheme.dart';
import 'package:chat_app/screens/chat_list_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('first_launch') ?? true;

    if (firstLaunch) {
      await prefs.setBool('first_launch', false);
    }

    return firstLaunch;
  }

  bool firstLaunch = await isFirstLaunch();

  runApp(MaterialApp(
    title: 'Chat App',
    theme: ThemeData.from(colorScheme: colorScheme)
        .copyWith(iconTheme: IconThemeData(color: colorScheme.primary)),
    home: firstLaunch ? const SplashScreen() : const ChatApp(),
    routes: {
      '/chatList': (context) => const ChatListScreen(),
      '/login': (context) => const LoginScreen(),
      // Add other routes here
    },
  ));
}
