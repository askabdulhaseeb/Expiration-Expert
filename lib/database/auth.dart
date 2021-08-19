import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_firebase_api.dart';
import '../../model/app_user.dart';
import '../../utilities/custom_toast.dart';

import 'user_local_data.dart';

class AuthMethod {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<User?> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final UserCredential result = await _auth
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      )
          .catchError((Object obj) {
        CustomToast.errorToast(message: obj.toString());
      });
      final User? user = result.user;
      assert(user != null);
      return user;
    } catch (signUpError) {
      CustomToast.errorToast(message: signUpError.toString());
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth
          .signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      )
          .catchError((Object obj) {
        CustomToast.errorToast(message: obj.toString());
      });
      final User? user = result.user;
      final DocumentSnapshot<Map<String, dynamic>> docs =
          await UserFirebaseAPI().getInfo(uid: user!.uid);
      final AppUser appUser = AppUser.fromDocuments(docs);
      UserLocalData().storeAppUserData(appUser: appUser);
      return user;
    } catch (signUpError) {
      CustomToast.errorToast(message: signUpError.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    UserLocalData.signout();
    await _auth.signOut();
  }
}
