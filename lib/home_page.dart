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
      body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ValueListenableBuilder(
            valueListenable: noteBox.listenable(),
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: noteBox.length,
                itemBuilder: (context, index) {
                  Note note = noteBox.getAt(index)!;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 132, 125, 227),
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
                            noteBox.deleteAt(index);
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
