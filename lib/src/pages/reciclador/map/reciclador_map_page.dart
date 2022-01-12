import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/pages/reciclador/map/reciclador_map_controller.dart';
import 'package:local/src/widgets/button_app.dart';
import 'package:local/src/utils/colors.dart' as utils;

class RecicladorMapPage extends StatefulWidget {

  @override
  _RecicladorMapPageState createState() => _RecicladorMapPageState();
}

class _RecicladorMapPageState extends State<RecicladorMapPage> {

  RecicladorMapController _con= new RecicladorMapController();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonDrawer(),
                    _buttonCenterPosition()
                  ],
                ),
                Expanded(child: Container()),
                _buttonConnect()

              ],
            ),
          )
        ],
      )
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
                      _con.reciclador.username,
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
                      _con.reciclador.email,
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
                    backgroundImage: _con.reciclador?.image != null
                        ? NetworkImage(_con.reciclador?.image)
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
                ) //color: utils.Colors.uberCloneColor
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
        margin: EdgeInsets.symmetric(horizontal: 5),
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
  Widget _buttonConnect(){
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonApp(
        onPressed: _con.connect,
        text: _con.isConnect ? 'DESCONECTARSE' : 'CONECTARSE',
        color: _con.isConnect ? utils.Colors.uberCloneColor2 : utils.Colors.uberCloneColor4,
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
    );
  }
  void refresh(){
    setState(() {

    });
  }
}
