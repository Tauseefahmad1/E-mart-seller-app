import 'package:emart_seller/const/firebase_constants.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getuserName();
  }

  var navIndex = 0.obs;
  var username = "";

  getuserName() async {
    var n = await firestore
        .collection(vendorsCollections)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['vendor_name'];
      }
    });
    username = n;
  }
}
