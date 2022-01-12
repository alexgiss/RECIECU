import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:local/src/pages/productor/viaje_request/productor_viaje_request_controller.dart';
import 'package:local/src/utils/colors.dart' as utils;
import 'package:local/src/widgets/button_app.dart';
import 'package:lottie/lottie.dart';
class ProductorViajeRequestPage extends StatefulWidget {

@override
_ProductorViajeRequestPageState createState() => _ProductorViajeRequestPageState();
}

class _ProductorViajeRequestPageState extends State<ProductorViajeRequestPage> {
  ProductorViajeRequestController _con= new ProductorViajeRequestController();
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
    _con.dispose();
  }
@override
Widget build(BuildContext context) {
return Scaffold(
  body: Column(
    children: [
      _viajeInfo(),
      _lottieAnimation(),
      _textLookingFor(),
      _textCounter(),

    ],
  ),
  bottomNavigationBar: _buttonCancel(),
);
}
Widget _lottieAnimation(){
    return Lottie.asset(
      'assets/json/8660-junkman-jon-truck.json',
      width: MediaQuery.of(context).size.width * 5,
      height: MediaQuery.of(context).size.height * 0.3,
      fit: BoxFit.fill
    );

}
Widget _textLookingFor(){
    return Container(
      child: Text(
        'Buscando Reciclador',
        style: TextStyle(
          fontSize: 16
        ),
      )
    );
}
Widget _textCounter(){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        '0',
        style: TextStyle(
            fontSize: 30
        ),
      )
  );
}
Widget _buttonCancel(){
    return Container(
      height: 50,
      margin: EdgeInsets.all(30),
      child: ButtonApp(
        text: 'Cancelar Entrega',
        color: utils.Colors.uberCloneColor1,
        icon: Icons.cancel_outlined,
        textColor: Colors.black,
      ),
    );
}
Widget _viajeInfo(){
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [utils.Colors.uberCloneColor4,utils.Colors.uberCloneColor2]
            )
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(

              radius: 50,
             backgroundImage: AssetImage('assets/img/profile.jpg'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Tu Reciclador',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
 void refresh(){
    setState(() {

    });
 }
}