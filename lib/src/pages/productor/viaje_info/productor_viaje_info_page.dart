import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/src/pages/productor/viaje_info/productor_viaje_info_controller.dart';
import 'package:local/src/utils/colors.dart' as utils;
import 'package:local/src/widgets/button_app.dart';
class ProductorViajeInfoPage extends StatefulWidget {


  @override
  _ProductorViajeInfoPageState createState() => _ProductorViajeInfoPageState();
}

class _ProductorViajeInfoPageState extends State<ProductorViajeInfoPage> {
  ProductorViajeInfoController _con=new ProductorViajeInfoController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
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
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [utils.Colors.uberCloneColor4,utils.Colors.uberCloneColor2]
              )
          ),
        ),
      ),
      body: Stack(
        children: [
          Align(
            child: _googleMapsWidget(),
            alignment: Alignment.topCenter,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Align(
            child: _cardViajeInfo(),
            alignment: Alignment.bottomCenter,
          ),

        ],

      ),
    );
  }
  Widget _cardViajeInfo(){
    return Container(

      height: MediaQuery.of(context).size.height * 0.50,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          ListTile(
            title: Text(
              'Principal',
              style: TextStyle(
                fontSize: 15
              ),
            ),
            subtitle: Text(
              _con.from ?? '',
              style: TextStyle(
                fontSize: 13
              ),
            ),
            leading: Icon(Icons.my_location),
          ),
          ListTile(
            title: Text(
              'Transversal',
              style: TextStyle(
                  fontSize: 15
              ),
            ),
            subtitle: Text(
              _con.to ?? '',
              style: TextStyle(
                  fontSize: 13
              ),
            ),
            leading: Icon(Icons.my_location),
          ),
          ListTile(
            title: Text(
              'Oferta Reciclaje',
              style: TextStyle(
                  fontSize: 15
              ),
            ),
            subtitle: Text(
              _con.detalle ?? '',
              style: TextStyle(
                  fontSize: 13
              ),
            ),
            leading: Icon(Icons.add_shopping_cart),
          ),


          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: ButtonApp(
              onPressed: _con.goToRequest,
              text: 'CONFIRMAR',
              textColor: Colors.black,
              color: utils.Colors.uberCloneColor1,

            ),
          )
        ],
      ),
    );
  }
  Widget _buttonBack(){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color:Colors.black),


        ),
      ),
    );


  }
  Widget _googleMapsWidget(){


    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,

    );
  }
  void refresh(){
    setState(() {

    });

  }
}
