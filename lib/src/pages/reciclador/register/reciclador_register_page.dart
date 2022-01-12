import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:local/src/pages/reciclador/register/reciclador_register_controller.dart';
import 'package:local/src/utils/colors.dart' as utils;
import 'package:local/src/utils/otp_widget.dart';
import 'package:local/src/widgets/button_app.dart';

class RecicladorRegisterPage extends StatefulWidget {


  @override
  _RecicladorRegisterPageState createState() => _RecicladorRegisterPageState();
}

class _RecicladorRegisterPageState extends State<RecicladorRegisterPage> {
  RecicladorRegisterController _con = new RecicladorRegisterController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    utils.Colors.uberCloneColor2,utils.Colors.uberCloneColor4
                  ]
              )
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _TextRegister(),
            _textLicensePlate(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: OTPFields(
                pin1: _con.pin1Controller,
                pin2: _con.pin2Controller,
                pin3: _con.pin3Controller,
                pin4: _con.pin4Controller,
                pin5: _con.pin5Controller,
                pin6: _con.pin6Controller,
                pin7: _con.pin7Controller,
                pin8: _con.pin8Controller,
                pin9: _con.pin9Controller,
                pin10: _con.pin10Controller,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            _textFieldUsername(),
            _textFieldEmail(),
            _textFieldMobile(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _buttonRegister(),

          ],

        ),
      ),
    );
  }

  Widget _buttonRegister(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 25),
      child: ButtonApp(
        onPressed: _con.register,
        text: 'Registrarse Ahora',
          color: utils.Colors.uberCloneColor1,
        textColor: Colors.white,
      ),
    );
  }
  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.emailController,
        decoration: InputDecoration(
          hintText: 'correo@gmail.com',
          labelText: 'Correo Electrónico',
          suffixIcon: Icon(
            Icons.email_outlined,
            color: utils.Colors.uberCloneColor,
          )
        ),
      ),
    );
  }
  Widget _textFieldUsername(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
          hintText: 'Alex Perez',
          labelText: 'Nombres y Apellidos del usuario',
          suffixIcon: Icon(
            Icons.person_outline,
            color: utils.Colors.uberCloneColor,
          )
        ),
      ),
    );
  }
  Widget _textFieldMobile(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.mobileController,
        decoration: InputDecoration(
          hintText: '0989985356',
          labelText: 'Teléfono',
          suffixIcon: Icon(
            Icons.add_ic_call_outlined,
            color: utils.Colors.uberCloneColor,
          )
        ),
        keyboardType: TextInputType.phone,
        maxLength: 10,
      ),
    );
  }
  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: utils.Colors.uberCloneColor,
          )
        ),
      ),
    );
  }  Widget _textFieldConfirmPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Confirmar Contraseña',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: utils.Colors.uberCloneColor,
          )
        ),
      ),
    );
  }
  Widget _textLicensePlate(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Cédula del reciclador',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17
        ),
      ),
    );
  }

  Widget _TextRegister(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        'Registro',
            style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25

      ) ,
      ),

    );
  }
  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo(),
      child:  Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [utils.Colors.uberCloneColor4,utils.Colors.uberCloneColor2]
            )
        ),
        height: MediaQuery.of(context).size.height * 0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/logof.png',
              width: 150,
              height: 100,
            ),
            Text(
              'RECIECU',
              style: TextStyle(
                  fontFamily: 'GrandHotel',
                  color: Colors.white,
                  fontSize: 45
              ),


            )
          ],
        ),
      ),
    );

  }
}
