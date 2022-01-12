import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:local/src/pages/home/home_controller.dart';
import 'package:local/src/utils/colors.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeController _con = new HomeController();
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
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [utils.Colors.uberCloneColor1,utils.Colors.uberCloneColor2,utils.Colors.uberCloneColor]
              )
          ),
          child: Column(
            children: [
              _bannerApp(context),
              SizedBox(height: 10),
              _textSelectYourRol(),
              SizedBox(height: 10),
             _imageTypeUser(context, 'assets/img/mane.png', 'productor'),
              SizedBox(height: 10),
              _textTypeUser('Productor'),
              SizedBox(height: 10),
              _imageTypeUser(context, 'assets/img/reciecuador.png', 'reciclador'),
              SizedBox(height: 10),
              _textTypeUser('Reciclador')

            ],

          ),
        ),
      ),
    );

  }
  Widget _bannerApp(BuildContext context){
    return ClipPath(
      clipper: WaveClipperTwo(),
      child:  Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.30,
        child: Row(
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
                  color: Colors.black,
                  fontSize: 45
              ),


            )
          ],
        ),
      ),
    );

  }
   Widget _textSelectYourRol(){
    return Text(
      'ELIJA SU ROL',
      style: TextStyle(
          color: Colors.white,
          fontSize: 25

      ),
    );
  }
  Widget _imageTypeUser(BuildContext context, String image, String typeUser){
    return GestureDetector(
      onTap: (){
        _con.goToLoginPage(typeUser);
      },
      child: CircleAvatar(
        backgroundImage: AssetImage(image),
        radius: 60,
        backgroundColor: utils.Colors.uberCloneColor1,
      ),
    );
  }
  Widget _textTypeUser(String typeUser) {
    return Text(
      typeUser,
      style: TextStyle(
          color: Colors.white,
          fontSize: 16
      ),
    );
  }

}