import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:local/src/pages/productor/register/productor_register_controller.dart';
import 'package:local/src/utils/colors.dart' as utils;
import 'package:local/src/widgets/button_app.dart';

class ProductorRegisterPage extends StatefulWidget {


  @override
  _ProductorRegisterPageState createState() => _ProductorRegisterPageState();
}

class _ProductorRegisterPageState extends State<ProductorRegisterPage> {
  ProductorRegisterController _con = new ProductorRegisterController();
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
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
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
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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

  Widget _TextRegister(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Registro',
            style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25
      ),
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
