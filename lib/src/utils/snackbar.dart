import 'package:flutter/material.dart';
import 'package:local/src/utils/colors.dart' as utils;
class Snackbar{
  static void showSnackbar(BuildContext context, GlobalKey<ScaffoldState> key, String text){
    // ignore: unnecessary_null_comparison
    if (context == null) return;
    // ignore: unnecessary_null_comparison
    if (key == null) return;
    if (key.currentState == null) return;
    FocusScope.of(context).requestFocus(new FocusNode());
    key.currentState?.removeCurrentSnackBar();
    key.currentState.showSnackBar(new SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14
        ),
      ),

      backgroundColor: utils.Colors.uberCloneColor2,
      duration: Duration(seconds: 3)
    ));
  }
}