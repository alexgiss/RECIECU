import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color: Colors.grey.shade400),
);

final inputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
  border: inputBorder,
  focusedBorder: inputBorder,
  enabledBorder: inputBorder,
);

// ignore: must_be_immutable
class OTPFields extends StatefulWidget {

  TextEditingController pin1;
  TextEditingController pin2;
  TextEditingController pin3;
  TextEditingController pin4;
  TextEditingController pin5;
  TextEditingController pin6;
  TextEditingController pin7;
  TextEditingController pin8;
  TextEditingController pin9;
  TextEditingController pin10;


  OTPFields({
   Key key,
    this.pin1,
    this.pin2,
    this.pin3,
    this.pin4,
    this.pin5,
    this.pin6,
    this.pin7,
    this.pin8,
    this.pin9,
    this.pin10,
  }) : super(key: key);

  @override
  _OTPFieldsState createState() => _OTPFieldsState();
}

class _OTPFieldsState extends State<OTPFields> {
  FocusNode pin1FN;
  FocusNode pin2FN;
  FocusNode pin3FN;
  FocusNode pin4FN;
  FocusNode pin5FN;
  FocusNode pin6FN;
  FocusNode pin7FN;
  FocusNode pin8FN;
  FocusNode pin9FN;
  FocusNode pin10FN;


  final pinStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    pin1FN = FocusNode();
    pin2FN = FocusNode();
    pin3FN = FocusNode();
    pin4FN = FocusNode();
    pin5FN = FocusNode();
    pin6FN = FocusNode();
    pin7FN = FocusNode();
    pin8FN = FocusNode();
    pin9FN = FocusNode();
    pin10FN = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin1FN.dispose();
    pin2FN.dispose();
    pin3FN.dispose();
    pin4FN.dispose();
    pin5FN.dispose();
    pin6FN.dispose();
    pin7FN.dispose();
    pin8FN.dispose();
    pin9FN.dispose();
    pin10FN.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 30,
                height: 35,

                child: TextFormField(
                  controller: widget.pin1,
                  autofocus: true,
                  style: pinStyle,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  onChanged: (value) {
                    nextField(value, pin2FN);
                  },
                ),
              ),
              SizedBox(
                width: 30,
                height: 35,

                child: TextFormField(
                  controller: widget.pin2,
                  focusNode: pin2FN,
                  style: pinStyle,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  onChanged: (value) => nextField(value, pin3FN),
                ),
              ),
              SizedBox(
                width: 30,
                height: 35,

                child: TextFormField(
                  controller: widget.pin3,
                  focusNode: pin3FN,
                  style: pinStyle,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  onChanged: (value) => nextField(value, pin4FN),
                ),
              ),
              SizedBox(
                width: 30,
                height: 35,

                child: TextFormField(
                  controller: widget.pin4,
                  focusNode: pin4FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) => nextField(value, pin5FN),
                ),
              ),
              SizedBox(
                width: 30,
                height: 35,

                child: TextFormField(
                  controller: widget.pin5,
                  focusNode: pin5FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) => nextField(value, pin6FN),
                ),
              ),
              SizedBox(
                width: 30,
                height: 35,
                child: TextFormField(
                  controller: widget.pin6,
                  focusNode: pin6FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) => nextField(value, pin7FN),
                ),
              ),
              SizedBox(
                width: 30,
                height: 35,
                child: TextFormField(
                  controller: widget.pin7,
                  focusNode: pin7FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) => nextField(value, pin8FN),
                ),
              ),
              SizedBox(
                width: 30,
                height: 35,
                child: TextFormField(
                  controller: widget.pin8,
                  focusNode: pin8FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) => nextField(value, pin9FN),
                ),
              ),
              SizedBox(
                width: 30,
                height: 35,
                child: TextFormField(
                  controller: widget.pin9,
                  focusNode: pin9FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) => nextField(value, pin10FN),
                ),
              ),
              SizedBox(
                width: 30,
                height: 35,
                child: TextFormField(
                  controller: widget.pin10,
                  focusNode: pin10FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin10FN.unfocus();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }




}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}