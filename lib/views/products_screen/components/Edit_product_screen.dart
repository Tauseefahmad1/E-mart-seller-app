import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/firebase_constants.dart';
import 'package:emart_seller/const/strings.dart';
import 'package:emart_seller/controllers/products_controller.dart';
import 'package:emart_seller/views/products_screen/components/product_dropdown.dart';
import 'package:emart_seller/views/products_screen/components/product_images.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/our_button.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Edit_product_screen.dart';
import 'Edit_product_screen.dart';

class EditProduct extends StatefulWidget {
  final dynamic data;

  const EditProduct({Key? key, required this.data}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final selectedColorIndexes = <int>[].obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.pnameController.text = widget.data['p_name'];
    controller.ppriceController.text = widget.data['p_price'];
    controller.pdescController.text = widget.data['p_desc'];
    controller.pqunantityController.text = widget.data['p_quantity'];
  }

  var controller = Get.put(ProductsController());

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
                      await controller.EditProduct(
                          doc: widget.data.id, context: context);
                      Get.back();
                    },
                    child: normalText(text: save, color: white),
                  )
          ],
          title: boldText(text: "Edit Product", color: fontGrey),
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
                  controller: controller.pnameController,
                ),
                10.heightBox,
                customTextField(
                  hint: "eg.Nice Product",
                  label: "Desc",
                  isDesc: true,
                  controller: controller.pdescController,
                ),
                10.heightBox,
                customTextField(
                  hint: "${widget.data.id}",
                  label: "Desc",
                  isDesc: true,
                  controller: controller.pdescController,
                ),
                10.heightBox,
                customTextField(
                  hint: "eg. BMW",
                  label: "Price",
                  isDesc: false,
                  controller: controller.ppriceController,
                ),
                10.heightBox,
                customTextField(
                  hint: "eg. 20",
                  label: "Quantity",
                  isDesc: false,
                  controller: controller.pqunantityController,
                ),
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
                    ),
                  ),
                ),
                5.heightBox,
                normalText(
                  text: "First Image will be your Display Image",
                  color: fontGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
