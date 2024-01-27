import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realmnotes/firebase_options.dart';
import 'package:realmnotes/models/note_model.dart';
import 'package:realmnotes/models/share_info.dart';
import 'package:realmnotes/page_redirectors/auth.dart';
import 'package:realmnotes/provider.dart';
import 'setting_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(ShareInfoAdapter());

  await Hive.initFlutter();
  await Hive.openBox('notes');
  await Hive.openBox('settings');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final settingsBox = Hive.box('settings');
  var noteBox = Hive.box('notes');
  late var notes;

  void getAndSetData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('notes').get();
      notes = querySnapshot.docs.map(
        (e) {
          return Note(
              title: e['title'],
              date: e['date'],
              content: e['content'],
              localID: e['localID'],
              isUploaded: e['isUploaded'],
              noteID: e['noteID'],
              userUID: e['userUID'],
              sharedUsers: e['sharedUsers']);
        },
      );
      for (Note note in notes) {
        noteBox.put(note.localID, note);
      }
    } else {}
  }

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(selectedColorOption.notifier)
          .update((state) => settingsBox.get(1) ?? 'Purple');
      ref
          .read(selectedSizeOption.notifier)
          .update((state) => settingsBox.get(2) ?? 'Medium');
      ref
          .read(sortByOption.notifier)
          .update((state) => settingsBox.get(3) ?? 'Newest');
    });
    getAndSetData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: getFontSize(ref.watch(selectedSizeOption).toString()),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'SF',
            primarySwatch: Colors.deepPurple),
        home: const AuthPage(),
      ),
    );
  }
}
