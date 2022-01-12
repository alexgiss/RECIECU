import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:local/src/pages/productor/viaje_calification/productor_viaje_calification_controller.dart';
import 'package:local/src/widgets/button_app.dart';
import 'package:local/src/utils/colors.dart' as utils;
class ProductorViajeCalificationPage extends StatefulWidget {

  @override
  _ProductorViajeCalificationPageState createState() => _ProductorViajeCalificationPageState();
}

class _ProductorViajeCalificationPageState extends State<ProductorViajeCalificationPage> {
  ProductorTravelCalificationController _con= new ProductorTravelCalificationController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      bottomNavigationBar: _buttonCalificate(),
      body: Column(
        children: [
          _bannerPriceInfo(),
          _listTileTravelInfo('Principal', _con.travelHistory?.from ?? '' , Icons.location_on),
          _listTileTravelInfo('Transversal', _con.travelHistory?.to ?? '' , Icons.location_on),
          _listTileTravelInfo('Oferta', _con.travelHistory?.detalle ?? '' , Icons.location_on),
          SizedBox(height: 10),
          _textCalificateYourDriver(),
          SizedBox(height: 10),
          _ratingBar()
        ],
      ),
    );
  }

  Widget _buttonCalificate() {
    return Container(
      height: 45,
      margin: EdgeInsets.all(30),
      child: ButtonApp(
        onPressed: _con.calificate,
        text: 'CALIFICAR',
        color: utils.Colors.uberCloneColor1,
      ),
    );
  }

  Widget _ratingBar() {
    return Center(
      child: RatingBar.builder(
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: utils.Colors.uberCloneColor,
          ),
          itemCount: 5,
          initialRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 4),
          unratedColor: Colors.grey[300],
          onRatingUpdate: (rating) {
            _con.calification = rating;
            print('RATING: $rating');
          }
      ),
    );
  }

  Widget _textCalificateYourDriver() {
    return Text(
      'CALIFICA A TU RECICLADOR',
      style: TextStyle(
          color: Colors.cyan,
          fontWeight: FontWeight.bold,
          fontSize: 18
      ),
    );
  }

  Widget _listTileTravelInfo(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),
          maxLines: 1,
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),
          maxLines: 2,
        ),
        leading: Icon(icon, color: Colors.grey,),
      ),
    );
  }

  Widget _bannerPriceInfo() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [utils.Colors.uberCloneColor4,utils.Colors.uberCloneColor2]
            )
        ),
        child: SafeArea(
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.grey[800], size: 100),
              SizedBox(height: 20),
              Text(
                'Reciclaje Retirado',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  void refresh() {
    setState(() {

    });
  }
}

