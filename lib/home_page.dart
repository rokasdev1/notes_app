import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realmnotes/note_creation_page.dart';
import 'package:realmnotes/note_details_page.dart';

import 'note_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box noteBox;

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
        actions: const [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoteCreationPage(),
              ));
        },
        backgroundColor: const Color.fromRGBO(45, 31, 242, 1.0),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
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
                int reversedIndex = noteBox.length - 1 - index;
                Note note = noteBox.getAt(reversedIndex)!;
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Colors.black,
                          Color.fromRGBO(45, 31, 242, 1.0),
                        ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailsPage(
                              noteInfo: note,
                              index: index,
                            ),
                          ));
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
                                  backgroundColor:
                                      const Color.fromRGBO(45, 31, 242, 1),
                                  title: const Text('Are you sure?'),
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
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Color.fromRGBO(99, 87, 255, 1),
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
