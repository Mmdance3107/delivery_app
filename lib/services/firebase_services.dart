// ignore_for_file: avoid_function_literals_in_foreach_calls, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static String getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  static CollectionReference productsRef =
      FirebaseFirestore.instance.collection('Products');
  static CollectionReference usersRef = FirebaseFirestore.instance.collection(
      'Users'); // User -> UserID(document) -> Cart -> ProductID(document)

  static Future<void> addSearchFields() async {
    FirebaseServices.productsRef.get().then(
          (value) => value.docs.forEach(
            (element) {
              FirebaseServices.productsRef.doc(element.id).set(
                {'search': '${element['name']}'.toLowerCase()},
                SetOptions(merge: true),
              );
            },
          ),
        );
  }
}
