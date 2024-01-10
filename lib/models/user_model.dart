import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserClass {
  final String name;
  final String imageUrl;
  final String email;
  late String uid;
  bool isChecked;

  // Add this field

  UserClass({
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.uid,
    this.isChecked = false,
    // Initialize this field with the URL of the image
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'imageUrl': imageUrl,
        'email': email,
        'uid': uid,
      };

  static UserClass fromJson(Map<String, dynamic> json) => UserClass(
        name: json['name'],
        imageUrl: json['imageUrl'],
        email: json['email'],
        uid: json['uid'],
      );
}

Stream<List<UserClass>> readUsers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserClass.fromJson(doc.data())).toList());

Future<void> createUser(UserClass user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
  user.uid = docUser.id;

  final json = user.toJson();
  await docUser.set(json);
}
