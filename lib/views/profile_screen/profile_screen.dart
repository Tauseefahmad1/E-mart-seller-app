import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/firebase_constants.dart';
import 'package:emart_seller/controllers/auth_controller.dart';
import 'package:emart_seller/controllers/profile_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/auth_screen/login_screen.dart';
import 'package:emart_seller/views/messages_screen/messages_screen.dart';
import 'package:emart_seller/views/profile_screen/edit_profileScreen.dart';
import 'package:emart_seller/views/shop_screen/shopp_settings_screen.dart';
import 'package:emart_seller/views/sliders_screen/slider_screen.dart';
import 'package:emart_seller/views/widgets/appBar_widget.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
        backgroundColor: red,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: boldText(text: settings, size: 16.0),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => EditProfileScreen(
                        username: controller.snapshotData!['vendor_name'],
                      ));
                },
                icon: Icon(Icons.edit)),
            TextButton(
              onPressed: () async {
                await Get.find<AuthController>().signoutMethod(context);
                Get.offAll(() => LoginScreen());
              },
              child: normalText(text: logout),
            )
          ],
        ),
        body: StreamBuilder(
          stream: StoreServices.getProfile(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(white),
                ),
              );
            } else {
              controller.snapshotData = snapshot.data!.docs[0];
              return Column(
                children: [
                  ListTile(
                    leading: controller.snapshotData!['imageUrl'] == ''
                        ? Image.asset(
                            imgProduct,
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make()
                        : Image.network(
                            controller.snapshotData!['imageUrl'],
                            width: 100,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                    title: boldText(
                        text: "${controller.snapshotData!['vendor_name']}"),
                    subtitle: normalText(
                        text: "${controller.snapshotData!['email']}"),
                  ),
                  const Divider(),
                  10.heightBox,
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: List.generate(
                          profileButtonsIcons.length,
                          (index) => ListTile(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Get.to(() => ShopSettings());
                                    break;
                                  case 1:
                                    Get.to(() => MessagesScreen());
                                    break;
                                  case 2:
                                    Get.to(() => SlidersScreen());
                                }
                              },
                              leading: Icon(
                                profileButtonsIcons[index],
                                color: Colors.white,
                              ),
                              title: normalText(
                                  text: profileButtonsTitles[index]))),
                    ),
                  )
                ],
              );
            }
          },
        ));
  }
}
