import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiration_expert_admin/database/auth.dart';
import 'package:expiration_expert_admin/database/user_local_data.dart';
import 'package:expiration_expert_admin/model/app_user.dart';
import 'package:expiration_expert_admin/utilities/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserFirebaseAPI {
  static const String _collection = 'admins';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  Future<DocumentSnapshot<Map<String, dynamic>>> getInfo(
      {required String uid}) async {
    return _instance.collection(_collection).doc(uid).get();
  }

  Future<String?> uploadImage(File file, String uid) async {
    try {
      final Reference ref = FirebaseStorage.instance.ref('admins/$uid');
      final UploadTask task = ref.putFile(file);
      final TaskSnapshot snapshot = await task.whenComplete(() {});
      final String urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    } on FirebaseException catch (e) {
      CustomToast.errorToast(message: e.toString());
      return null;
    }
  }

  Future<String?> addUser({required AppUser user}) async {
    await _instance.collection(_collection).doc(user.uid).set(user.toMap());
    return user.uid;
  }
}
