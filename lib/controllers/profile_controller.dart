import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  QueryDocumentSnapshot? snapshotData;
  var profileImagePath = "".obs;

  var profileImageLink = "".obs;

  var isLoading = false.obs;

  // text Controller

  var nameController = TextEditingController();
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  // shop controllers
  var shopNameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopWebController = TextEditingController();
  var shopDescController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) {
        return null;
      } else {
        profileImagePath.value = img.path;
      }
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var fileName = basename(profileImagePath.value);
    var destination = 'images/${currentUser!.uid}/$fileName';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImagePath.value));
    profileImageLink.value = await ref.getDownloadURL();
  }

  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(vendorsCollections).doc(currentUser!.uid);
    await store.set(
        {'vendor_name': name, 'password': password, 'imageUrl': imgUrl},
        SetOptions(merge: true));
    isLoading(false);
  }

  changeAuthPassword({email, password, newPassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newPassword);
    }).catchError((error) {
      print(error.toString());
    });
  }

  updateShop({shopName, shopAddress, shopMobile, shopWeb, shopDesc}) async {
    var store = firestore.collection(vendorsCollections).doc(currentUser!.uid);
    await store.set({
      'shop_name': shopName,
      'shop_address': shopAddress,
      'shop_mobile': shopMobile,
      'shop_website': shopWeb,
      'shop_desc': shopDesc
    }, SetOptions(merge: true));
    isLoading(false);
  }
}
