import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/firebase_constants.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/messages_screen/chat_screen.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          title: boldText(text: messages, size: 16.0, color: fontGrey),
        ),
        body: StreamBuilder(
          stream: StoreServices.getMessages(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: boldText(text: "No messages to show", color: fontGrey),
              );
            } else {
              var data = snapshot.data!.docs;
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(data.length, (index) {
                      var t = data[index]['created_on'] == null
                          ? DateTime.now()
                          : data[index]['created_on'].toDate();
                      var time = intl.DateFormat("h:mma").format(t);
                      return ListTile(
                        onTap: () {
                          Get.to(ChatScreen(), arguments: [
                            data[index]['sender_name'],
                            data[index]['fromId'],
                          ]);
                        },
                        leading: CircleAvatar(
                          backgroundColor: red,
                          child: Icon(
                            Icons.person,
                            color: white,
                          ),
                        ),
                        title: boldText(
                            text: '${data[index]['sender_name']}',
                            color: darkGrey),
                        subtitle: normalText(
                            text: "${data[index]['last_msg']}",
                            color: darkGrey),
                        trailing: normalText(text: time, color: darkGrey),
                      );
                    }),
                  ),
                ),
              );
            }
          },
        ));
  }
}
