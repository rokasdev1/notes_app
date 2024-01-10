import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realmnotes/models/share_info.dart';
import 'package:realmnotes/models/user_model.dart';

import '../models/note_model.dart';

class SharePage extends StatefulWidget {
  final Note note;
  const SharePage({super.key, required this.note});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final Box noteBox = Hive.box('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromRGBO(7, 7, 11, 1.0),
        elevation: 0,
        title: const Text(
          'Users',
          style: TextStyle(fontSize: 40),
        ),
      ),
      body: StreamBuilder(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              children: users.map(buildUsers).toList(),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget buildUsers(UserClass user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: CheckboxWidget(user: user),
      onTap: () {
        shareNote(user.uid, user.isChecked ? 'edit' : 'view');
      },
    );
  }

  void shareNote(String uid, String shareLevel) async {
    try {
      widget.note.sharedUsers!
          .add(ShareInfo(userUID: uid, shareLevel: shareLevel));
      await noteBox.put(widget.note.localID, widget.note);

      List sharedUsersMap = widget.note.sharedUsers!
          .map((shareInfo) => shareInfo.toJson())
          .toList();
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.note.noteID)
          .update({'sharedUsers': sharedUsersMap});
    } catch (error) {
      print(error);
    }
  }
}

class CheckboxWidget extends StatefulWidget {
  UserClass user;
  CheckboxWidget({super.key, required this.user});

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.user.isChecked,
      onChanged: (value) {
        print(widget.user.isChecked);
        setState(() {
          widget.user.isChecked = value ?? false;
        });
      },
    );
  }
}
