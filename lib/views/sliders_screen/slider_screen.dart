import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/strings.dart';
import 'package:emart_seller/controllers/products_controller.dart';
import 'package:emart_seller/views/products_screen/components/product_images.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SlidersScreen extends StatefulWidget {
  const SlidersScreen({Key? key}) : super(key: key);

  @override
  State<SlidersScreen> createState() => _SlidersScreenState();
}

class _SlidersScreenState extends State<SlidersScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());
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

                      await controller.uploadImagesSlider1();
                      await controller.uploadImagesSlider2();
                      await controller.uploadImagesSlider3();
                      await controller.uploadSliderImages(
                        context,
                      );
                      Get.back();
                    },
                    child: normalText(text: save, color: white),
                  )
          ],
          title: boldText(text: "Choose Slider Images", color: white),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                boldText(text: "First Slider Images"),
                10.heightBox,
                Obx(
                  () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) => controller.pImageList1[index] != null
                            ? Image.file(
                                controller.pImageList1[index],
                                width: 100,
                              ).onTap(() {
                                controller.pickImage1(index, context);
                              })
                            : ProductImages(label: "${index + 1}").onTap(() {
                                controller.pickImage1(index, context);
                              }),
                      )),
                ),
                20.heightBox,
                const Divider(
                  color: white,
                ),
                boldText(text: "Second Slider Images"),
                10.heightBox,
                Obx(
                  () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) => controller.pImageList2[index] != null
                            ? Image.file(
                                controller.pImageList2[index],
                                width: 100,
                              ).onTap(() {
                                controller.pickImage2(index, context);
                              })
                            : ProductImages(label: "${index + 1}").onTap(() {
                                controller.pickImage2(index, context);
                              }),
                      )),
                ),
                20.heightBox,
                const Divider(
                  color: white,
                ),
                20.heightBox,
                boldText(text: "Third Slider Images"),
                10.heightBox,
                Obx(
                  () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) => controller.pImageList3[index] != null
                            ? Image.file(
                                controller.pImageList3[index],
                                width: 100,
                              ).onTap(() {
                                controller.pickImage3(index, context);
                              })
                            : ProductImages(label: "${index + 1}").onTap(() {
                                controller.pickImage3(index, context);
                              }),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
