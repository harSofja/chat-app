import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(decoration: InputDecoration(labelText: 'Email')),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                // Implement login logic
              },
            ),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () {
                // Implement sign-up logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
