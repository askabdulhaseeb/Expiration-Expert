import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  Product({
    this.pid,
    this.priID,
    this.secID,
    this.name,
    this.imageURL,
    this.description,
    this.price,
    this.qty,
  });

  factory Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> docs) {
    return Product(
      pid: docs.data()!['pid'].toString(),
      priID: docs.data()!['priID'].toString(),
      secID: docs.data()!['secID'].toString(),
      name: docs.data()!['name'].toString(),
      imageURL: docs.data()!['imageURL'].toString(),
      description: docs.data()!['description'].toString(),
      price: double.parse(docs.data()!['price'].toString()),
      qty: int.parse(docs.data()!['qty'].toString()),
    );
  }
  String? pid;
  String? priID;
  String? secID;
  String? name;
  String? imageURL;
  String? description;
  double? price;
  int? qty;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pid': pid.toString().trim(),
      'priID': priID,
      'secID': secID,
      'name': name.toString().trim(),
      'imageURL': imageURL,
      'description': description.toString().trim(),
      'price': price,
      'qty': qty,
    };
  }
}
