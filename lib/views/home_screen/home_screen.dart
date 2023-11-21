import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/firebase_constants.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/products_screen/product_details.dart';
import 'package:emart_seller/views/widgets/appBar_widget.dart';
import 'package:emart_seller/views/widgets/dashboard_buttons.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int orderLenght = 0;
  int usersLength = 0;

  final CollectionReference<Map<String, dynamic>> productList =
      FirebaseFirestore.instance.collection('orders');

  final CollectionReference<Map<String, dynamic>> productList2 =
      FirebaseFirestore.instance.collection('users');

  Future<int> countProducts() async {
    AggregateQuerySnapshot query = await productList.count().get();
    setState(() {
      orderLenght = query.count;
    });
    return Future.value(orderLenght);
  }

  Future<int> countUsers() async {
    AggregateQuerySnapshot query = await productList2.count().get();
    setState(() {
      usersLength = query.count;
    });
    return Future.value(usersLength);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countProducts();
    countUsers();
  }

  @override
  Widget build(BuildContext context) {
    num sumQuantity = 0;

    return Scaffold(
      appBar: appBarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: normalText(
                  text: "No popular product found",
                  color: darkGrey,
                  size: 18.0),
            );
          } else {
            var data = snapshot.data!.docs;
            data = data.sortedBy((a, b) =>
                b['p_wishlist'].length.compareTo(a['p_wishlist'].length));
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return dashboardButton(context,
                                title: 'products',
                                count: 0,
                                IconData: icProducts);
                          }

                          if (!snapshot.hasData) {
                            return dashboardButton(context,
                                title: 'products',
                                count: 0,
                                IconData: icProducts);
                          } else {
                            int sumQuantity =
                                0; // Create the variable sumQuantity
                            snapshot.data!.docs.forEach((doc) {
                              int? quantity = int.tryParse(doc["p_quantity"]);
                              if (quantity != null) {
                                sumQuantity += quantity;
                              }
                            });

                            return dashboardButton(context,
                                title: 'products',
                                count: sumQuantity,
                                IconData: icProducts);
                          }
                        },
                      ),
                      dashboardButton(context,
                          title: orders,
                          count: orderLenght,
                          IconData: icOrders),
                    ],
                  ),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dashboardButton(context,
                          title: "Users", count: usersLength, IconData: icUser),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return dashboardButton(context,
                                title: totalsale, count: 0, IconData: icStar);
                          }

                          if (!snapshot.hasData) {
                            return dashboardButton(context,
                                title: totalsale, count: 3, IconData: icStar);
                          } else {
                            int sumtotal = 0; // Create the variable sumQuantity
                            snapshot.data!.docs.forEach((doc) {
                              int? totalAmount =
                                  int.tryParse(doc["total_amount"]);
                              if (totalAmount != null) {
                                sumtotal += totalAmount;
                              }
                            });

                            return dashboardButton(context,
                                title: totalsale,
                                count: sumtotal,
                                IconData: icSale);
                          }
                        },
                      ),
                    ],
                  ),
                  10.heightBox,
                  Divider(),
                  10.heightBox,
                  boldText(text: popularProducts, color: fontGrey, size: 18.0),
                  20.heightBox,
                  ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: List.generate(
                        data.length,
                        (index) => data[index]['p_wishlist'].length == 0
                            ? SizedBox()
                            : ListTile(
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
                                subtitle: normalText(
                                    text: "\$${data[index]['p_price']}",
                                    color: darkGrey),
                              )),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
