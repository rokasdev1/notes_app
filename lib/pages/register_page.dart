import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realmnotes/provider.dart';
import 'package:realmnotes/setting_services.dart';

import '../models/user_model.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  signUserUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final user = UserClass(
          name: nameController.text,
          imageUrl:
              'https://cdn.icon-icons.com/icons2/1369/PNG/512/-person_90382.png',
          email: emailController.text,
          uid: FirebaseAuth.instance.currentUser!.uid);
      await createUser(user);
    } on FirebaseAuthException catch (e) {
      ref.read(errorMessageProvider.notifier).update((state) => e.message!);
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(12, 1, 43, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(12, 1, 43, 1),
        title: const Text('Sign up'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Text(
        'By registering, you accept our EULA',
        style: TextStyle(color: Colors.deepPurple.shade100),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Name',
              style: TextStyle(color: Colors.deepPurple.shade200, fontSize: 12),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade700),
                fillColor: Colors.deepPurple.shade900,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Text(
              'Password',
              style: TextStyle(color: Colors.deepPurple.shade200, fontSize: 12),
            ),
            const SizedBox(height: 5),
            TextField(
              obscureText: true,
              controller: passwordController,
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
                onPressed: signUserUp,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.deepPurple.shade600),
                child: const Text(
                  'Register',
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
