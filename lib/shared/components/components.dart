

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:social_app/styles/themes.dart';

Widget defTextFormFiled(
    {TextEditingController? textEditingController,
      Widget? prefixIcon,
      Widget? suffixIcon,
      String? labelText,
      String? Function(String?)? validator,
      bool password = false,
      TextInputType? keyboardType,
      TextInputAction? textInputAction,
      bool readOnly = false,
      bool autofocus = false,
      String? hintText,
      Function(String)? onSubmitted,
      Function(String)? onChanged,
    }) {
  return TextFormField(
    autofocus: autofocus,
    style: TextStyle(fontWeight: FontWeight.bold),
    controller: textEditingController,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelText: labelText,
    ),
    validator: validator,
    obscureText: password,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    readOnly: readOnly,
    onChanged: onChanged,
    onFieldSubmitted: onSubmitted,
  );
}

Widget defButton(
    {required String text,
      required void Function() onPressed,
      Color textColor = Colors.white,
      Color? color}) {
  return Container(
    width: double.infinity,
    height: 50,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(
      color: defColor,
      borderRadius: BorderRadius.circular(5),
    ),
    child: MaterialButton(
      onPressed: onPressed,
      child: Text(
        '$text',
        style: TextStyle(
          color: textColor,
        ),
      ),
    ),
  );
}

PreferredSizeWidget defAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions
}){
  return AppBar(

    leading: IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: Icon(IconBroken.Arrow___Left_2),
    ),
    title: Text(title??''),
    titleSpacing: 5,
    actions: actions,

  );

}

defToast(
    {required String msg,
      Toast? toastLength,
      ToastGravity? gravity,
      int timeInSecForIosWeb = 5,
      Color backgroundColor = Colors.lightBlueAccent,
      Color textColor = Colors.white,
      double fontSize = 16}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize);
}