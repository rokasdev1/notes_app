import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realmnotes/pages/login_page.dart';
import '../pages/register_page.dart';
import '../provider.dart';

class LoginOrRegister extends ConsumerWidget {
  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void togglePages() {
      ref.read(showLoginPage.notifier).update(
          (state) => !(ref.watch(showLoginPage as ProviderListenable<bool>)));
    }

    if (ref.read(showLoginPage) == true) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
