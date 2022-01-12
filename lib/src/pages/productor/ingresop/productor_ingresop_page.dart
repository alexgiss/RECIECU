import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:local/src/pages/productor/ingresop/productor_ingresop_controller.dart';
import 'package:local/src/widgets/button_app.dart';
import 'package:local/src/utils/colors.dart' as utils;
class ProductorIngresopPage extends StatefulWidget {

  @override
  _ProductorIngresopPageState createState() => _ProductorIngresopPageState();
}

class _ProductorIngresopPageState extends State<ProductorIngresopPage> {
  ProductorIngresopController _con= new ProductorIngresopController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [utils.Colors.uberCloneColor4,utils.Colors.uberCloneColor2]
              )
          ),
        ),
      ),
      bottomNavigationBar: _buttonCalificate(),

      body: SingleChildScrollView(
        child: Column(

          children: [

            _bannerPriceInfo(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            _textCalificateYourDriver(),

            _textFieldIngreso(),

          ],
        ),
      ),
    );
  }

  Widget  _buttonCalificate() {

    return Container(
      height: 50,
      margin: EdgeInsets.all(20),
      child: ButtonApp(
        onPressed: _con.goRequest,
        text: 'SOLICITAR',
        color: utils.Colors.uberCloneColor1,

      ),
    );
  }
  Widget _textFieldIngreso(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.detalleController,
        maxLines: 4,
        decoration: InputDecoration(

            filled: true,
            fillColor: utils.Colors.uberCloneColor2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,

            )
        ),
      ),
    );
  }



  Widget _textCalificateYourDriver() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Ingreso Oferta Reciclaje',
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),
      ),
    );
  }



  Widget _bannerPriceInfo() {
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
  void refresh() {
    setState(() {

    });
  }
}