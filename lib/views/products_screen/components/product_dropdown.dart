import 'package:emart_seller/controllers/products_controller.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:emart_seller/const/const.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

Widget productDropdown(
    hint, List<String> list, dropValue, ProductsController controller) {
  return Obx(
    () => DropdownButtonHideUnderline(
            child: DropdownButton(
                hint: normalText(text: "$hint", color: fontGrey),
                value: dropValue.value == '' ? null : dropValue.value,
                isExpanded: true,
                items: list.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: e.toString().text.make(),
                  );
                }).toList(),
                onChanged: (value) {
                  if (hint == "Category") {
                    controller.subcategoryvalue.value = '';
                    controller.populateSubCategoryList(value.toString());
                  }
                  dropValue.value = value.toString();
                }))
        .box
        .white
        .padding(EdgeInsets.symmetric(horizontal: 4))
        .roundedSM
        .make(),
  );
}
