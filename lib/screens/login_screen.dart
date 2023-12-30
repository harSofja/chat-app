import 'package:chat_app/screens/forgot_password_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Σύνδεση',
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
          )),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/chat_logo.png',
                      width: 100.0,
                      height: 50.0,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: Theme.of(context).textTheme.bodyLarge,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).colorScheme.onSurface,
                        ), // Email icon
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Το email που πληκτρολογήσατε δεν είναι έγκυρο';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Σύνθημα',
                        labelStyle: Theme.of(context).textTheme.bodyLarge,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Το σύνθημα πρέπει να αποτελείτε τουλάχιστον από 6 χαρακτήρες';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Ξεχάσατε το σύνθημα;',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true; // Start loading
                            });
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                    context, '/chatList');
                              }
                            } on FirebaseAuthException catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    content: Text(
                                      e.message ??
                                          'Το email ή ο κωδικός πρόσβασης είναι λάθος.',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } finally {
                              if (context.mounted) {
                                setState(() {
                                  _isLoading = false; // Stop loading
                                });
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Σύνδεση',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        'Δεν έχετε λογαριασμό; Αποκτήστε έναν πατώντας εδώ!',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return const Color(0xFF427D9D); // Color when checkbox is selected
    }
    return const Color(0xFF164863); // Default color
  }
}
