import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realmnotes/provider.dart';
import 'package:realmnotes/setting_services.dart';

class LoginPage extends ConsumerStatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

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
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No acccount? '),
          GestureDetector(
            onTap: widget.onTap,
            child: Text(
              'Register instead',
              style: TextStyle(
                  color: getColorFromSettings(
                      ref.read(selectedColorOption).toString())),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const Text('Enter your credentials'),
            const SizedBox(height: 80),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  border: const OutlineInputBorder(),
                  hintText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  border: const OutlineInputBorder(),
                  hintText: 'Password'),
            ),
            Text(ref.watch(errorMessageProvider).toString()),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signUserIn,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: getColorFromSettings(
                      ref.watch(selectedColorOption).toString()),
                ),
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
