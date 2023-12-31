import 'dart:ui';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realmnotes/pages/note_creation_page.dart';
import 'package:realmnotes/pages/note_details_page.dart';
import 'package:realmnotes/pages/settings_page.dart';
import 'package:realmnotes/provider.dart';

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

  @override
  void initState() {
    noteBox = Hive.box('notes');
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
      body: ValueListenableBuilder(
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
              itemCount: noteBox.length,
              itemBuilder: (context, index) {
                Note note = noteBox.getAt(getSortOptions(
                    ref.watch(sortByOption).toString(), index, noteBox))!;
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Colors.black,
                          getColorFromSettings(
                              ref.watch(selectedColorOption).toString())
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
                              type: PageTransitionType.rightToLeft));
                    },
                    title: Text(note.title),
                    subtitle: Text(note.date?.substring(0, 19) ?? ''),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: getColorFromSettings(ref
                                      .watch(selectedColorOption)
                                      .toString()),
                                  title: const Text(
                                    'Are you sure?',
                                  ),
                                  content: IconButton(
                                      onPressed: () {
                                        noteBox.deleteAt(index);
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                      )),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: getColorFromSettings(
                              ref.watch(selectedColorOption).toString()),
                        )),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
