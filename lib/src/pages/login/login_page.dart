import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:local/src/utils/colors.dart' as utils;
import 'package:local/src/widgets/button_app.dart';
import 'package:local/src/pages/login/login_controller.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  RegisterController _con = new RegisterController();
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
            _textDescription(),
            _TextLogin(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.17),
            _textFieldEmail(),
            _textFieldPassword(),
            _buttonLogin(),
            _textDonthaveAccount()
          ],
        ),
      ),
    );
  }
  Widget _textDonthaveAccount(){
    return GestureDetector(
      onTap: _con.goToRegisterPage,
      child: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Text(
          'No tienes cuenta? Registrese',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey
          ),
        ),
      ),
    );
  }
  Widget _buttonLogin(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 25),
      child: ButtonApp(

        onPressed: _con.login,
        text: 'Iniciar Sesión',


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
  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
  }
  Widget _textDescription (){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        'Inicio Sesión',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 24,
        ),
      ),
    );
  }
  Widget _TextLogin(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Ingrese los datos',
            style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28

      ) ,
      ),

    );
  }
  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo(),
      child:  Container(
        //color: utils.Colors.uberCloneColor,
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
                  fontSize: 45,
              ),
            )
          ],
        ),
      ),
    );
  }
}
