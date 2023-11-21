import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/firebase_constants.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore
        .collection(vendorsCollections)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  static getMessages(uid) {
    return firestore
        .collection(chatCollections)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }

  static getOrders(uid) {
    return firestore
        .collection(ordersCollections)
        .where("vendors", arrayContains: uid)
        .snapshots();
  }

  static getChatMessages(docId) {
    return firestore
        .collection(chatCollections)
        .doc(docId)
        .collection(messageCollections)
        .orderBy("created_on", descending: false)
        .snapshots();
  }

  static getProducts(uid) {
    return firestore
        .collection(productsCollections)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  Future<num> calculateTotalQuantity() async {
    num totalQuantity = 0;

    // Retrieve all documents from the 'products' collection
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    // Iterate through each document and sum the 'p_quantity' field
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      totalQuantity += (doc.data() as Map<String, dynamic>)['p_quantity'] ?? 0;
    }

    return totalQuantity;
  }

// Usage

// Usage
}
