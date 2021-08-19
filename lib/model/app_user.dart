import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.imageURL,
    required this.type,
  });
  factory AppUser.fromDocuments(DocumentSnapshot<Map<String, dynamic>> docs) {
    return AppUser(
      uid: docs.data()!['uid'].toString(),
      email: docs.data()!['email'].toString(),
      displayName: docs.data()!['displayName'].toString(),
      imageURL: docs.data()!['imageURL'].toString(),
      type: docs.data()!['type'].toString(),
    );
  }

  final String uid;
  final String email;
  final String displayName;
  final String imageURL;
  final String type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'imageURL': imageURL,
      'type': type,
    };
  }
}
