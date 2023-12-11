import 'package:chat_app/widgets/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Καλώς ήρθες!',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 35),
              ),
              Image.asset(
                'assets/images/chat_logo.png',
                width: 200,
                height: 200,
              ), // Your logo here
              const SizedBox(height: 50), // Spacing
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to login screen
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Text(
                    'Έχω ήδη λογαριασμό',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacing
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    'Δεν έχω λογαριασμό, θέλω να δημιουργήσω',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
