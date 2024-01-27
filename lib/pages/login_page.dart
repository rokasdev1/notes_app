import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realmnotes/provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      ref.read(errorMessageProvider.notifier).update((state) => e.message!);
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(12, 1, 43, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(12, 1, 43, 1),
        title: const Text('Log in'),
        centerTitle: true,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Email address',
              style: TextStyle(color: Colors.deepPurple.shade200, fontSize: 12),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade700),
                fillColor: Colors.deepPurple.shade900,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Password',
              style: TextStyle(color: Colors.deepPurple.shade200, fontSize: 12),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade700),
                fillColor: Colors.deepPurple.shade900,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              ref.watch(errorMessageProvider).toString(),
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signUserIn,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.deepPurple.shade600),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
