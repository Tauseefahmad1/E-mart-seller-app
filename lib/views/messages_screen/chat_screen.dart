/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/strings.dart';
import 'package:emart_seller/controllers/chat_controller.dart';
import 'package:emart_seller/views/messages_screen/chat_bubbles.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emart_seller/services/store_services.dart';

import '../../const/firebase_constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    return Scaffold(
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
        title: boldText(text: chat, size: 16.0, color: fontGrey),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: StreamBuilder(
                      stream: StoreServices.getMessages(currentUser!.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Center(
                              child: "No Messages had been Sent "
                                  .text
                                  .color(darkGrey)
                                  .size(16)
                                  .make());
                        } else {
                          return ListView(
                            children: snapshot.data!.docs
                                .mapIndexed((currentValue, index) {
                              var data = snapshot.data!.docs[index];
                              return Align(
                                alignment: data['uid'] == currentUser!.uid
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: senderBubble(data),
                              );
                            }).toList(),
                          );
                        }
                      },
                    )),
            ),
            10.heightBox,
            10.heightBox,
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter message",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: fontGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: fontGrey))),
                  )),
                  IconButton(
                      onPressed: () {
                        controller.sendMsg(controller.msgController.text);
                        controller.msgController.clear();
                      },
                      icon: Icon(
                        Icons.send,
                        color: red,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/chat_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import '../../const/firebase_constants.dart';
import 'chat_bubbles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: "${controller.friendName}".text.color(fontGrey).make(),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: StreamBuilder(
                      stream: StoreServices.getChatMessages(
                          controller.chatDocId.toString()),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Center(
                              child: "No Messages had been Sent "
                                  .text
                                  .color(fontGrey)
                                  .size(16)
                                  .make());
                        } else {
                          return ListView(
                            children: snapshot.data!.docs
                                .mapIndexed((currentValue, index) {
                              var data = snapshot.data!.docs[index];
                              return Align(
                                alignment: data['uid'] == currentUser!.uid
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: senderBubble(data),
                              );
                            }).toList(),
                          );
                        }
                      },
                    )),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller.msgController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: textfieldGrey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textfieldGrey)),
                      hintText: "Type a message...."),
                )),
                IconButton(
                    onPressed: () {
                      controller.sendMsg(controller.msgController.text);
                      controller.msgController.clear();
                    },
                    icon: Icon(
                      Icons.send,
                      color: red,
                    ))
              ],
            )
                .box
                .height(82)
                .padding(EdgeInsets.all(12))
                .margin(EdgeInsets.only(bottom: 8))
                .make()
          ],
        ),
      ),
    );
  }
}
