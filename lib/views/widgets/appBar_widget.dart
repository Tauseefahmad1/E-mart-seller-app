import 'package:emart_seller/const/const.dart';
import 'package:intl/intl.dart' as intl;
import 'text_style.dart';

AppBar appBarWidget(title) {
  return AppBar(
    backgroundColor: white,
    automaticallyImplyLeading: false,
    title: boldText(text: title, color: fontGrey, size: 23.0),
    actions: [
      Center(
        child: normalText(
            text: intl.DateFormat('EEE, MMM d,' 'yy').format(DateTime.now()),
            color: darkGrey),
      ),
      10.widthBox,
    ],
  );
}
