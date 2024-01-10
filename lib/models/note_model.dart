import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? content;

  @HiveField(2)
  late String? date;

  @HiveField(3)
  int? localID;

  @HiveField(4)
  bool? isUploaded;

  @HiveField(5)
  String? noteID;

  @HiveField(6)
  String? userUID;

  @HiveField(7)
  List? sharedUsers;

  Note({
    required this.title,
    required this.content,
    this.date,
    required this.localID,
    required this.isUploaded,
    required this.noteID,
    required this.userUID,
    required this.sharedUsers,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'date': date,
        'localID': localID,
        'noteID': noteID,
        'userUID': userUID,
        'sharedUsers': sharedUsers,
      };

  static Note fromJson(Map<String, dynamic> json) => Note(
      title: json['title'],
      content: json['content'],
      date: json['date'],
      localID: json['localID'],
      isUploaded: json['isUploaded'],
      noteID: json['noteID'],
      userUID: json['userUID'],
      sharedUsers: json['sharedUsers']);
}

Stream<List<Note>> readNotes() =>
    FirebaseFirestore.instance.collection('notes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());

Future<void> uploadNote(Note note) async {
  final docNote =
      FirebaseFirestore.instance.collection('notes').doc(note.noteID);

  final json = note.toJson();
  await docNote.set(json);
}
