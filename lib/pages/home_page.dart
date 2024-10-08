import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realmnotes/models/user_model.dart';
import 'package:realmnotes/pages/cloud_note_edit.dart';
import 'package:realmnotes/pages/note_creation_page.dart';
import 'package:realmnotes/pages/note_details_page.dart';
import 'package:realmnotes/pages/settings_page.dart';
import 'package:realmnotes/provider.dart';
import 'package:realmnotes/widgets/cloud_note_builder.dart';
import 'package:realmnotes/widgets/popupmenubutton.dart';

import '../models/note_model.dart';
import '../setting_services.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Box noteBox;
  final settingsBox = Hive.box('settings');

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
        bool isNoteOwned =
            note.userUID == FirebaseAuth.instance.currentUser!.uid;
        if (isNoteOwned == true) {
          noteBox.put(note.localID, note);
        } else {}
      }
    } else {}
  }

  @override
  void initState() {
    noteBox = Hive.box('notes');
    getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
        elevation: 0,
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 40),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  PageTransition(
                      child: const SettingsPage(),
                      type: PageTransitionType.fade)),
              icon: const Icon(Icons.settings))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: const NoteCreationPage(),
                    type: PageTransitionType.bottomToTop));
          },
          backgroundColor:
              getColorFromSettings(ref.watch(selectedColorOption).toString()),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonsTabBar(
                backgroundColor: getColorFromSettings(
                    ref.watch(selectedColorOption).toString()),
                radius: 20,
                height: 40,
                borderWidth: 1,
                unselectedBackgroundColor: Colors.grey.shade900,
                borderColor: Colors.white,
                contentPadding: const EdgeInsets.all(10),
                unselectedLabelStyle:
                    const TextStyle(color: Colors.white, fontSize: 12),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                tabs: const [
                  Tab(
                    text: 'My notes',
                  ),
                  Tab(
                    text: 'Shared with me',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: TabBarView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    ValueListenableBuilder(
                      valueListenable: noteBox.listenable(),
                      builder: (context, value, child) {
                        if (noteBox.length == 0) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Text(
                              'No notes yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ));
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: noteBox.length,
                            itemBuilder: (context, index) {
                              Note note = noteBox.getAt(getSortOptions(
                                  ref.watch(sortByOption).toString(),
                                  index,
                                  noteBox))!;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                      colors: [
                                        Colors.black,
                                        getColorFromSettings(ref
                                            .watch(selectedColorOption)
                                            .toString())
                                      ]),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: NoteDetailsPage(
                                              noteInfo: note,
                                              index: index,
                                            ),
                                            type: PageTransitionType
                                                .rightToLeft));
                                  },
                                  title: Text(note.title ?? ''),
                                  subtitle:
                                      Text(note.date?.substring(0, 19) ?? ''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      note.isUploaded == true
                                          ? const Icon(
                                              Icons.cloud_done_outlined,
                                              size: 20,
                                            )
                                          : const Icon(
                                              Icons.cloud_off,
                                              size: 20,
                                            ),
                                      const SizedBox(width: 15),
                                      PopupMenuButtonWidget(
                                        noteBox: noteBox,
                                        index: index,
                                        note: note,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    CloudNoteBuilder(buildNotes: buildNotes),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotes(Note note) {
    print(note.sharedUsers!);
    String currentUserUID = FirebaseAuth.instance.currentUser!.uid.toString();
    bool isCurrentUserShared = note.sharedUsers!.any((e) {
      return e['userUID'] == currentUserUID;
    });
    bool isEditAllowedForUser = note.sharedUsers!.any((e) {
      if (isCurrentUserShared && e['shareLevel'] == 'view') {
        return false;
      } else if (isCurrentUserShared && e['shareLevel'] == 'edit') {
        return true;
      } else {
        return false;
      }
    });
    if (isCurrentUserShared) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Colors.black,
                getColorFromSettings(ref.watch(selectedColorOption).toString())
              ]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: StreamBuilder(
            stream: readUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Check your network'),
                );
              } else if (snapshot.hasData) {
                final users = snapshot.data!;
                UserClass author =
                    users.firstWhere((element) => element.uid == note.userUID);
                return ListTile(
                  onTap: () {
                    if (isEditAllowedForUser == true) {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: CloudNotePage(noteInfo: note),
                              type: PageTransitionType.rightToLeft));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.grey.shade900,
                          title: Text(note.title ?? ''),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(note.date?.substring(0, 10) ?? ''),
                            )
                          ],
                          content: Text(note.content ?? ''),
                        ),
                      );
                    }
                  },
                  title: Text(note.title ?? ''),
                  subtitle: Text(note.date?.substring(0, 19) ?? ''),
                  trailing: SizedBox(
                    width: 45,
                    child: FittedBox(child: Text(author.name)),
                  ),
                );
              }
              return const CircularProgressIndicator();
            }),
      );
    } else {
      return const Center(
          child: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Text(
          'No notes found',
          style: TextStyle(color: Colors.grey),
        ),
      ));
    }
  }
}
