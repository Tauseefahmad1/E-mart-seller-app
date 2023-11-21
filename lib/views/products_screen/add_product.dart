import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/strings.dart';
import 'package:emart_seller/controllers/products_controller.dart';
import 'package:emart_seller/views/products_screen/components/product_dropdown.dart';
import 'package:emart_seller/views/products_screen/components/product_images.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/our_button.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:velocity_x/velocity_x.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final selectedColorIndexes = <int>[].obs;
  late ProductsController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<ProductsController>();
  }

  /*@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.pnameController.text;
    controller.pdescController.text;
    controller.ppriceController.text;
    controller.pqunantityController.text;
    controller.categoryvalue.value;
    controller.subcategoryvalue.value;
    controller.pVideoList.value;
    controller.pImageList.value;
  }*/

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: red,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: darkGrey,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            controller.isLaoding.value
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(white),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      controller.isLaoding(true);
                      await controller.uploadImages();
                      await controller.uploadVideo();

                      await controller.uploadProduct(
                          context: context,
                          selectedColorIndexes:
                              selectedColorIndexes.value.toList());

                      Get.back();
                    },
                    child: normalText(text: save, color: white),
                  )
          ],
          title: boldText(text: "Add Product", color: fontGrey),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                customTextField(
                    hint: "eg. BMW",
                    label: "Product Name",
                    isDesc: false,
                    controller: controller.pnameController),
                10.heightBox,
                customTextField(
                    hint: "eg.Nice Product",
                    label: "Desc",
                    isDesc: true,
                    controller: controller.pdescController),
                10.heightBox,
                customTextField(
                    hint: "eg. BMW",
                    label: "Price",
                    isDesc: false,
                    controller: controller.ppriceController),
                10.heightBox,
                customTextField(
                    hint: "eg. 20",
                    label: "Quantity",
                    isDesc: false,
                    controller: controller.pqunantityController),
                10.heightBox,
                productDropdown("Category", controller.categoryList,
                    controller.categoryvalue, controller),
                10.heightBox,
                productDropdown("Sub Category", controller.subCategoryList,
                    controller.subcategoryvalue, controller),
                10.heightBox,
                const Divider(
                  color: white,
                ),
                boldText(text: "Choose Product Videos"),
                10.heightBox,
                /*  Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) {
                          final video = controller.pVideoList[index];

                          return Padding(
                            padding: EdgeInsets.only(
                                right:
                                    16.0), // Adjust the spacing between items as needed
                            child: video != null
                                ? InkWell(
                                    onTap: () {
                                      controller.videoPicker(index, context);
                                    },
                                    child: Image(
                                      image: FileImage(
                                        File(controller.thumbnail ?? ""),
                                      ),
                                      width: 100,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      controller.videoPicker(index, context);
                                    },
                                    child: ProductImages(label: "${index + 1}"),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),*/
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) {
                          final video = controller.pVideoList[index];

                          return Padding(
                            padding: EdgeInsets.only(
                                right:
                                    16.0), // Adjust the spacing between items as needed
                            child: video != null
                                ? InkWell(
                                    onTap: () {
                                      controller.videoPicker(index, context);
                                    },
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      controller.videoPicker(index, context);
                                    },
                                    child: ProductImages(label: "${index + 1}"),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                10.heightBox,
                const Divider(
                  color: white,
                ),
                boldText(text: "Choose Product Images"),
                10.heightBox,
                Obx(
                  () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) => controller.pImageList[index] != null
                            ? Image.file(
                                controller.pImageList[index],
                                width: 100,
                              ).onTap(() {
                                controller.pickImage(index, context);
                              })
                            : ProductImages(label: "${index + 1}").onTap(() {
                                controller.pickImage(index, context);
                              }),
                      )),
                ),
                10.heightBox,
                const Divider(
                  color: white,
                ),
                10.heightBox,
                boldText(text: "Choose Product Colors"),
                10.heightBox,
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                        colorsList.length,
                        (index) =>
                            Stack(alignment: Alignment.center, children: [
                              VxBox()
                                  .color(colorsList[index])
                                  .roundedFull
                                  .size(65, 65)
                                  .make()
                                  .onTap(() {
                                setState(() {
                                  if (selectedColorIndexes.value
                                      .contains(index)) {
                                    selectedColorIndexes.value.remove(index);
                                  } else {
                                    selectedColorIndexes.value.add(index);
                                  }
                                });
                              }),
                              if (selectedColorIndexes.value.contains(index))
                                const Icon(
                                  Icons.done,
                                  color: white,
                                ),
                            ])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
