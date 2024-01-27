import 'package:flutter/material.dart';

import '../models/note_model.dart';

class CloudNoteBuilder extends StatelessWidget {
  final Widget Function(Note) buildNotes;
  const CloudNoteBuilder({super.key, required this.buildNotes});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: readNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          final notes = snapshot.data!;
          return ListView(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: notes.map(buildNotes).toList(),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
