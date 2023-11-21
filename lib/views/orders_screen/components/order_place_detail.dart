import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/cupertino.dart';

Widget orderPlacedDetails({title1, title2, d1, d2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            boldText(text: "$title1", color: red),
            boldText(text: "$d1", color: fontGrey)
          ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText(text: "$title2", color: red),
              boldText(text: "$d2", color: fontGrey)
            ],
          ),
        )
      ],
    ),
  );
}
