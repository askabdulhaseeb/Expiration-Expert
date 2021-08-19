import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseAPI {
  static const String _collection = 'admins';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  Future<DocumentSnapshot<Map<String, dynamic>>> getInfo(
      {required String uid}) async {
    return _instance.collection(_collection).doc(uid).get();
  }
}
