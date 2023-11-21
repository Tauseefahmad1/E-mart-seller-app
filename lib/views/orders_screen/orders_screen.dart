import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/firebase_constants.dart';
import 'package:emart_seller/controllers/orders_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/orders_screen/order_details.dart';
import 'package:emart_seller/views/widgets/appBar_widget.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(OrderController());
    return Scaffold(
        appBar: appBarWidget(orders),
        body: StreamBuilder(
          stream: StoreServices.getOrders(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: boldText(
                    text: "No orders has been placed.....", color: fontGrey),
              );
            } else {
              var data = snapshot.data!.docs;
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(data.length, (index) {
                      var time = data[index]['order_date'].toDate();
                      return ListTile(
                        onTap: () {
                          Get.to(() => OrderDetails(
                                data: data[index],
                              ));
                        },
                        tileColor: textfieldGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        title: boldText(
                            text: "${data[index]['order_code']}", color: red),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: fontGrey,
                                ),
                                10.widthBox,
                                boldText(
                                    text: intl.DateFormat()
                                        .add_yMd()
                                        .format(time),
                                    color: fontGrey),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.payment,
                                  color: fontGrey,
                                ),
                                10.widthBox,
                                boldText(
                                    text: "${data[index]['paid']}", color: red),
                              ],
                            ),
                          ],
                        ),
                        trailing: boldText(
                            text: "\$${data[index]['total_amount']}",
                            color: Colors.green),
                      ).box.margin(EdgeInsets.only(bottom: 4.0)).make();
                    }),
                  ),
                ),
              );
            }
          },
        ));
  }
}
