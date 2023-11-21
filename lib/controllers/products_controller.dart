import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/firebase_constants.dart';
import 'package:emart_seller/controllers/home_controller.dart';
import 'package:emart_seller/models/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ProductsController extends GetxController {
  // text controllers

  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pqunantityController = TextEditingController();

  var categoryList = <String>[].obs;
  var subCategoryList = <String>[].obs;
  var isLaoding = false.obs;

  List<Category> category = [];
  var pImagesLinks = [];

  var pImagesLinks1 = [];
  var pImagesLinks2 = [];
  var pImagesLinks3 = [];
  var thumbnailLinks = [];
  var ratings = ['5'];

  var pImageList = RxList<dynamic>.generate(3, (index) => null);
  var pVideoList = RxList<dynamic>.generate(3, (index) => null);
  var pImageList4 = List<dynamic>.generate(3, (index) => null);
  var pImageList1 = RxList<dynamic>.generate(3, (index) => null);
  var pImageList2 = RxList<dynamic>.generate(3, (index) => null);
  var pImageList3 = RxList<dynamic>.generate(3, (index) => null);

  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectedCOlorIndex = 0.obs;

  getCategories() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();
    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubCategoryList(cat) {
    subCategoryList.clear();

    var data = category.where((element) => element.name == cat).toList();
    for (var i = 0; i < data.first.subcategory.length; i++) {
      subCategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (img == null) {
        return;
      } else {
        pImageList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImages() async {
    pImagesLinks.clear();
    for (var item in pImageList) {
      if (item != null) {
        var fileName = p.basename(item.path);
        var destination = 'images/vendor/${currentUser!.uid}/$fileName';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks.add(n);
      }
    }
  }

  Future<void> uploadProduct(
      {required BuildContext context,
      required List<int> selectedColorIndexes}) async {
    var store = firestore.collection(productsCollections).doc();
    List selectedColorValues =
        selectedColorIndexes.map((index) => colorsList[index].value).toList();
    await store.set({
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_colors': FieldValue.arrayUnion(selectedColorValues),
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pqunantityController.text,
      'p_seller': Get.find<HomeController>().username,
      'p_rating': FieldValue.arrayUnion(ratings),
      "p_video": FieldValue.arrayUnion(thumbnailLinks),
      'vendor_id': currentUser!.uid,
      'featured_id': currentUser!.uid,
    });
    isLaoding(false);

    VxToast.show(context, msg: "Product uploaded");
  }

  addFeatured(docId) async {
    await firestore.collection(productsCollections).doc(docId).set(
        {"featured_id": currentUser!.uid, "is_featured": true},
        SetOptions(merge: true));
  }

  RemoveFeatured(docId) async {
    await firestore.collection(productsCollections).doc(docId).set(
        {"featured_id": '', "is_featured": false}, SetOptions(merge: true));
  }

  removeProduct(docId) async {
    await firestore.collection(productsCollections).doc(docId).delete();
  }

  // Experiment Section
//Slider Experiment

  pickImage1(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (img == null) {
        return;
      } else {
        pImageList1[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  pickImage2(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (img == null) {
        return;
      } else {
        pImageList2[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  pickImage3(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (img == null) {
        return;
      } else {
        pImageList3[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImagesSlider1() async {
    pImagesLinks1.clear();
    for (var item in pImageList1) {
      if (item != null) {
        var fileName = p.basename(item.path);
        var destination = 'images/slider1/${currentUser!.uid}/$fileName';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks1.add(n);
      }
    }
  }

  uploadImagesSlider2() async {
    pImagesLinks2.clear();
    for (var item in pImageList2) {
      if (item != null) {
        var fileName = p.basename(item.path);
        var destination = 'images/slider2/${currentUser!.uid}/$fileName';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks2.add(n);
      }
    }
  }

  uploadImagesSlider3() async {
    pImagesLinks3.clear();
    for (var item in pImageList3) {
      if (item != null) {
        var fileName = p.basename(item.path);
        var destination = 'images/slider3/${currentUser!.uid}/$fileName';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks3.add(n);
      }
    }
  }

  Future<void> uploadSliderImages(BuildContext context) async {
    var store = firestore.collection("sliders").doc();

    await store.set({
      'p_imgs1': FieldValue.arrayUnion(pImagesLinks1),
      'p_imgs2': FieldValue.arrayUnion(pImagesLinks2),
      'p_imgs3': FieldValue.arrayUnion(pImagesLinks3),
      'vendor_id': currentUser!.uid,
    });
    isLaoding(false);

    VxToast.show(context, msg: "Sliders are updated");
  }

// Edit product Expirement
  File? video;
  String? thumbnail;

  Future<void> videoPicker(index, context) async {
    try {
      final img = await ImagePicker().getVideo(source: ImageSource.gallery);
      if (img == null) {
        return;
      } else {
        // Get the application documents directory
        final appDocDir = await getApplicationDocumentsDirectory();

        // Create a new File object from the video path
        final videoFile = File(img.path);

        // Copy the video file to the directory
        final copiedVideoFile =
            await videoFile.copy(p.join(appDocDir.path, 'video$index.mp4'));

        // Store the video file in the controller list
        pVideoList[index] = copiedVideoFile;

        // Generate thumbnail
        final thumbnailPath = p.join(appDocDir.path, 'thumbnail$index.png');
        await VideoThumbnail.thumbnailFile(
          video: copiedVideoFile.path,
          thumbnailPath: thumbnailPath,
          imageFormat: ImageFormat.PNG,
          maxHeight: 200,
          quality: 100,
        );

        // Store the thumbnail path in the controller
        thumbnail = thumbnailPath;
        update();
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  Future<void> uploadVideo() async {
    thumbnailLinks.clear();

    // Upload video to Firebase Storage
    for (var item in pVideoList) {
      if (item != null) {
        var fileName = p.basename(item.path);
        var destination =
            'videos/${currentUser!.uid}/${DateTime.now()}.mp4/$fileName';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        thumbnailLinks.add(n);
      }
    }
  }

  Future<List<String>> uploadImagesEdit(List<File> imageList) async {
    List<String> imageUrls = [];

    for (var imageFile in imageList) {
      var fileName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageReference = FirebaseStorage.instance.ref().child(fileName);
      await storageReference.putFile(imageFile);

      var downloadUrl = await storageReference.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  Future<void> EditProduct({
    required BuildContext context,
    required String doc,
  }) async {
    var store = firestore.collection(productsCollections).doc(doc);

    List<File> castedPImageList = pImageList.cast<File>();

    List<String> pImagesLinks = await uploadImagesEdit(castedPImageList);

    var updateData = {
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pqunantityController.text,
    };

    var docSnapshot = await store.get();
    if (docSnapshot.exists) {
      await store.update(updateData);
    } else {
      await store.set(updateData, SetOptions(merge: true));
    }

    isLaoding(false);

    VxToast.show(context, msg: "Product updated");
  }
}
