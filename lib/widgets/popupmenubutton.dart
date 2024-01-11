import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realmnotes/models/note_model.dart';
import 'package:realmnotes/pages/share_page.dart';
import 'package:realmnotes/widgets/app_pop_up.dart';
import 'package:realmnotes/widgets/desktop_context_menu.dart';
import '../provider.dart';
import '../setting_services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PopupMenuButtonWidget extends ConsumerStatefulWidget {
  final Box noteBox;
  final int index;
  final Note note;
  const PopupMenuButtonWidget(
      {super.key,
      required this.noteBox,
      required this.index,
      required this.note});

  @override
  ConsumerState<PopupMenuButtonWidget> createState() => _PopupMenuButtonState();
}

class _PopupMenuButtonState extends ConsumerState<PopupMenuButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return DesktopPopUp(
      menuChildren: [
        DesktopMenuItem(
          color: Colors.white,
          title: 'Delete',
          icon: Icons.delete_outline,
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                      title: const Text("Are you sure?"),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () async {
                            if (widget.note.isUploaded == true) {
                              widget.noteBox.delete(widget.note.localID ?? 0);
                              await FirebaseFirestore.instance
                                  .collection('notes')
                                  .doc(widget.note.noteID.toString())
                                  .delete();
                            } else {
                              widget.noteBox.delete(widget.note.localID ?? 0);
                            }
                            Navigator.pop(context);
                          },
                          child: const Text("No"),
                        ),
                        CupertinoDialogAction(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ));
          },
        ),
        widget.note.isUploaded == false
            ? DesktopMenuItem(
                color: Colors.white,
                title: 'Upload',
                icon: Icons.cloud_outlined,
                onTap: () async {
                  var note = Note(
                      title: widget.note.title,
                      content: widget.note.content,
                      date: widget.note.date,
                      localID: widget.note.localID,
                      isUploaded: true,
                      noteID: widget.note.noteID,
                      userUID: widget.note.userUID,
                      sharedUsers: widget.note.sharedUsers);
                  await widget.noteBox.put(widget.note.localID, note);
                  await uploadNote(note);
                },
              )
            : const SizedBox(),
        widget.note.isUploaded == true
            ? DesktopMenuItem(
                color: Colors.white,
                title: 'Share',
                icon: Icons.ios_share,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SharePage(
                          note: widget.note,
                        ),
                      ));
                },
              )
            : const SizedBox(),
      ],
      child: const Icon(Icons.more_vert),
    );
  }
}
