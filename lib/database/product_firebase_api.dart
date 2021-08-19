import 'dart:io';
import 'user_local_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../model/product.dart';
import '../../utilities/custom_toast.dart';

class ProductFirebaseAPI {
  static const String _collection = 'products';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  Future<String?> uploadImage(File file, String pid) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref('product/${UserLocalData.getUserUID}-$pid');
      final UploadTask task = ref.putFile(file);
      if (task == null) return null;
      final TaskSnapshot snapshot = await task.whenComplete(() {});
      final String urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    } on FirebaseException catch (e) {
      CustomToast.errorToast(message: e.toString());
      return null;
    }
  }

  Future<void> addProduct({required Product product}) async {
    await _instance
        .collection(_collection)
        .doc(product.pid)
        .set(product.toMap())
        .catchError((dynamic e) {
      CustomToast.errorToast(message: e.toString());
    });
  }

  Future<void> updateProduct({required Product product}) async {
    await _instance
        .collection(_collection)
        .doc(product.pid)
        .update(product.toMap())
        .catchError((dynamic e) {
      CustomToast.errorToast(message: e.toString());
    });
  }

  Future<bool> isProductIDAvailable({required String pid}) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_collection).doc(pid).get();
    if (doc.exists) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Product>> getAllProducts() async {
    List<Product> product = [];
    final QuerySnapshot<Map<String, dynamic>> docs =
        await _instance.collection(_collection).get();
    for (int i = 0; i < docs.docs.length; i++) {
      product.add(Product.fromDocument(docs.docs[i]));
    }
    return product;
  }
}
