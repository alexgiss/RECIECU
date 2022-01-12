import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/src/models/productor.dart';
import 'package:local/src/pages/productor/map/productor_map_controller.dart';
import 'package:local/src/widgets/button_app.dart';
import 'package:local/src/utils/colors.dart' as utils;
class ProductorMapPage extends StatefulWidget {

  @override
  _ProductorMapPageState createState() => _ProductorMapPageState();
}
class _ProductorMapPageState extends State<ProductorMapPage> {
  ProductorMapController _con = new ProductorMapController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();

  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
        key: _con.key,
        drawer: _drawer(),
        body: Stack(
          children: [
            _googleMapsWidget(),
            SafeArea(
              child: Column(
                children: [
                  _buttonDrawer(),
                  _cardGooglePlaces(),
                  _buttonCenterPosition(),
                  Expanded(child: Container()),
                  _buttonRequest()

                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: _iconMyLocation(),
            )
          ],
        )
    );
  }
  Widget _iconMyLocation(){
    return Image.asset(
      'assets/img/my_location.png',
    width: 65,
      height: 65,
    );

  }
  Widget _drawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    _con.productor.username,
                    style: TextStyle(
                        fontSize:18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                ),
                Container(
                  child: Text(
                    _con.productor.email,
                    style: TextStyle(
                        fontSize:14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: _con.productor?.image != null
                      ? NetworkImage(_con.productor?.image)
                      : AssetImage('assets/img/profile.jpg'),
                  radius: 40,
                )
              ],
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[utils.Colors.uberCloneColor2,utils.Colors.uberCloneColor4]
                )
              //color: utils.Colors.uberCloneColor
            ),
          ),
          ListTile(
            title: Text('Editar Perfil'),
            trailing: Icon(Icons.edit),
            onTap: _con.goToEditPage,
          ),
          ListTile(
            title: Text('Historial Reciclaje'),
            trailing: Icon(Icons.edit),
            onTap: _con.goToHistoryPage,
          ),

          ListTile(
            title: Text('Cerrar Sesión'),
            trailing: Icon(Icons.power_settings_new),
            onTap: _con.signOut,
          ),
        ],
      ),
    );

  }
  Widget _buttonCenterPosition(){
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 18),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                  Icons.location_searching,
                  color: Colors.grey,
                  size: 20
              )
          ),
        ),
      ),
    );
  }
  Widget _buttonDrawer(){
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _con.openDrawer,
        icon: Icon(Icons.menu, color: Colors.white),
      ),
    );
  }
  Widget _buttonRequest(){
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonApp(
        onPressed: _con.requestViaje,
        text: 'SOLICITAR',
        color: utils.Colors.uberCloneColor4,
        textColor: Colors.black,
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
      onCameraMove: (position){
        _con.initialPosition = position;
        print('ON CAMERA MOVE: $position');
      },
      onCameraIdle: () async{
        await _con.setLocationDraggableInfo();
      },
    );
  }
  Widget _cardGooglePlaces(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCardLocation(
                  'Calle Principal',
                  _con.from ?? '',
              () async{
                    await _con.showGoogleAutoComplete(true);

              }
              ),
              SizedBox(height: 5),
              Container(
                // width: double.infinity,
                  child: Divider(color: Colors.grey, height: 10)
              ),
              SizedBox(height: 5),
              _infoCardLocation(
                  'Calle Transversal',
                  _con.to ?? '',
                      () async {
                    await _con.showGoogleAutoComplete(false);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _infoCardLocation(String title, String value, void Function() function){
    return GestureDetector(
      onTap: function,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 10
            ),
            textAlign: TextAlign.start,
          ),
          Text(
            value,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }


  void refresh(){
    setState(() {

    });
  }
}
