import 'dart:io';

import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/strings.dart';
import 'package:emart_seller/controllers/profile_controller.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  final String? username;
  const EditProfileScreen({Key? key, this.username}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.put(ProfileController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.nameController.text = widget.username!;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: red,
          appBar: AppBar(
            title: boldText(text: editProfile, size: 16.0, color: white),
            actions: [
              controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(white),
                      ),
                    )
                  : TextButton(
                      onPressed: () async {
                        controller.isLoading(true);

                        // if image is selected

                        if (controller.profileImagePath.value.isNotEmpty) {
                          await controller.uploadProfileImage();
                        } else {
                          controller.profileImageLink.value =
                              controller.snapshotData!['imageUrl'];
                        }
                        // if old pass matches with database

                        if (controller.snapshotData!['password'] ==
                            controller.oldPasswordController.text) {
                          await controller.changeAuthPassword(
                            email: controller.snapshotData!['email'],
                            password: controller.oldPasswordController.text,
                            newPassword: controller.newPasswordController.text,
                          );

                          await controller.updateProfile(
                              imgUrl: controller.profileImageLink.value,
                              name: controller.nameController.text,
                              password: controller.newPasswordController.text);
                          VxToast.show(context,
                              msg: "Profile Updated Successfully");
                        } else if (controller
                                .oldPasswordController.text.isEmptyOrNull &&
                            controller
                                .newPasswordController.text.isEmptyOrNull) {
                          await controller.updateProfile(
                              imgUrl: controller.profileImageLink.value,
                              name: controller.nameController.text,
                              password: controller.snapshotData!['password']);
                          VxToast.show(context,
                              msg: "Profile Updated Successfully");
                        } else {
                          VxToast.show(context, msg: "Some error Occured !!!");
                          controller.isLoading(false);
                        }
                      },
                      child: normalText(text: save, color: white),
                    )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(9.0),
            child: Column(
              children: [
                // if data image Url and controller path is empty
                controller.snapshotData!['imageUrl'] == '' &&
                        controller.profileImagePath.value.isEmpty
                    ? Image.asset(
                        imgProduct,
                        width: 80,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    // if data image is not empty but controller is
                    : controller.snapshotData!['imageUrl'] != "" &&
                            controller.profileImagePath.value.isEmpty
                        ? Image.network(
                            controller.snapshotData!['imageUrl'],
                            width: 80,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make()

                        // if both are empty
                        : Image.file(
                            File(
                              controller.profileImagePath.value,
                            ),
                            width: 80,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                10.heightBox,
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: red),
                    onPressed: () {
                      controller.changeImage(context);
                    },
                    child: normalText(text: "Change Image", color: white)),
                10.heightBox,
                Divider(
                  color: fontGrey,
                ),
                customTextField(
                    label: "User Name",
                    hint: "eg . CoolDudes.",
                    isDesc: false,
                    controller: controller.nameController),
                30.heightBox,
                Align(
                    alignment: Alignment.centerLeft,
                    child: boldText(text: "Change Your Password")),
                10.heightBox,
                customTextField(
                    label: password,
                    hint: passwordHint,
                    isDesc: false,
                    controller: controller.oldPasswordController),
                10.heightBox,
                customTextField(
                    label: confirmPass,
                    hint: passwordHint,
                    isDesc: false,
                    controller: controller.newPasswordController),
              ],
            ),
          ),
        ));
  }
}
