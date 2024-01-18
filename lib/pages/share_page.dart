import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  String searchValue = '';
  String currentUserUID = FirebaseAuth.instance.currentUser!.uid.toString();

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
            List<String> nameSuggestions = [];

            for (UserClass user in users) {
              nameSuggestions.add(user.name);
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  child: EasySearchBar(
                    title: const Text('Search'),
                    onSuggestionTap: (data) {
                      UserClass selectedUser = users.firstWhere(
                          (user) => user.name == data,
                          orElse: () => UserClass(
                              email: '',
                              imageUrl: '',
                              name: '',
                              uid: '',
                              isChecked: false));
                      bool isCurrentUserShared =
                          widget.note.sharedUsers!.any((e) {
                        return selectedUser.uid == currentUserUID;
                      });
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: const Color.fromRGBO(12, 1, 43, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          NetworkImage(selectedUser.imageUrl)),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  selectedUser.name,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  selectedUser.email,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 30),
                                isCurrentUserShared == true
                                    ? Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade800),
                                        child: const Text(
                                            'This note has already been shared'),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Edit allowed:'),
                                          CheckboxWidget(user: selectedUser),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                              onPressed: () {
                                                shareNote(
                                                    selectedUser.uid,
                                                    selectedUser.isChecked
                                                        .toString());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              )),
                                              child: const Text(
                                                'Share',
                                                style: TextStyle(fontSize: 16),
                                              )),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    suggestionBuilder: (data) {
                      UserClass selectedUser = users.firstWhere(
                          (user) => user.name == data,
                          orElse: () => UserClass(
                              email: '',
                              imageUrl: '',
                              name: '',
                              uid: '',
                              isChecked: false));
                      return ListTile(
                        title: Text(selectedUser.name),
                        subtitle: Text(selectedUser.email),
                      );
                    },
                    onSearch: (p0) => searchValue = p0,
                    suggestions: nameSuggestions,
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget buildUsers(UserClass user, Note note) {
    String currentUserUID = FirebaseAuth.instance.currentUser!.uid.toString();
    bool isCurrentUserShared = note.sharedUsers!.any((e) {
      return user.uid == currentUserUID;
    });
    if (isCurrentUserShared == true) {
      return const SizedBox();
    } else if (isCurrentUserShared == false) {
      return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit'),
            CheckboxWidget(user: user),
          ],
        ),
        onTap: () {
          setState(() {
            shareNote(user.uid, user.isChecked ? 'edit' : 'view');
          });
        },
      );
    } else {
      return const CircularProgressIndicator();
    }
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
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
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
