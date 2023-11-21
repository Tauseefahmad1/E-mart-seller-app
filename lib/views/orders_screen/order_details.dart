import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/controllers/orders_controller.dart';
import 'package:emart_seller/views/orders_screen/components/order_place_detail.dart';
import 'package:emart_seller/views/widgets/our_button.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({Key? key, this.data}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getOrders(widget.data);
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
  }

  var controller = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
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
            title: boldText(text: "Order Details", size: 16.0, color: fontGrey),
          ),
          bottomNavigationBar: Visibility(
            visible: !controller.confirmed.value,
            child: SizedBox(
              height: 60,
              width: context.screenWidth,
              child: OurButton(
                  color: red,
                  onPress: () {
                    controller.confirmed(true);
                    controller.changeStatus(
                        title: "order_confirmed",
                        status: true,
                        docId: widget.data.id);
                  },
                  title: "Confirm Order"),
            ),
          ),
          body: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Visibility(
                  visible: controller.confirmed.value,
                  child: Column(
                    children: [
                      //order delivery status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          boldText(
                              text: "Order Status : ",
                              color: darkGrey,
                              size: 16.0),
                          SwitchListTile(
                            activeColor: red,
                            value: true,
                            onChanged: (value) {},
                            title: boldText(text: "Placed", color: fontGrey),
                          ),
                          SwitchListTile(
                            activeColor: red,
                            value: controller.confirmed.value,
                            onChanged: (value) {
                              controller.confirmed.value = value;
                            },
                            title: boldText(text: "Confirmed", color: fontGrey),
                          ),
                          SwitchListTile(
                            activeColor: red,
                            value: controller.ondelivery.value,
                            onChanged: (value) {
                              controller.ondelivery.value = value;
                              controller.changeStatus(
                                  title: "order_on_delivery",
                                  status: value,
                                  docId: widget.data.id);
                            },
                            title:
                                boldText(text: "on Delivery", color: fontGrey),
                          ),
                          SwitchListTile(
                            activeColor: red,
                            value: controller.delivered.value,
                            onChanged: (value) {
                              controller.delivered.value = value;

                              controller.changeStatus(
                                  title: "order_delivered",
                                  status: value,
                                  docId: widget.data.id);
                            },
                            title: boldText(text: "Delivered", color: fontGrey),
                          )
                        ],
                      )
                          .box
                          .padding(EdgeInsets.all(8.0))
                          .outerShadowMd
                          .white
                          .border(color: lightGrey)
                          .roundedSM
                          .make(),
                      // order details sections
                      Column(
                        children: [
                          orderPlacedDetails(
                              d1: "${widget.data['order_code']}",
                              d2: " ${widget.data['shipping_method']}",
                              title1: "Order Code",
                              title2: "Shipping Method"),
                          orderPlacedDetails(
                              d1: intl.DateFormat()
                                  .add_yMd()
                                  .format((widget.data['order_date'].toDate())),
                              d2: "${widget.data['payment_method']}",
                              title1: "Order Date",
                              title2: "Payment Method"),
                          orderPlacedDetails(
                              d1: "${widget.data['paid']}",
                              d2: "Order Placed",
                              title1: "Payment Status",
                              title2: "Delivery Status"),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    boldText(
                                        text: "Shipping Address", color: red),
                                    "${widget.data['order_by_name']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_email']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_address']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_city']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_state']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_phone']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_postalcode']}"
                                        .text
                                        .make()
                                  ],
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      boldText(
                                          text: "Total Amount",
                                          color: fontGrey),
                                      boldText(
                                          text:
                                              "\$${widget.data['total_amount']}",
                                          color: red,
                                          size: 16.0),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                          .box
                          .outerShadowMd
                          .white
                          .border(color: lightGrey)
                          .roundedSM
                          .make(),
                      Divider(),
                      10.heightBox,
                      boldText(
                          text: "Order Products", color: fontGrey, size: 16.0),
                      10.heightBox,
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children:
                            List.generate(controller.orders.length, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              orderPlacedDetails(
                                  title1:
                                      "\$${controller.orders[index]['title']}",
                                  title2:
                                      "\$${controller.orders[index]['tprice']}",
                                  d1: "${controller.orders[index]['qty']}x",
                                  d2: "Refundable"),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  width: 30,
                                  height: 20,
                                  color:
                                      Color(controller.orders[index]['color']),
                                ),
                              ),
                              Divider()
                            ],
                          );
                        }).toList(),
                      )
                          .box
                          .outerShadowMd
                          .margin(EdgeInsets.only(bottom: 4))
                          .white
                          .make(),
                      25.heightBox,
                    ],
                  ),
                ),
              )),
        ));
  }
}
