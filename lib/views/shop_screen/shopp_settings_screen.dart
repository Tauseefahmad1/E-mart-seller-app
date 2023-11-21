import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/strings.dart';
import 'package:emart_seller/controllers/profile_controller.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: red,
          appBar: AppBar(
            title: boldText(text: shopSettings, size: 16.0, color: white),
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
                        await controller.updateShop(
                            shopAddress: controller.shopAddressController.text,
                            shopName: controller.shopNameController.text,
                            shopMobile: controller.shopMobileController.text,
                            shopWeb: controller.shopWebController.text,
                            shopDesc: controller.shopDescController.text);

                        VxToast.show(context,
                            msg: "Shop Updated Successfully !!!");
                      },
                      child: normalText(text: save, color: white),
                    )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                customTextField(
                    controller: controller.shopNameController,
                    label: "Shop Name",
                    hint: " Enter Your Shop Name",
                    isDesc: false),
                10.heightBox,
                customTextField(
                    controller: controller.shopAddressController,
                    label: "Address",
                    hint: " Your Shop Address",
                    isDesc: false),
                10.heightBox,
                customTextField(
                    controller: controller.shopMobileController,
                    label: "Mobile Number",
                    hint: "Please Enter Your Mobile Number",
                    isDesc: false),
                10.heightBox,
                customTextField(
                    controller: controller.shopWebController,
                    label: "Sites Links",
                    hint: "Enter Your Urls...",
                    isDesc: false),
                10.heightBox,
                customTextField(
                    controller: controller.shopDescController,
                    isDesc: true,
                    label: "Description",
                    hint: "Enter Shop Description")
              ],
            ),
          ),
        ));
  }
}
