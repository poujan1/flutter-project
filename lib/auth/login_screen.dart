import 'package:chat_app/auth/signup_screen.dart';
import 'package:chat_app/chat/chat_screen.dart';

import 'package:chat_app/main.dart';
import 'package:chat_app/utils/snacks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  _loginUser(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        Navigator.of(AppSettings.navigatorKey.currentContext!)
            .pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => const ChatScreen()),
                (route) => false);
        showSuccessSnack("Logged in successfully");
      } else {
        showErrorSnack("Something went wrong");
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnack(e.message.toString());
    } catch (e) {
      showErrorSnack(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.withOpacity(.4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Login Screen")),
      ),
      body: Card(
        margin: const EdgeInsets.all(20),
        elevation: 0.4,
        child: Form(
          key: _loginFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value != null &&
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                      return null;
                    } else {
                      return "Please enter a valid email.";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  controller: _passwordController,
                  validator: (value) {
                    if (value != null && value.length > 7) {
                      return null;
                    } else {
                      return "Password should be of minimum 8 characters.";
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_loginFormKey.currentState!.validate()) {
                    _loginUser(_emailController.text, _passwordController.text);
                  }
                },
                child: const Text(
                  "Login",
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const SizedBox(
                  height: 15,
                  child: Text(
                    "Don't have an account? Sign up.",
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
