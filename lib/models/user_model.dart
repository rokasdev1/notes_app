import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass {
  final String name;
  final String imageUrl;
  final String email;
  late String uid;

  // Add this field

  UserClass({
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.uid,
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

Future<void> createUser(UserClass user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
  user.uid = docUser.id;

  final json = user.toJson();
  await docUser.set(json);
}
