import 'package:flutter/material.dart';
import 'package:local/src/utils/colors.dart' as utils;

class  ButtonApp extends StatelessWidget {


  Color color;
  Color textColor;
  String text;
  IconData icon;
  Function onPressed;
  ButtonApp({
   this.color= Colors.green,
   this.textColor= Colors.black,
    this.icon = Icons.arrow_forward_ios,
    this.onPressed,
    this.text
});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
    onPressed:(){
      onPressed();
    },
    color: color,
      textColor: textColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 50,
              alignment: Alignment.center,
                child: Text(
                    text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
                )
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(

              height: 50,
              child: CircleAvatar(
                radius: 15,
                child: Icon(icon,
                    color: utils.Colors.uberCloneColor

                ) ,
                backgroundColor: Colors.white,
              ),
            ),
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}
