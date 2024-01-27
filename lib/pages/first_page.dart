import 'package:flutter/material.dart';
import 'package:realmnotes/pages/login_page.dart';
import 'package:realmnotes/pages/register_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(12, 1, 43, 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(12, 1, 43, 1),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                child: Image.asset('assets/images/logo.png'),
              ),
              const Text(
                'Faster and safer notes for you',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
