import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/text_style.dart';

Widget OurButton({title, color = Colors.red, onPress}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          primary: color,
          padding: EdgeInsets.all(12.0)),
      onPressed: onPress,
      child: normalText(text: title, size: 16.0));
}
