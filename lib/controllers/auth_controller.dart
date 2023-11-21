import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:emart_seller/const/firebase_constants.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // loginMethod

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // store data method

  storeUserData({name, password, email}) async {
    DocumentReference store =
        await firestore.collection(vendorsCollections).doc(currentUser!.uid);
    store.set({
      "name": name,
      "password": password,
      "email": email,
      "imageUrl": '',
      "id": currentUser!.uid,
      "cart_count": "00",
      "order_count": "00"
    });
  }

  // signOut Method

  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
