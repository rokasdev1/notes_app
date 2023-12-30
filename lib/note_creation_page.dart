import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:realmnotes/note_model.dart';
import 'package:realmnotes/provider.dart';

class NoteCreationPage extends ConsumerStatefulWidget {
  const NoteCreationPage({super.key});

  @override
  ConsumerState<NoteCreationPage> createState() => _NoteCreationPageState();
}

class _NoteCreationPageState extends ConsumerState<NoteCreationPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final UndoHistoryController undoRedoController = UndoHistoryController();

  Color enabledStyle = Colors.white;
  Color disabledStyle = Colors.grey.shade800;

  late Box noteBox;
  @override
  void initState() {
    noteBox = Hive.box('notes');
    contentController.addListener(characterListen);
    Future.microtask(() => characterListen());
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    undoRedoController.dispose();
    contentController.removeListener(characterListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
        actions: [
          ValueListenableBuilder(
            valueListenable: undoRedoController,
            builder: (context, value, child) {
              return Row(
                children: [
                  IconButton(
                      splashRadius: 0.1,
                      onPressed: () =>
                          value.canUndo ? undoRedoController.undo() : null,
                      icon: Icon(
                        Icons.undo,
                        color: value.canUndo ? enabledStyle : disabledStyle,
                      )),
                  IconButton(
                      splashRadius: 0.1,
                      onPressed: () =>
                          value.canRedo ? undoRedoController.redo() : null,
                      icon: Icon(
                        Icons.redo,
                        color: value.canRedo ? enabledStyle : disabledStyle,
                      )),
                ],
              );
            },
          ),
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                    text:
                        '${titleController.text}\n${contentController.text}'));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    'Copied to clipboard',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey[900],
                ));
              },
              icon: const Icon(Icons.copy)),
          IconButton(
              onPressed: () {
                final newNote = Note(
                    title: titleController.text,
                    content: contentController.text,
                    date: DateTime.now().toString());
                noteBox.add(newNote);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: undoRedoController,
        builder: (context, value, child) {
          return Padding(
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
                      DateTime.now().toString().substring(0, 19),
                      style: const TextStyle(
                          color: Color.fromARGB(92, 238, 238, 238),
                          fontSize: 13),
                    ),
                    Text(
                      '   |   ${ref.watch(characterProvider)} characters',
                      style: const TextStyle(
                          color: Color.fromARGB(92, 238, 238, 238),
                          fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  undoController: undoRedoController,
                  controller: contentController,
                  style: const TextStyle(fontSize: 17),
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing',
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void characterListen() {
    int lengthAmount = contentController.text.length;

    ref.read(characterProvider.notifier).update((state) => lengthAmount);
  }
}
