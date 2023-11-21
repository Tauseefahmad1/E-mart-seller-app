import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/firebase_constants.dart';
import 'package:emart_seller/controllers/products_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/products_screen/add_product.dart';
import 'package:emart_seller/views/products_screen/components/Edit_product_screen.dart';
import 'package:emart_seller/views/products_screen/product_details.dart';
import 'package:emart_seller/views/profile_screen/edit_profileScreen.dart';
import 'package:emart_seller/views/widgets/appBar_widget.dart';
import 'package:emart_seller/views/widgets/our_button.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());
    final VxPopupMenuController _popupMenuController = VxPopupMenuController();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            await controller.getCategories();
            controller.populateCategoryList();
            Get.to(() => AddProduct());
          },
          child: Icon(Icons.add),
        ),
        appBar: appBarWidget(products),
        body: StreamBuilder(
          stream: StoreServices.getProducts(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: boldText(text: "No products to shown"),
              );
            } else {
              var data = snapshot.data!.docs;
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(
                        data.length,
                        (index) => ListTile(
                              onTap: () {
                                Get.to(() => ProductDetails(
                                      data: data[index],
                                    ));
                              },
                              leading: Image.network(
                                data[index]['p_imgs'][0],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              title: boldText(
                                  text: "${data[index]['p_name']}",
                                  color: fontGrey),
                              subtitle: Row(
                                children: [
                                  normalText(
                                      text: "\$${data[index]['p_price']}",
                                      color: darkGrey),
                                  2.widthBox,
                                  normalText(
                                      text: data[index]['is_featured']
                                          ? "Fetaured"
                                          : "",
                                      color: green),
                                ],
                              ),
                              trailing: VxPopupMenu(
                                controller: _popupMenuController,
                                arrowSize: 0.0,
                                child: Icon(Icons.more_vert_rounded),
                                menuBuilder: () => Column(
                                  children: List.generate(
                                      popMenuTitles.length,
                                      (i) => Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Icon(popMenuIconsList[i],
                                                    color:
                                                        data[index]['featured_id'] ==
                                                                    currentUser!
                                                                        .uid &&
                                                                i == 0
                                                            ? green
                                                            : darkGrey),
                                                10.widthBox,
                                                normalText(
                                                    text:
                                                        data[index]['featured_id'] ==
                                                                    currentUser!
                                                                        .uid &&
                                                                i == 0
                                                            ? "Remove Featured"
                                                            : popMenuTitles[i],
                                                    color: darkGrey)
                                              ],
                                            ).onTap(() {
                                              switch (i) {
                                                case 0:
                                                  _popupMenuController
                                                      .hideMenu();
                                                  if (data[index]
                                                          ['is_featured'] ==
                                                      true) {
                                                    controller.RemoveFeatured(
                                                        data[index].id);
                                                    VxToast.show(context,
                                                        msg:
                                                            "Removed from featured Product!!");
                                                  } else {
                                                    controller.addFeatured(
                                                        data[index].id);
                                                    VxToast.show(context,
                                                        msg:
                                                            "Added to featured Product!!");
                                                  }
                                                  break;
                                                case 1:
                                                  _popupMenuController
                                                      .hideMenu();
                                                  Get.to(() => EditProduct(
                                                        data: data[index],
                                                      ));
                                                  break;
                                                case 2:
                                                  _popupMenuController
                                                      .hideMenu();
                                                  controller.removeProduct(
                                                      data[index].id);
                                                  VxToast.show(context,
                                                      msg: "Product Removed");
                                                  break;
                                              }
                                            }),
                                          )),
                                ).box.white.rounded.width(200).make(),
                                clickType: VxClickType.singleClick,
                              ),
                            )),
                  ),
                ),
              );
            }
          },
        ));
  }
}

/**/

//
