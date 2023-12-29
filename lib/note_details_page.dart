import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:realmnotes/provider.dart';

import 'note_model.dart';

class NoteDetailsPage extends ConsumerStatefulWidget {
  final noteInfo;
  final index;
  const NoteDetailsPage(
      {super.key, required this.noteInfo, required this.index});

  @override
  ConsumerState<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends ConsumerState<NoteDetailsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  late Box noteBox;
  @override
  void initState() {
    noteBox = Hive.box('notes');
    titleController.text = widget.noteInfo.title;
    contentController.text = widget.noteInfo.content;

    contentController.addListener(characterListen);
    Future.microtask(() => characterListen());
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    contentController.removeListener(characterListen);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(45, 31, 242, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        onPressed: () {
          final newNote = Note(
              title: titleController.text,
              content: contentController.text,
              date: DateTime.now().toString());
          noteBox.putAt(widget.index, newNote);
          Navigator.pop(context);
        },
        child: const Text('Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(height: 2, fontSize: 30),
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            Row(
              children: [
                Text(
                  widget.noteInfo.date.substring(0, 19),
                  style: const TextStyle(
                      color: Color.fromARGB(92, 238, 238, 238), fontSize: 13),
                ),
                Text(
                  '   -   ${ref.watch(characterProvider)} characters',
                  style: const TextStyle(
                      color: Color.fromARGB(92, 238, 238, 238), fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: 'Start typing',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  void characterListen() {
    int lengthAmount = contentController.text.length;

    ref.read(characterProvider.notifier).update((state) => lengthAmount);
  }
}
