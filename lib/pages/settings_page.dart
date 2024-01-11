import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realmnotes/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final settingsBox = Hive.box('settings');

  var colorOptions = ['Purple', 'Green', 'Blue', 'Red'];
  var fontSizeOptions = ['Small', 'Medium', 'Large'];
  var sortByOptions = ['Newest', 'Oldest'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 35),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(height: 20),
            const Text(
              'Style',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Color theme',
                style: TextStyle(fontSize: 17),
              ),
              trailing: DropdownButton(
                underline: const SizedBox(),
                value: ref.watch(selectedColorOption),
                borderRadius: BorderRadius.circular(30),
                icon: const Icon(Icons.swap_vert_rounded),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                items: colorOptions.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  ref
                      .read(selectedColorOption.notifier)
                      .update((state) => value);
                  settingsBox.put(1, ref.read(selectedColorOption));
                },
              ),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Font size',
                style: TextStyle(fontSize: 17),
              ),
              trailing: DropdownButton(
                underline: const SizedBox(),
                value: ref.watch(selectedSizeOption),
                borderRadius: BorderRadius.circular(30),
                icon: const Icon(Icons.swap_vert_rounded),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                items: fontSizeOptions
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  ref
                      .read(selectedSizeOption.notifier)
                      .update((state) => value);
                  settingsBox.put(2, ref.read(selectedSizeOption));
                },
              ),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Sort by',
                style: TextStyle(fontSize: 17),
              ),
              trailing: DropdownButton(
                underline: const SizedBox(),
                value: ref.watch(sortByOption),
                borderRadius: BorderRadius.circular(30),
                icon: const Icon(Icons.swap_vert_rounded),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                items: sortByOptions
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  ref.read(sortByOption.notifier).update((state) => value);
                  settingsBox.put(3, ref.read(sortByOption));
                },
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(height: 20),
            const Text(
              'Other',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse('https://github.com/rokasdev1'));
              },
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Privacy policy',
                style: TextStyle(fontSize: 17),
              ),
              trailing: const Icon(Icons.arrow_right),
            ),
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Log out',
                style: TextStyle(fontSize: 17, color: Colors.red),
              ),
              trailing: const Icon(Icons.logout, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
